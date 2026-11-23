#!/bin/bash
# Runs the built app's image pipeline on real macOS against test images, then checks the output.
set -uo pipefail
cd "$(dirname "$0")/.."

python3 -m venv /tmp/venv
/tmp/venv/bin/pip -q install pillow numpy piexif
PY=/tmp/venv/bin/python
BIN=dist/ImageShrink.app/Contents/MacOS/ImageShrink
T=/tmp/selftest
rm -rf "$T"

$PY scripts/make_fixtures.py "$T/in" || exit 1
# Formats Pillow can't write: make them with macOS's own tools
sips -s format psd "$T/in/A.tif" --out "$T/in/photoshop.psd" >/dev/null
sips -s format heic "$T/in/A.tif" --out "$T/in/phone.heic" >/dev/null
ls -la "$T/in"

status=0
echo "=== Run 1: defaults (1000 px, under 500 KB, keep metadata)"
"$BIN" --selftest "$T/in" "$T/out1" || status=1
$PY scripts/verify.py "$T/out1" 1000 500000 full || status=1

echo "=== Run 2: tight limit (1000 px, under 50 KB) — OVER LIMIT must match real sizes"
"$BIN" --selftest "$T/in" "$T/out2" 1000 50000 || status=1
$PY scripts/verify.py "$T/out2" 1000 50000 limits || status=1

echo "=== Run 3: 2048 px, under 300 KB"
"$BIN" --selftest "$T/in" "$T/out3" 2048 300000 || status=1
$PY scripts/verify.py "$T/out3" 2048 300000 limits || status=1

echo "=== JPEG stress tests (scripts/jpeg_tests.py)"
t0=$(date +%s)
$PY scripts/jpeg_tests.py "$BIN" /tmp/jpegtest || status=1
echo "JPEG tests wall time: $(( $(date +%s) - t0 ))s"

echo "=== GUI launch smoke test"
open -n dist/ImageShrink.app && sleep 8
if pgrep -x ImageShrink >/dev/null; then echo "PASS app launched and is running"; pkill -x ImageShrink; else echo "FAIL app did not stay running"; status=1; fi

exit $status
