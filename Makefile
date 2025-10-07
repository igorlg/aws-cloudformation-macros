MACROS = $(subst .,,$(subst /,,$(dir $(shell find . -maxdepth 2 -type f -name template.yaml))))

SAM_BUILD_OPTS := --use-container

.PHONY: $(MACROS)

all: $(MACROS)

$(MACROS):
	pushd $@ \
	&& sam build  $(SAM_OPTS) $(SAM_BUILD_OPTS) \
	&& sam deploy $(SAM_OPTS) $(SAM_DEPLOY_OPTS)

# delete:
# 	for i in $(MACROS); do \
# 		cd $$i; \
# 		sam delete --no-prompts --region $(REGION); \
# 		cd ..; \
# 	done

# all_embedded:
# 	sam deploy

# delete_embedded:
# 	sam delete --no-prompts --region $(REGION)

# $(MACROS):
# 	cd $@ && sam deploy
