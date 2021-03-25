INFRA_DIR := infrastructure

.PHONY: init
init  :
	@cd $(INFRA_DIR) && terraform init

.PHONY : preview
preview:
	@cd $(INFRA_DIR) && terraform plan -out tf.plan

.PHONY: apply
apply :
	@cd $(INFRA_DIR) && terraform apply tf.plan
