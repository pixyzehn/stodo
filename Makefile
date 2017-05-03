EXECUTABLE_NAME=stodo
SCHEME_NAME=stodo
FRAMEWORK_NAME = Stodo
WORKSPACE_NAME=stodo.xcworkspace
IDENTIFIER=com.pixyzehn.stodo
COMPONENTS_PLIST=Sources/stodo/Components.plist

TEMPORARY_FOLDER?=/tmp/$(FRAMEWORK_NAME).dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace '$(WORKSPACE_NAME)' -scheme '$(SCHEME_NAME)' DSTROOT=$(TEMPORARY_FOLDER)

OUTPUT_PACKAGE=$(FRAMEWORK_NAME).pkg
OUTPUT_FRAMEWORK=$(FRAMEWORK_NAME)Kit.framework
OUTPUT_FRAMEWORK_ZIP=$(FRAMEWORK_NAME)Kit.framework.zip

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/$(EXECUTABLE_NAME).app
CARTHAGEKIT_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/$(OUTPUT_FRAMEWORK)
CARTHAGE_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/$(EXECUTABLE_NAME)

FRAMEWORKS_FOLDER=/Library/Frameworks
BINARIES_FOLDER=/usr/local/bin

VERSION_STRING=$(shell agvtool what-marketing-version -terse1)

.PHONY: all bootstrap clean install package test uninstall

all: bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) build

bootstrap:
	git submodule update --init --recursive
	carthage bootstrap --platform macOS

test: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -f "$(OUTPUT_FRAMEWORK_ZIP)"
	rm -rf "$(TEMPORARY_FOLDER)"
	$(BUILD_TOOL) $(XCODEFLAGS) clean

install: package
	sudo installer -pkg $(FRAMEWORK_NAME).pkg -target /

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/$(OUTPUT_FRAMEWORK)"
	rm -f "$(BINARIES_FOLDER)/$(EXECUTABLE_NAME)"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(CARTHAGEKIT_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/$(OUTPUT_FRAMEWORK)"
	mv -f "$(CARTHAGE_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/$(EXECUTABLE_NAME)"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(PREFIX)/Frameworks" "$(PREFIX)/bin"
	cp -rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/$(OUTPUT_FRAMEWORK)" "$(PREFIX)/Frameworks/"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/$(EXECUTABLE_NAME)" "$(PREFIX)/bin/"
	install_name_tool -add_rpath "@executable_path/../Frameworks/$(OUTPUT_FRAMEWORK)/Versions/Current/Frameworks/"  "$(PREFIX)/bin/$(EXECUTABLE_NAME)"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "$(IDENTIFIER)" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

	(cd "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" && zip -q -r --symlinks - "$(OUTPUT_FRAMEWORK)") > "$(OUTPUT_FRAMEWORK_ZIP)"
