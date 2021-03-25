module "main" {
  source = "./modules/ecs"

  project     = "Leaderboard"
  environment = "lengutidev"
  region      = "us-east-1"
}