#!/bin/bash

# Clean build artifacts to ensure fresh build
echo "Cleaning build artifacts..."
rm -rf build
rm -rf wrap_js/dl_lib

# Prebuild for Node.js runtime
prebuild \
  --backend cmake-js \
  -t 22.15.1 \
  -t 20.18.0 \
  -t 18.18.2 \
  -t 16.20.2 \
  -t 15.1.0 \
  -t 14.3.0 \
  -r node \
  --verbose \
  --include-regex ".*(node|a|so|dll|dylib)$" \
  -- \
  -O build \
  --CDENABLE_SHARED=off \
  --CDENABLE_CAPI=off \
  --CDENABLE_JSONAPI=off \
  --CDENABLE_TESTS=off \
  --CDENABLE_JS_WRAPPER=off \
  --CDTARGET_RPATH="@executable_path;/usr/local/lib;/usr/local/lib64;\$\$ORIGIN/node_modules/cfd-js/build/Release;\$ORIGIN/node_modules/cfd-js/build/Release;\$ORIGIN/../node_modules/cfd-js/build/Release;\$ORIGIN/../../node_modules/cfd-js/build/Release;\$ORIGIN/../../../node_modules/cfd-js/build/Release;\$ORIGIN/../../../../node_modules/cfd-js/build/Release;\$ORIGIN/../../../../../node_modules/cfd-js/build/Release;\$ORIGIN/../../../../../../node_modules/cfd-js/build/Release;\$ORIGIN/build/Release;\$ORIGIN/wrap_js/dl_lib/lib" \
  -C 