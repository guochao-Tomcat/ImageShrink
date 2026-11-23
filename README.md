# ImageShrink

A small Mac app: drop in a folder of high-res images and get web copies, each at most
**1000 px on the longest side** and **under 500 KB**, as sRGB JPEGs. Originals are never changed.

- Mirrors subfolders, skips hidden files and earlier ImageShrink output folders
- Turns camera-rotated photos upright, fills transparent areas with white
- Keeps title / copyright metadata (switchable)
- Steps JPEG quality down only as far as needed; lists anything that still won't fit, with a one-click "Retry smaller"
- Writes `ImageShrink log.txt` into the output folder

## Download

Get the latest `ImageShrink.zip` from **Releases**. Unzip, move `ImageShrink.app` to Applications.
First launch: macOS will block it (it isn't signed with a paid Apple developer certificate) —
close the warning, then **System Settings → Privacy & Security → Open Anyway**.

## Build

Every push to `main` builds a universal (Apple Silicon + Intel) app on GitHub's macOS runners,
runs a self-test of the image pipeline against real files on macOS (`scripts/selftest.sh`),
and publishes a release if everything passes. The result of each build is written to
`status.md` on the `build-status` branch.

Local build (needs Xcode or the Command Line Tools): `./scripts/build.sh`
