NAME := frontlineeducation
PREFIX := fl-selenium-
MAINTAINER := "fl-Selenium <null@frontlineed.com>"
VERSION := $(or $(VERSION),$(VERSION),3.1.0-astatine)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chrome firefox chrome_debug firefox_debug standalone_chrome standalone_firefox standalone_chrome_debug standalone_firefox_debug

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_standalone_firefox \
	generate_standalone_chrome \
	generate_standalone_firefox_debug \
	generate_standalone_chrome_debug

build: all

ci: build test

base:
	cd ./Base && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/base:$(VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

hub: base generate_hub
	cd ./Hub && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/hub:$(VERSION) .

generate_nodebase:
	cd ./NodeBase && ./generate.sh $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

nodebase: base generate_nodebase
	cd ./NodeBase && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/node-base:$(VERSION) .

generate_chrome:
	cd ./NodeChrome && ./generate.sh $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

chrome: nodebase generate_chrome
	cd ./NodeChrome && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/node-chrome:$(VERSION) .

generate_firefox:
	cd ./NodeFirefox && ./generate.sh $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

firefox: nodebase generate_firefox
	cd ./NodeFirefox && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/fl-selenium-node-firefox:$(VERSION) .

generate_standalone_firefox:
	cd ./Standalone && ./generate.sh StandaloneFirefox node-firefox Firefox $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

standalone_firefox: generate_standalone_firefox firefox
	cd ./StandaloneFirefox && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/standalone-firefox:$(VERSION) .

generate_standalone_firefox_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneFirefoxDebug standalone-firefox Firefox $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

standalone_firefox_debug: generate_standalone_firefox_debug standalone_firefox
	cd ./StandaloneFirefoxDebug && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION) .

generate_standalone_chrome:
	cd ./Standalone && ./generate.sh StandaloneChrome node-chrome Chrome $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

standalone_chrome: generate_standalone_chrome chrome
	cd ./StandaloneChrome && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/standalone-chrome:$(VERSION) .

generate_standalone_chrome_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneChromeDebug standalone-chrome Chrome $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

standalone_chrome_debug: generate_standalone_chrome_debug standalone_chrome
	cd ./StandaloneChromeDebug && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION) .

generate_chrome_debug:
	cd ./NodeDebug && ./generate.sh NodeChromeDebug node-chrome Chrome $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

chrome_debug: generate_chrome_debug chrome
	cd ./NodeChromeDebug && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION) .

generate_firefox_debug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug node-firefox Firefox $(VERSION) $(PREFIX)$(NAME) $(MAINTAINER)

firefox_debug: generate_firefox_debug firefox
	cd ./NodeFirefoxDebug && docker build $(BUILD_ARGS) -t $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION) .

tag_latest:
	docker tag $(PREFIX)$(NAME)/base:$(VERSION) $(PREFIX)$(NAME)/base:latest
	docker tag $(PREFIX)$(NAME)/hub:$(VERSION) $(PREFIX)$(NAME)/hub:latest
	docker tag $(PREFIX)$(NAME)/node-base:$(VERSION) $(PREFIX)$(NAME)/node-base:latest
	docker tag $(PREFIX)$(NAME)/node-chrome:$(VERSION) $(PREFIX)$(NAME)/node-chrome:latest
	docker tag $(PREFIX)$(NAME)/node-firefox:$(VERSION) $(PREFIX)$(NAME)/node-firefox:latest
	docker tag $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/node-chrome-debug:latest
	docker tag $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/node-firefox-debug:latest
	docker tag $(PREFIX)$(NAME)/standalone-chrome:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome:latest
	docker tag $(PREFIX)$(NAME)/standalone-firefox:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox:latest
	docker tag $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome-debug:latest
	docker tag $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox-debug:latest

release_latest:
	docker push $(PREFIX)$(NAME)/base:latest
	docker push $(PREFIX)$(NAME)/hub:latest
	docker push $(PREFIX)$(NAME)/node-base:latest
	docker push $(PREFIX)$(NAME)/node-chrome:latest
	docker push $(PREFIX)$(NAME)/node-firefox:latest
	docker push $(PREFIX)$(NAME)/node-chrome-debug:latest
	docker push $(PREFIX)$(NAME)/node-firefox-debug:latest
	docker push $(PREFIX)$(NAME)/standalone-chrome:latest
	docker push $(PREFIX)$(NAME)/standalone-firefox:latest
	docker push $(PREFIX)$(NAME)/standalone-chrome-debug:latest
	docker push $(PREFIX)$(NAME)/standalone-firefox-debug:latest

