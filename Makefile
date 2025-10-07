MACROS = $(sort $(subst .,,$(subst /,,$(dir $(shell find . -maxdepth 2 -type f -name template.yaml)))))
BUILD_TARGETS :=  $(addsuffix /.aws-sam/build/template.yaml,$(MACROS))
DEPLOY_TARGETS := $(addsuffix /.aws-sam/result.txt,$(MACROS))

SAM_BUILD_OPTS := --use-container


build: $(BUILD_TARGETS)
deploy: $(DEPLOY_TARGETS)
all: deploy


$(BUILD_TARGETS): %/.aws-sam/build/template.yaml : %/template.yaml %/samconfig.toml %/lambda/
	pushd $(dir $<) && sam build $(SAM_BUILD_OPTS)

$(DEPLOY_TARGETS): %/.aws-sam/result.txt : %/.aws-sam/build/template.yaml
	pushd $(dir $(abspath $(@)/../)) && sam deploy
	date > $@

# all_embedded:
# 	sam deploy

# delete_embedded:
# 	sam delete --no-prompts --region $(REGION)

clean:
	find . -type d -name .aws-sam -exec rm -rf {} \; 2>/dev/null
