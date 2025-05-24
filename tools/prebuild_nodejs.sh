#!/bin/bash

# Prebuild for Node.js runtime
prebuild \
  --backend cmake-js \
  -t 15.1.0 \
  -t 14.3.0 \
  -t 12.16.3 \
  -t 10.20.1 \
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