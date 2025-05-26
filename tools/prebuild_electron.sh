#!/bin/bash

# Clean build artifacts to ensure fresh build
echo "Cleaning build artifacts..."
rm -rf build
rm -rf wrap_js/dl_lib

# Prebuild for Electron runtime
prebuild \
  --backend cmake-js \
  -t 36.0.0 \
  -t 35.0.0 \
  -t 34.0.0 \
  -t 33.0.0 \
  -t 32.0.0 \
  -t 31.0.0 \
  -r electron \
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