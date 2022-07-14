MAKEFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: notarget
notarget:
	@make help
	@exit 1 ## I'd like to notice to fail if user call 'make' without any target.

.PHONY: help
help: ## Show documentation
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

bash: ## use bash
	docker-compose exec python bash

recreate: ## delete and restart docker
	docker-compose down -v --rmi all --remove-orphans
	docker-compose up -d

restart: ## restart docker
	docker-compose restart

freeze: ## show list of installed pip packages
	docker-compose exec python pip freeze

reinstall: ## uninstall all package and reinstall pip package
	./pip.sh uninstall -r requirements.txt -y
	./pip.sh install -r requirements.txt

sshkey: ## create ssh key
	ssh-keygen -t rsa -f $(MAKEFILE_DIR)key/id_rsa
