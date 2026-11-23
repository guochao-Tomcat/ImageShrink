#!/bin/bash
# Builds dist/ImageShrink.app (Apple Silicon + Intel) and dist/ImageShrink.zip. Runs on macOS.
set -euo pipefail
cd "$(dirname "$0")/.."

sw_vers
swift --version

swift build -c release --arch arm64 --arch x86_64
BIN_DIR=$(swift build -c release --arch arm64 --arch x86_64 --show-bin-path)

APP=dist/ImageShrink.app
rm -rf dist
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN_DIR/ImageShrink" "$APP/Contents/MacOS/ImageShrink"
cp Resources/Info.plist "$APP/Contents/Info.plist"
base64 -D < Resources/AppIcon.icns.b64 > "$APP/Contents/Resources/AppIcon.icns"
printf 'APPL????' > "$APP/Contents/PkgInfo"

# Ad-hoc signature (no Apple developer account): lets it run on Apple Silicon;
# first launch still needs System Settings → Privacy & Security → Open Anyway.
codesign --force --deep --sign - --timestamp=none "$APP"
codesign --verify --strict --verbose=2 "$APP"
lipo -info "$APP/Contents/MacOS/ImageShrink"

(cd dist && ditto -c -k --sequesterRsrc --keepParent ImageShrink.app ImageShrink.zip)
ls -la dist
