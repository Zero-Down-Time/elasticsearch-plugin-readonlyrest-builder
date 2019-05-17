PLUGIN_VERSION ?= 1.18.0
PLUGIN_ES ?= es66x
ES_VERSION ?= 6.7.1

S3_BUCKETS ?= zero-downtime
S3_PREFIX ?= logging/elasticsearch

REPO = https://github.com/sscarduzio/elasticsearch-readonlyrest-plugin
PACKAGE_NAME = readonlyrest

VERSION = $(PLUGIN_VERSION)_es$(ES_VERSION)
PACKAGE := $(PACKAGE_NAME)-$(VERSION).zip
PACKAGE_FILE := elasticsearch-readonlyrest-plugin/$(PLUGIN_ES)/build/distributions/$(PACKAGE)

.PHONY: test clean build all upload clean_s3

all: fetch build

clean:
	rm -rf elasticsearch-readonlyrest-plugin

fetch:
	[ -d elasticsearch-readonlyrest-plugin ] || git clone $(REPO)
	cd elasticsearch-readonlyrest-plugin && git checkout v$(VERSION)

build: $(PACKAGE_FILE)

$(PACKAGE_FILE):
	cd elasticsearch-readonlyrest-plugin && ./gradlew --no-daemon --exclude-task test --stacktrace $(PLUGIN_ES):ror '-PesVersion=$(ES_VERSION)'

upload: $(PACKAGE_FILE)
	for bucket in $(S3_BUCKETS); do \
	  aws s3 cp --acl public-read $(PACKAGE_FILE) s3://$$bucket/$(S3_PREFIX)/$(PACKAGE); \
	done

clean_s3:
	for bucket in $(S3_BUCKETS); do \
	  aws s3 rm --recursive --exclude "*" --include $(PACKAGE_NAME)-*.zip s3://$$bucket/$(S3_PREFIX); \
	done
