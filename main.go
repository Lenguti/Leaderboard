package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/dimfeld/httptreemux"
	"github.com/rs/zerolog"
)

func main() {
	var (
		logger = zerolog.New(os.Stdout).With().Str("service", "leaderboard").Timestamp().Logger()
		ctx    = logger.WithContext(context.Background())
	)

	router := httptreemux.NewContextMux()
	router.GET("/healthcheck", HealthCheck)

	srv := &http.Server{
		Addr:         ":8080",
		Handler:      router,
		ReadTimeout:  time.Second,
		WriteTimeout: time.Second,
		IdleTimeout:  time.Second,
	}
	go func() {
		logger.Debug().Msg("Starting Leaderboard service.")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatal().Err(err).Msg("Error listening to requests.")
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	sig := <-quit
	logger.Info().Str("signal", sig.String()).Msg("Received signal, shutting down service.")
	ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		logger.Fatal().Err(err).Msg("Error shutting down service.")
	}
	logger.Debug().Msg("Gracefully shut down service.")
}

// HealthCheck -
func HealthCheck(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}
