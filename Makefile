.PHONY: tf-init
tf-init:
	terraform -chdir=./terraform init

.PHONY: tf-plan
tf-plan:
	terraform -chdir=./terraform plan -var-file=../terraform.tfvars

.PHONY: tf-apply
tf-apply:
	terraform -chdir=./terraform apply

.PHONY: ansible-run
ansible-run:
	ansible-playbook ./ansible/playbook.yml --ask-vault-pass --skip-tags=bootstrap -i ./inventory

.PHONY: ansible-bootstrap
ansible-bootstrap:
	ansible-playbook ./ansible/playbook.yml --ask-vault-pass --tag=bootstrap -i ./inventory