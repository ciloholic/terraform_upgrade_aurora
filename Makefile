init:
	@terraform init

plan:
	@terraform plan

apply:
	@terraform apply

destroy:
	@terraform destroy

val:
	@terraform validate

fmt:
	@terraform fmt -recursive

c:
	@terraform console

update:
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate terraform -r /root/src
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate provider aws -r /root/src
