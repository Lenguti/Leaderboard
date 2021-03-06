DOCKERFILE_DIR     := .
GOLANG_APP_DIR     := .
GOLANG_BINARY_DIR  := src
GOLANG_BINARY_NAME := service
CGO_ENABLED        := 0
GOOS               := linux
GOARCH             := amd64
INFRA_DIR          := infrastructure
REGION             := us-east-1
AWS_ECR_REPO       ?= $(shell cd $(INFRA_DIR) && terraform output --json | jq -r '.ecr_repository.value')

.PHONY: init
init  :
	@cd $(INFRA_DIR) && terraform init

.PHONY : preview
preview:
	@cd $(INFRA_DIR) && terraform plan -out tf.plan

.PHONY: apply
apply :
	@cd $(INFRA_DIR) && terraform apply tf.plan

.PHONY      : docker-login
docker-login:
	@aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(AWS_ECR_REPO)

.PHONY      : docker-build
docker-build: docker-login
	@docker build -t $(AWS_ECR_REPO):latest $(DOCKERFILE_DIR) && \
	docker push $(AWS_ECR_REPO):latest

clean:
	@rm $(GOLANG_BINARY_DIR)/$(GOLANG_BINARY_NAME)

build-local: GOOS=darwin
build-local: $(GOLANG_BINARY_DIR)/$(GOLANG_BINARY_NAME)

build: $(GOLANG_BINARY_DIR)/$(GOLANG_BINARY_NAME)

$(GOLANG_BINARY_DIR)/$(GOLANG_BINARY_NAME):
	@CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $@ $(GOLANG_APP_DIR)
