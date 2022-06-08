SHELL := /bin/bash
.DEFAULT_GOAL := init
.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

init:
	@terraform init -upgrade
plan:
	@aws-vault exec ${AWS_PROFILE} -- terraform plan
apply:
	@aws-vault exec ${AWS_PROFILE} -- terraform apply
destroy:
	@aws-vault exec ${AWS_PROFILE} -- terraform destroy
val:
	@terraform validate
fmt:
	@terraform fmt -recursive
c:
	@terraform console
update:
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate terraform -r /root/src
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate provider aws -r /root/src
