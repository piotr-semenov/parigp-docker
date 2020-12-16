-include dockerfile-commons/test-dockerignore.mk
-include dockerfile-commons/lint-dockerfiles.mk
-include dockerfile-commons/docker-funcs.mk

IMAGE_NAME ?= semenovp/tiny-parigp
PARIGP_VER ?= "2.13.0"
GP2C_VER ?= "0.0.12"


.PHONY: help
help:  ## Prints the help.
	@echo 'Commands:'
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'


.DEFAULT_GOAL := build
build: lint-dockerfiles build_gp build_gp2c;  ## Buolds all the images.


.PHONY: build_gp
build_gp: export ARGS=-f Dockerfile.pari .
build_gp: export BUILD_ARGS=parigp_version=$(PARIGP_VER)
build_gp: ## Builds the images for PARI/GP.
	@$(call build_docker_image,"$(IMAGE_NAME):latest","parigp_packages='' $(BUILD_ARGS)","$(ARGS)")
	@$(call build_docker_image,"$(IMAGE_NAME):latest-alldata","$(BUILD_ARGS)","$(ARGS)")


.PHONY: build_gp2c
build_gp2c:  ## Builds the image for GP2C/GP2C-RUN.
	@$(call build_docker_image,"$(IMAGE_NAME):gp2c-latest","gp2c_version=$(GP2C_VER)","-f Dockerfile.gp2c .")


.PHONY: test
test:  ## Tests the the already built images.
	@$(call goss_docker_image,$(IMAGE_NAME):latest,tests/gp.yaml,PARIGP_VER=$(PARIGP_VER))
	@$(call goss_docker_image,$(IMAGE_NAME):latest-alldata,tests/gp_alldata.yaml)

	@$(call goss_docker_image,$(IMAGE_NAME):gp2c-latest,tests/gp2c.yaml,PARIGP_VER=$(PARIGP_VER) GP2C_VER=$(GP2C_VER))
