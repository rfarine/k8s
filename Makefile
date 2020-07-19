SHELL := /bin/bash
ARGS ?= ""

.PHONY: run-api-command
run-api-command:
	@POD=$$(kubectl get pod -l app=api -o jsonpath="{.items[0].metadata.name}") ; \
	echo "Running $(CMD) on $$POD..." ; \
	kubectl exec $$POD -c api -- node commands/$(CMD) $(ARGS)

.PHONY: release
release:
	@if [ -z $(GH_RELEASE_PA_TOKEN) ]; then echo "Please provide GH_RELEASE_PA_TOKEN."; exit 1; fi;
	@echo "Triggering Github Release workflow..."
	@curl -X POST https://api.github.com/repos/rfarine/k8s/dispatches \
	-H 'Accept: application/vnd.github.everest-preview+json' \
	-H 'Authorization: token $(GH_RELEASE_PA_TOKEN)' \
	--data '{"event_type": "release"}'
	@echo "🌟 Done!"
