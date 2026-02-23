#!/bin/sh
#
# Copyright 2023 R3BL LLC. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Usage:
#   ./make-distro.sh build [chrome|firefox]   - Build extension(s) for testing
#   ./make-distro.sh publish [chrome|firefox]  - Build and publish extension(s)
#
# The "build" step produces artifacts for local testing:
#   - Chrome: shortlink.zip + dist/ with Chrome manifest (load as unpacked)
#   - Firefox: unsigned .zip in dist/web-ext-artifacts/
#
# The "publish" step builds AND publishes:
#   - Chrome: shortlink.zip (still requires manual upload to Chrome Web Store)
#   - Firefox: signs and publishes .xpi to AMO

# Use global web-ext if available, otherwise fall back to npx.
if command -v web-ext > /dev/null 2>&1; then
  WEB_EXT="web-ext"
else
  echo "web-ext not found globally, will use npx..."
  WEB_EXT="npx web-ext"
fi

webpack_build() {
  rm -rf dist
  npm run build || exit 1
}

build_chrome() {
  echo "Building Chrome extension..."
  rm -f shortlink.zip
  webpack_build
  cp public/manifest.chrome.json dist/manifest.json || exit 1
  cd dist
  zip ../shortlink.zip -r . || exit 1
  cd ..
  echo "Done: shortlink.zip (dist/ has Chrome manifest for local testing)"
}

build_firefox() {
  echo "Building Firefox extension..."
  webpack_build
  cp public/manifest.firefox.json dist/manifest.json || exit 1
  cd dist
  $WEB_EXT build --overwrite-dest || exit 1
  cd ..
  echo "Done: dist/web-ext-artifacts/r3bl_shortlink-*.zip (unsigned, for testing)"
}

# Build both from a single webpack build, leave dist/ with Chrome manifest.
build_all() {
  rm -f shortlink.zip
  webpack_build

  # Chrome artifact.
  echo "Building Chrome extension..."
  cp public/manifest.chrome.json dist/manifest.json || exit 1
  cd dist
  zip ../shortlink.zip -r . || exit 1
  cd ..
  echo "Done: shortlink.zip"

  # Firefox artifact.
  echo "Building Firefox extension..."
  cp public/manifest.firefox.json dist/manifest.json || exit 1
  cd dist
  $WEB_EXT build --overwrite-dest || exit 1
  cd ..
  echo "Done: dist/web-ext-artifacts/r3bl_shortlink-*.zip (unsigned, for testing)"

  # Leave dist/ with Chrome manifest for local testing.
  cp public/manifest.chrome.json dist/manifest.json
  echo "Note: dist/ has Chrome manifest. Load dist/ as unpacked in chrome://extensions."
}

publish_firefox() {
  build_firefox || exit 1
  echo "Signing and publishing Firefox extension to AMO..."
  cd dist
  $WEB_EXT sign --api-key=$MOZ_AMO_KEY --api-secret=$MOZ_AMO_SECRET --channel listed || exit 1
  cp web-ext-artifacts/r3bl_shortlink-*.xpi ../ || exit 1
  cd ..
  echo "Done: r3bl_shortlink-*.xpi (signed and published)"
}

ACTION="$1"
TARGET="$2"

case "$ACTION" in
  build)
    case "$TARGET" in
      chrome)  build_chrome ;;
      firefox) build_firefox ;;
      "")      build_all ;;
      *)       echo "Usage: $0 build [chrome|firefox]"; exit 1 ;;
    esac
    ;;
  publish)
    case "$TARGET" in
      chrome)  build_chrome; echo "Upload shortlink.zip to Chrome Web Store manually." ;;
      firefox) publish_firefox ;;
      "")      build_all && publish_firefox; echo "Upload shortlink.zip to Chrome Web Store manually." ;;
      *)       echo "Usage: $0 publish [chrome|firefox]"; exit 1 ;;
    esac
    ;;
  *)
    echo "Usage:"
    echo "  $0 build [chrome|firefox]    Build for testing"
    echo "  $0 publish [chrome|firefox]  Build and publish"
    exit 1
    ;;
esac
