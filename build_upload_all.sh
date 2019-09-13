#!/bin/bash
set -e

# Build all supported / currently used versions

make upload PLUGIN_ES=es63x ES_VERSION=6.4.3
make upload PLUGIN_ES=es66x ES_VERSION=6.8.3
make upload PLUGIN_ES=es73x ES_VERSION=7.3.1
