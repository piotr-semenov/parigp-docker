VCS_REF=$(shell git rev-parse --short HEAD)


.PHONY: help
help:  ## Prints the help.
	@echo 'Commands:'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'


.PHONY: test-dockerignore
test-dockerignore:  ## Lists all the files in the context directory accepted by .dockerignore.
	@docker build -f ./Dockerfile.build-context \
	 --no-cache \
	 -t $(LOCAL_PREFIX)build-context \
	 .
	@docker run --rm \
	 -t $(LOCAL_PREFIX)build-context
	@docker rmi $(LOCAL_PREFIX)build-context