tag_major_minor:
	docker tag $(PREFIX)$(NAME)/base:$(VERSION) $(PREFIX)$(NAME)/base:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/hub:$(VERSION) $(PREFIX)$(NAME)/hub:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/node-base:$(VERSION) $(PREFIX)$(NAME)/node-base:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/node-chrome:$(VERSION) $(PREFIX)$(NAME)/node-chrome:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/node-firefox:$(VERSION) $(PREFIX)$(NAME)/node-firefox:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/standalone-chrome:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/standalone-firefox:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR)
	docker tag $(PREFIX)$(NAME)/base:$(VERSION) $(PREFIX)$(NAME)/base:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/hub:$(VERSION) $(PREFIX)$(NAME)/hub:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/node-base:$(VERSION) $(PREFIX)$(NAME)/node-base:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/node-chrome:$(VERSION) $(PREFIX)$(NAME)/node-chrome:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/node-firefox:$(VERSION) $(PREFIX)$(NAME)/node-firefox:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/standalone-chrome:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/standalone-firefox:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(PREFIX)$(NAME)/base:$(VERSION) $(PREFIX)$(NAME)/base:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/hub:$(VERSION) $(PREFIX)$(NAME)/hub:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/node-base:$(VERSION) $(PREFIX)$(NAME)/node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/node-chrome:$(VERSION) $(PREFIX)$(NAME)/node-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/node-firefox:$(VERSION) $(PREFIX)$(NAME)/node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/standalone-chrome:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/standalone-firefox:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION) $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(PREFIX)$(NAME)/base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/node-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/node-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/node-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/node-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/node-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/node-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/standalone-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/standalone-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/standalone-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/standalone-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/standalone-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/standalone-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(PREFIX)$(NAME)/standalone-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(PREFIX)$(NAME)/standalone-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(PREFIX)$(NAME)/base:$(VERSION)
	docker push $(PREFIX)$(NAME)/hub:$(VERSION)
	docker push $(PREFIX)$(NAME)/node-base:$(VERSION)
	docker push $(PREFIX)$(NAME)/node-chrome:$(VERSION)
	docker push $(PREFIX)$(NAME)/node-firefox:$(VERSION)
	docker push $(PREFIX)$(NAME)/node-chrome-debug:$(VERSION)
	docker push $(PREFIX)$(NAME)/node-firefox-debug:$(VERSION)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(VERSION)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(VERSION)
	docker push $(PREFIX)$(NAME)/standalone-firefox:$(VERSION)
	docker push $(PREFIX)$(NAME)/standalone-chrome-debug:$(VERSION)
	docker push $(PREFIX)$(NAME)/standalone-firefox-debug:$(VERSION)
	docker push $(PREFIX)$(NAME)/base:$(MAJOR)
	docker push $(PREFIX)$(NAME)/hub:$(MAJOR)
	docker push $(PREFIX)$(NAME)/node-base:$(MAJOR)
	docker push $(PREFIX)$(NAME)/node-chrome:$(MAJOR)
	docker push $(PREFIX)$(NAME)/node-firefox:$(MAJOR)
	docker push $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR)
	docker push $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR)
	docker push $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR)
	docker push $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR)
	docker push $(PREFIX)$(NAME)/base:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/hub:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/node-base:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/node-chrome:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/node-firefox:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(PREFIX)$(NAME)/base:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/hub:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/node-base:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/node-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/node-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(PREFIX)$(NAME)/standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

test:
	./test.sh
	./sa-test.sh
	./test.sh debug
	./sa-test.sh debug

.PHONY: \
	all \
	base \
	build \
	chrome \
	chrome_debug \
	ci \
	firefox \
	firefox_debug \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_standalone_chrome \
	generate_standalone_firefox \
	generate_standalone_chrome_debug \
	generate_standalone_firefox_debug \
	hub \
	nodebase \
	release \
	standalone_chrome \
	standalone_firefox \
	standalone_chrome_debug \
	standalone_firefox_debug \
	tag_latest \
	test
