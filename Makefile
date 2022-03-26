# Introspection of paths
#-----------------------------------------
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR := $(abspath $(dir $(mkfile_path)))

# TOOLS
#-----------------------------------------
ESP32_IDF_RUN = \
	docker run --rm -t \
		--user "$(shell id -u):$(shell id -g)" \
		--volume $(SOURCE_DIR):$(SOURCE_DIR):ro \
		--volume $(BUILD_DIR):$(BUILD_DIR) \
		--workdir $(BUILD_DIR) \
		espressif/idf

# BUILD
#-----------------------------------------
.PHONY: init-ontarget
init-ontarget:
	@mkdir -p -ma+rw $(BUILD_DIR)

.PHONY: build
build: BUILD_DIR = $(CURDIR)/build/ontarget
build: init-ontarget
	@$(ESP32_IDF_RUN) \
		idf.py --no-ccache --project-dir $(SOURCE_DIR) --build-dir "$(BUILD_DIR)" build