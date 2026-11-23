# Build 7 (main)
commit: 6cdda408e35dbb2d8b31e6a9e8ad4b2f8817dec9
build: success
selftest: success
release: success
run: https://github.com/guochao-Tomcat/ImageShrink/actions/runs/45146250079

## build errors

## build.log (last 120 lines)
32%: Compiling Clang module OpenGL
32%: Compiling Clang module _Builtin_stdatomic
32%: Compiling Clang module libDER
32%: Compiling Clang module _Builtin_intrinsics
32%: Compiling Clang module _Builtin_inttypes
37%: Compiling Clang module _Builtin_intrinsics
37%: Compiling Clang module _DarwinFoundation3
37%: Compiling Clang module Darwin
40%: Compiling Clang module _Builtin_inttypes
40%: Compiling Clang module Darwin
40%: Compiling Clang module simd
41%: Compiling Clang module simd
41%: Compiling Clang module CUPS
41%: Compiling Clang module MachO
41%: Compiling Clang module libkern
44%: Compiling Clang module launch
44%: Compiling Clang module ObjectiveC
44%: Compiling Clang module launch
44%: Compiling Clang module MachO
44%: Compiling Clang module libkern
44%: Compiling Clang module Spatial
44%: Compiling Clang module CUPS
48%: Compiling Clang module os_object
48%: Compiling Clang module ObjectiveC
48%: Compiling Clang module os_workgroup
50%: Compiling Clang module os_object
50%: Compiling Clang module Dispatch
50%: Compiling Clang module Spatial
50%: Compiling Clang module os_workgroup
50%: Compiling Clang module CoreFoundation
50%: Compiling Clang module XPC
54%: Compiling Clang module Dispatch
54%: Compiling Clang module os
54%: Compiling Clang module CoreFoundation
54%: Compiling Clang module XPC
54%: Compiling Clang module ColorSync
54%: Compiling Clang module CFNetwork
54%: Compiling Clang module Security
54%: Compiling Clang module IOKit
58%: Compiling Clang module os
58%: Compiling Clang module CFNetwork
58%: Compiling Clang module Security
58%: Compiling Clang module ColorSync
58%: Compiling Clang module IOKit
62%: Compiling Clang module CoreGraphics
62%: Compiling Clang module DiskArbitration
62%: Compiling Clang module CoreServices
64%: Compiling Clang module ImageIO
64%: Compiling Clang module CoreText
64%: Compiling Clang module CoreGraphics
64%: Compiling Clang module DiskArbitration
64%: Compiling Clang module CoreServices
67%: Compiling Clang module ImageIO
67%: Compiling Clang module CoreText
67%: Compiling Clang module Foundation
69%: Compiling Clang module Foundation
69%: Compiling Clang module IOSurface
69%: Compiling Clang module UniformTypeIdentifiers
69%: Compiling Clang module OSLog
69%: Compiling Clang module CoreData
69%: Compiling Clang module ApplicationServices
69%: Compiling Clang module Accessibility
69%: Compiling Clang module CoreTransferable
69%: Compiling Clang module Metal
69%: Compiling Clang module Symbols
74%: Compiling Clang module DataDetection
74%: Compiling Clang module CoreTransferable
74%: Compiling Clang module DataDetection
74%: Compiling Clang module Accessibility
74%: Compiling Clang module OSLog
74%: Compiling Clang module CoreData
74%: Compiling Clang module UniformTypeIdentifiers
79%: Compiling Clang module IOSurface
79%: Compiling Clang module ApplicationServices
79%: Compiling Clang module Symbols
79%: Compiling Clang module CoreVideo
79%: Compiling Clang module Metal
82%: Compiling Clang module CoreImage
82%: Compiling Clang module QuartzCore
82%: Compiling Clang module SwiftUICore
82%: Compiling Clang module CoreVideo
85%: Compiling Clang module AppKit
85%: Compiling Clang module QuartzCore
85%: Compiling Clang module CoreImage
86%: Compiling Clang module SwiftUICore
86%: Compiling Clang module AppKit
88%: Compiling Clang module SwiftUI
88%: Compiling AppModel.swift, Entry.swift, Processor.swift, Views.swift
88%: Compile 4 Swift source files (x86_64)
89%: Compiling Clang module SwiftUI
89%: Compiling AppModel.swift, Entry.swift, Processor.swift, Views.swift
89%: Compile 4 Swift source files (arm64)
90%: Discovering Swift tasks after 'Compiling AppModel.swift, Entry.swift, Processor.swift, Views.swift'
90%: Unblock downstream dependents of ImageShrink (x86_64)
90%: Copy ImageShrink.swiftmodule (x86_64)
90%: Copy ImageShrink.swiftdoc (x86_64)
90%: Copy ImageShrink.abi.json (x86_64)
90%: Link ImageShrink (x86_64)
90%: Copy ImageShrink.swiftsourceinfo (x86_64)
94%: Discovering Swift tasks after 'Compiling AppModel.swift, Entry.swift, Processor.swift, Views.swift'
94%: Unblock downstream dependents of ImageShrink (arm64)
94%: Copy ImageShrink.swiftmodule (arm64)
94%: Copy ImageShrink.swiftdoc (arm64)
94%: Copy ImageShrink.abi.json (arm64)
94%: Link ImageShrink (arm64)
94%: Copy ImageShrink.swiftsourceinfo (arm64)
98%: Create universal binary ImageShrink
98%: Generate ImageShrink.dSYM for ImageShrink
99%: Register execution policy exception for ImageShrink
100%: Build succeeded
Build complete!
dist/ImageShrink.app: replacing existing signature
dist/ImageShrink.app: valid on disk
dist/ImageShrink.app: satisfies its Designated Requirement
Architectures in the fat file: dist/ImageShrink.app/Contents/MacOS/ImageShrink are: x86_64 arm64 
total 1032
drwxr-xr-x   4 runner  staff     128 Nov 23 09:21 .
drwxr-xr-x  13 runner  staff     416 Nov 23 09:21 ..
drwxr-xr-x   3 runner  staff      96 Nov 23 09:21 ImageShrink.app
-rw-r--r--   1 runner  staff  527832 Nov 23 09:21 ImageShrink.zip

## selftest.log

[notice] A new release of pip is available: 26.2.2 -> 26.3
[notice] To update, run: /private/tmp/venv/bin/python3.15 -m pip install --upgrade pip
fixtures written to /tmp/selftest/in
IOServiceMatchingfailed for: AppleM2ScalerParavirtDriver
total 268104
-rw-r--r--   1 runner  wheel      6968 Nov 23 09:21 -dash.png
drwxr-xr-x  22 runner  wheel       704 Nov 23 09:21 .
drwxr-xr-x   3 runner  wheel        96 Nov 23 09:21 ..
-rw-r--r--   1 runner  wheel     76386 Nov 23 09:21 .hidden.jpg
-rw-r--r--   1 runner  wheel     51040 Nov 23 09:21 A.png
-rw-r--r--   1 runner  wheel  18000140 Nov 23 09:21 A.tif
-rw-r--r--   1 runner  wheel     16709 Nov 23 09:21 alpha.png
-rw-r--r--   1 runner  wheel  72000140 Nov 23 09:21 big_noise.tif
-rw-r--r--   1 runner  wheel        20 Nov 23 09:21 broken.jpg
-rw-r--r--   1 runner  wheel    447863 Nov 23 09:21 cmyk.jpg
-rw-r--r--   1 runner  wheel   3000140 Nov 23 09:21 fine_detail.tif
-rw-r--r--   1 runner  wheel  12000122 Nov 23 09:21 gray16.tif
-rw-r--r--   1 runner  wheel    226459 Nov 23 09:21 meta.jpg
-rw-r--r--   1 runner  wheel   1192312 Nov 23 09:21 motion.jpg
-rw-r--r--   1 runner  wheel        12 Nov 23 09:21 notes.txt
-rw-r--r--   1 runner  wheel  28800140 Nov 23 09:21 pano.tif
-rw-r--r--   1 runner  wheel    138802 Nov 23 09:21 phone.heic
-rw-r--r--   1 runner  wheel   1231748 Nov 23 09:21 photoshop.psd
drwxr-xr-x   4 runner  wheel       128 Nov 23 09:21 previous_1000px
-rw-r--r--   1 runner  wheel     21235 Nov 23 09:21 rotated.jpg
-rw-r--r--   1 runner  wheel     13173 Nov 23 09:21 small.jpg
drwxr-xr-x   3 runner  wheel        96 Nov 23 09:21 sub folder
=== Run 1: defaults (1000 px, under 500 KB, keep metadata)
IOServiceMatchingfailed for: AppleM2ScalerParavirtDriver
SCAN files=17 skipped=1 subfolders=2
ImageShrink — 2026-11-23 09:21
Source: /tmp/selftest/in
Limits: 1000px longest side, under 500 KB

STATUS	SOURCE	OUTPUT	SIZE_PX	QUALITY	KB	NOTES
OK	-dash.png	-dash.jpg	1000x667	92	63	
OK	A.png	A.jpg	667x1000	92	63	
OK	A.tif	A_tif.jpg	1000x667	92	63	
OK	alpha.png	alpha.jpg	1000x1000	92	25	
OK	big_noise.tif	big_noise.jpg	1000x667	92	373	
FAILED	broken.jpg	-	-	-	-	Could not be read — the file may be damaged or in an unsupported format
OK	cmyk.jpg	cmyk.jpg	1000x667	92	59	
OK	fine_detail.tif	fine_detail.jpg	1000x1000	40	495	
OK	gray16.tif	gray16.jpg	1000x667	92	42	
OK	meta.jpg	meta.jpg	1000x667	92	71	
OK	motion.jpg	motion.jpg	1000x667	92	72	
OK	pano.tif	pano.jpg	1000x67	92	14	
OK	phone.heic	phone.jpg	1000x666	92	64	
OK	photoshop.psd	photoshop.jpg	1000x667	92	66	
OK	rotated.jpg	rotated.jpg	500x1000	92	14	
OK	small.jpg	small.jpg	600x400	92	26	
OK	sub folder/深层/黄尧 山水 1975.JPG	sub folder/深层/黄尧 山水 1975.jpg	667x1000	92	70	

Done: 16 OK, 0 over limit, 1 failed (of 17).

OUTPUT FILES: 16
PASS -dash.jpg: RGB JPEG (JPEG RGB)
PASS -dash.jpg: 1000x667 within 1000px
INFO -dash.jpg: 63515 bytes, profile=sRGB IEC61966-2.1
PASS -dash.jpg: 63515 bytes under 500000
PASS -dash.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS A.jpg: RGB JPEG (JPEG RGB)
PASS A.jpg: 667x1000 within 1000px
INFO A.jpg: 63480 bytes, profile=sRGB IEC61966-2.1
PASS A.jpg: 63480 bytes under 500000
PASS A.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS A_tif.jpg: RGB JPEG (JPEG RGB)
PASS A_tif.jpg: 1000x667 within 1000px
INFO A_tif.jpg: 63489 bytes, profile=sRGB IEC61966-2.1
PASS A_tif.jpg: 63489 bytes under 500000
PASS A_tif.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS alpha.jpg: RGB JPEG (JPEG RGB)
PASS alpha.jpg: 1000x1000 within 1000px
INFO alpha.jpg: 25573 bytes, profile=sRGB IEC61966-2.1
PASS alpha.jpg: 25573 bytes under 500000
PASS alpha.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS big_noise.jpg: RGB JPEG (JPEG RGB)
PASS big_noise.jpg: 1000x667 within 1000px
INFO big_noise.jpg: 373316 bytes, profile=sRGB IEC61966-2.1
PASS big_noise.jpg: 373316 bytes under 500000
PASS big_noise.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS cmyk.jpg: RGB JPEG (JPEG RGB)
PASS cmyk.jpg: 1000x667 within 1000px
INFO cmyk.jpg: 59756 bytes, profile=sRGB IEC61966-2.1
PASS cmyk.jpg: 59756 bytes under 500000
PASS cmyk.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS fine_detail.jpg: RGB JPEG (JPEG RGB)
PASS fine_detail.jpg: 1000x1000 within 1000px
INFO fine_detail.jpg: 495883 bytes, profile=sRGB IEC61966-2.1
PASS fine_detail.jpg: 495883 bytes under 500000
PASS fine_detail.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS gray16.jpg: RGB JPEG (JPEG RGB)
PASS gray16.jpg: 1000x667 within 1000px
INFO gray16.jpg: 42087 bytes, profile=sRGB IEC61966-2.1
PASS gray16.jpg: 42087 bytes under 500000
PASS gray16.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS meta.jpg: RGB JPEG (JPEG RGB)
PASS meta.jpg: 1000x667 within 1000px
INFO meta.jpg: 71592 bytes, profile=sRGB IEC61966-2.1
PASS meta.jpg: 71592 bytes under 500000
PASS meta.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS motion.jpg: RGB JPEG (JPEG RGB)
PASS motion.jpg: 1000x667 within 1000px
INFO motion.jpg: 72222 bytes, profile=sRGB IEC61966-2.1
PASS motion.jpg: 72222 bytes under 500000
PASS motion.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS pano.jpg: RGB JPEG (JPEG RGB)
PASS pano.jpg: 1000x67 within 1000px
INFO pano.jpg: 14391 bytes, profile=sRGB IEC61966-2.1
PASS pano.jpg: 14391 bytes under 500000
PASS pano.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS phone.jpg: RGB JPEG (JPEG RGB)
PASS phone.jpg: 1000x666 within 1000px
INFO phone.jpg: 64273 bytes, profile=sRGB IEC61966-2.1
PASS phone.jpg: 64273 bytes under 500000
PASS phone.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS photoshop.jpg: RGB JPEG (JPEG RGB)
PASS photoshop.jpg: 1000x667 within 1000px
INFO photoshop.jpg: 66251 bytes, profile=sRGB IEC61966-2.1
PASS photoshop.jpg: 66251 bytes under 500000
PASS photoshop.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS rotated.jpg: RGB JPEG (JPEG RGB)
PASS rotated.jpg: 500x1000 within 1000px
INFO rotated.jpg: 14435 bytes, profile=sRGB IEC61966-2.1
PASS rotated.jpg: 14435 bytes under 500000
PASS rotated.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS small.jpg: RGB JPEG (JPEG RGB)
PASS small.jpg: 600x400 within 1000px
INFO small.jpg: 26510 bytes, profile=sRGB IEC61966-2.1
PASS small.jpg: 26510 bytes under 500000
PASS small.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS sub folder/深层/黄尧 山水 1975.jpg: RGB JPEG (JPEG RGB)
PASS sub folder/深层/黄尧 山水 1975.jpg: 667x1000 within 1000px
INFO sub folder/深层/黄尧 山水 1975.jpg: 70998 bytes, profile=sRGB IEC61966-2.1
PASS sub folder/深层/黄尧 山水 1975.jpg: 70998 bytes under 500000
PASS sub folder/深层/黄尧 山水 1975.jpg: sRGB profile (sRGB IEC61966-2.1)
PASS exists: big_noise.jpg
PASS dims big_noise.jpg: got 1000x667, want 1000x667
PASS exists: fine_detail.jpg
PASS dims fine_detail.jpg: got 1000x1000, want 1000x1000
PASS exists: A.jpg
PASS dims A.jpg: got 667x1000, want 667x1000
PASS exists: A_tif.jpg
PASS dims A_tif.jpg: got 1000x667, want 1000x667
PASS exists: -dash.jpg
PASS dims -dash.jpg: got 1000x667, want 1000x667
PASS exists: small.jpg
PASS dims small.jpg: got 600x400, want 600x400
PASS exists: pano.jpg
PASS dims pano.jpg: got 1000x67, want 1000x67
PASS exists: gray16.jpg
PASS dims gray16.jpg: got 1000x667, want 1000x667
PASS exists: cmyk.jpg
PASS dims cmyk.jpg: got 1000x667, want 1000x667
PASS exists: alpha.jpg
PASS dims alpha.jpg: got 1000x1000, want 1000x1000
PASS exists: rotated.jpg
PASS dims rotated.jpg: got 500x1000, want 500x1000
PASS exists: meta.jpg
PASS dims meta.jpg: got 1000x667, want 1000x667
PASS exists: photoshop.jpg
PASS dims photoshop.jpg: got 1000x667, want 1000x667
PASS exists: phone.jpg
PASS dims phone.jpg: got 1000x666, want 1000x667
PASS exists: motion.jpg
PASS dims motion.jpg: got 1000x667, want 1000x667
PASS exists: sub folder/深层/黄尧 山水 1975.jpg
PASS dims sub folder/深层/黄尧 山水 1975.jpg: got 667x1000, want 667x1000
PASS exactly 16 outputs (got 16: ['-dash.jpg', 'A.jpg', 'A_tif.jpg', 'alpha.jpg', 'big_noise.jpg', 'cmyk.jpg', 'fine_detail.jpg', 'gray16.jpg', 'meta.jpg', 'motion.jpg', 'pano.jpg', 'phone.jpg', 'photoshop.jpg', 'rotated.jpg', 'small.jpg', 'sub folder/深层/黄尧 山水 1975.jpg'])
PASS not created: notes.jpg
PASS not created: .hidden.jpg
PASS not created: previous_1000px/old.jpg
PASS not created: broken.jpg
PASS log reports broken.jpg as FAILED
PASS transparent area became white (corner (255, 255, 255))
PASS opaque area kept its colour (centre (200, 30, 30))
PASS rotation tag reset (orientation=1)
PASS rotated upright: top is red (254, 0, 0)
PASS rotated upright: bottom is blue (0, 0, 254)
PASS copyright kept ('Huang Yao Foundation')
PASS title kept ('Test title for ImageShrink')

SUMMARY full: 109 passed, 0 failed
=== Run 2: tight limit (1000 px, under 50 KB) — OVER LIMIT must match real sizes
IOServiceMatchingfailed for: AppleM2ScalerParavirtDriver
SCAN files=17 skipped=1 subfolders=2
ImageShrink — 2026-11-23 09:21
Source: /tmp/selftest/in
Limits: 1000px longest side, under 50 KB

STATUS	SOURCE	OUTPUT	SIZE_PX	QUALITY	KB	NOTES
OK	-dash.png	-dash.jpg	1000x667	80	41	
OK	A.png	A.jpg	667x1000	80	41	
OK	A.tif	A_tif.jpg	1000x667	80	40	
OK	alpha.png	alpha.jpg	1000x1000	92	25	
OK	big_noise.tif	big_noise.jpg	1000x667	35	47	
FAILED	broken.jpg	-	-	-	-	Could not be read — the file may be damaged or in an unsupported format
OK	cmyk.jpg	cmyk.jpg	1000x667	80	38	
OVER LIMIT	fine_detail.tif	fine_detail.jpg	1000x1000	30	358	
OK	gray16.tif	gray16.jpg	1000x667	92	42	
OK	meta.jpg	meta.jpg	1000x667	80	49	
OK	motion.jpg	motion.jpg	1000x667	80	49	
OK	pano.tif	pano.jpg	1000x67	92	14	
OK	phone.heic	phone.jpg	1000x666	80	41	
OK	photoshop.psd	photoshop.jpg	1000x667	80	43	
OK	rotated.jpg	rotated.jpg	500x1000	92	14	
OK	small.jpg	small.jpg	600x400	92	26	
OK	sub folder/深层/黄尧 山水 1975.JPG	sub folder/深层/黄尧 山水 1975.jpg	667x1000	76	49	

Done: 15 OK, 1 over limit, 1 failed (of 17).

OUTPUT FILES: 16
PASS -dash.jpg: RGB JPEG (JPEG RGB)
PASS -dash.jpg: 1000x667 within 1000px
INFO -dash.jpg: 41009 bytes, profile=sRGB IEC61966-2.1
PASS A.jpg: RGB JPEG (JPEG RGB)
PASS A.jpg: 667x1000 within 1000px
INFO A.jpg: 41604 bytes, profile=sRGB IEC61966-2.1
PASS A_tif.jpg: RGB JPEG (JPEG RGB)
PASS A_tif.jpg: 1000x667 within 1000px
INFO A_tif.jpg: 40951 bytes, profile=sRGB IEC61966-2.1
PASS alpha.jpg: RGB JPEG (JPEG RGB)
PASS alpha.jpg: 1000x1000 within 1000px
INFO alpha.jpg: 25573 bytes, profile=sRGB IEC61966-2.1
PASS big_noise.jpg: RGB JPEG (JPEG RGB)
PASS big_noise.jpg: 1000x667 within 1000px
INFO big_noise.jpg: 47679 bytes, profile=sRGB IEC61966-2.1
PASS cmyk.jpg: RGB JPEG (JPEG RGB)
PASS cmyk.jpg: 1000x667 within 1000px
INFO cmyk.jpg: 38264 bytes, profile=sRGB IEC61966-2.1
PASS fine_detail.jpg: RGB JPEG (JPEG RGB)
PASS fine_detail.jpg: 1000x1000 within 1000px
INFO fine_detail.jpg: 358850 bytes, profile=sRGB IEC61966-2.1
PASS gray16.jpg: RGB JPEG (JPEG RGB)
PASS gray16.jpg: 1000x667 within 1000px
INFO gray16.jpg: 42087 bytes, profile=sRGB IEC61966-2.1
PASS meta.jpg: RGB JPEG (JPEG RGB)
PASS meta.jpg: 1000x667 within 1000px
INFO meta.jpg: 49235 bytes, profile=sRGB IEC61966-2.1
PASS motion.jpg: RGB JPEG (JPEG RGB)
PASS motion.jpg: 1000x667 within 1000px
INFO motion.jpg: 49146 bytes, profile=sRGB IEC61966-2.1
PASS pano.jpg: RGB JPEG (JPEG RGB)
PASS pano.jpg: 1000x67 within 1000px
INFO pano.jpg: 14391 bytes, profile=sRGB IEC61966-2.1
PASS phone.jpg: RGB JPEG (JPEG RGB)
PASS phone.jpg: 1000x666 within 1000px
INFO phone.jpg: 41432 bytes, profile=sRGB IEC61966-2.1
PASS photoshop.jpg: RGB JPEG (JPEG RGB)
PASS photoshop.jpg: 1000x667 within 1000px
INFO photoshop.jpg: 43183 bytes, profile=sRGB IEC61966-2.1
PASS rotated.jpg: RGB JPEG (JPEG RGB)
PASS rotated.jpg: 500x1000 within 1000px
INFO rotated.jpg: 14435 bytes, profile=sRGB IEC61966-2.1
PASS small.jpg: RGB JPEG (JPEG RGB)
PASS small.jpg: 600x400 within 1000px
INFO small.jpg: 26510 bytes, profile=sRGB IEC61966-2.1
PASS sub folder/深层/黄尧 山水 1975.jpg: RGB JPEG (JPEG RGB)
PASS sub folder/深层/黄尧 山水 1975.jpg: 667x1000 within 1000px
INFO sub folder/深层/黄尧 山水 1975.jpg: 49952 bytes, profile=sRGB IEC61966-2.1
PASS limits -dash.jpg: OK and 41009 < 50000
PASS limits A.jpg: OK and 41604 < 50000
PASS limits A_tif.jpg: OK and 40951 < 50000
PASS limits alpha.jpg: OK and 25573 < 50000
PASS limits big_noise.jpg: OK and 47679 < 50000
PASS limits cmyk.jpg: OK and 38264 < 50000
PASS limits fine_detail.jpg: OVER LIMIT and 358850 >= 50000
PASS limits gray16.jpg: OK and 42087 < 50000
PASS limits meta.jpg: OK and 49235 < 50000
PASS limits motion.jpg: OK and 49146 < 50000
PASS limits pano.jpg: OK and 14391 < 50000
PASS limits phone.jpg: OK and 41432 < 50000
PASS limits photoshop.jpg: OK and 43183 < 50000
PASS limits rotated.jpg: OK and 14435 < 50000
PASS limits small.jpg: OK and 26510 < 50000
PASS limits sub folder/深层/黄尧 山水 1975.jpg: OK and 49952 < 50000

SUMMARY limits: 48 passed, 0 failed
=== Run 3: 2048 px, under 300 KB
IOServiceMatchingfailed for: AppleM2ScalerParavirtDriver
SCAN files=17 skipped=1 subfolders=2
ImageShrink — 2026-11-23 09:21
Source: /tmp/selftest/in
Limits: 2048px longest side, under 300 KB

STATUS	SOURCE	OUTPUT	SIZE_PX	QUALITY	KB	NOTES
OK	-dash.png	-dash.jpg	1500x1000	92	135	
OK	A.png	A.jpg	1365x2048	92	214	
OK	A.tif	A_tif.jpg	2048x1365	92	233	
OK	alpha.png	alpha.jpg	2000x2000	92	76	
OVER LIMIT	big_noise.tif	big_noise.jpg	2048x1365	30	316	
FAILED	broken.jpg	-	-	-	-	Could not be read — the file may be damaged or in an unsupported format
OK	cmyk.jpg	cmyk.jpg	2048x1365	92	196	
OVER LIMIT	fine_detail.tif	fine_detail.jpg	1000x1000	30	358	
OK	gray16.tif	gray16.jpg	2048x1365	92	136	
OK	meta.jpg	meta.jpg	2048x1365	92	246	
OK	motion.jpg	motion.jpg	2048x1365	92	247	
OK	pano.tif	pano.jpg	2048x137	92	36	
OK	phone.heic	phone.jpg	2048x1366	92	230	
OK	photoshop.psd	photoshop.jpg	2048x1365	92	235	
OK	rotated.jpg	rotated.jpg	800x1600	92	24	
OK	small.jpg	small.jpg	600x400	92	26	
OK	sub folder/深层/黄尧 山水 1975.JPG	sub folder/深层/黄尧 山水 1975.jpg	1365x2048	92	240	

Done: 14 OK, 2 over limit, 1 failed (of 17).

OUTPUT FILES: 16
PASS -dash.jpg: RGB JPEG (JPEG RGB)
PASS -dash.jpg: 1500x1000 within 2048px
INFO -dash.jpg: 135595 bytes, profile=sRGB IEC61966-2.1
PASS A.jpg: RGB JPEG (JPEG RGB)
PASS A.jpg: 1365x2048 within 2048px
INFO A.jpg: 214881 bytes, profile=sRGB IEC61966-2.1
PASS A_tif.jpg: RGB JPEG (JPEG RGB)
PASS A_tif.jpg: 2048x1365 within 2048px
INFO A_tif.jpg: 233679 bytes, profile=sRGB IEC61966-2.1
PASS alpha.jpg: RGB JPEG (JPEG RGB)
PASS alpha.jpg: 2000x2000 within 2048px
INFO alpha.jpg: 76637 bytes, profile=sRGB IEC61966-2.1
PASS big_noise.jpg: RGB JPEG (JPEG RGB)
PASS big_noise.jpg: 2048x1365 within 2048px
INFO big_noise.jpg: 316334 bytes, profile=sRGB IEC61966-2.1
PASS cmyk.jpg: RGB JPEG (JPEG RGB)
PASS cmyk.jpg: 2048x1365 within 2048px
INFO cmyk.jpg: 196814 bytes, profile=sRGB IEC61966-2.1
PASS fine_detail.jpg: RGB JPEG (JPEG RGB)
PASS fine_detail.jpg: 1000x1000 within 2048px
INFO fine_detail.jpg: 358850 bytes, profile=sRGB IEC61966-2.1
PASS gray16.jpg: RGB JPEG (JPEG RGB)
PASS gray16.jpg: 2048x1365 within 2048px
INFO gray16.jpg: 136907 bytes, profile=sRGB IEC61966-2.1
PASS meta.jpg: RGB JPEG (JPEG RGB)
PASS meta.jpg: 2048x1365 within 2048px
INFO meta.jpg: 246363 bytes, profile=sRGB IEC61966-2.1
PASS motion.jpg: RGB JPEG (JPEG RGB)
PASS motion.jpg: 2048x1365 within 2048px
INFO motion.jpg: 247751 bytes, profile=sRGB IEC61966-2.1
PASS pano.jpg: RGB JPEG (JPEG RGB)
PASS pano.jpg: 2048x137 within 2048px
INFO pano.jpg: 36857 bytes, profile=sRGB IEC61966-2.1
PASS phone.jpg: RGB JPEG (JPEG RGB)
PASS phone.jpg: 2048x1366 within 2048px
INFO phone.jpg: 230070 bytes, profile=sRGB IEC61966-2.1
PASS photoshop.jpg: RGB JPEG (JPEG RGB)
PASS photoshop.jpg: 2048x1365 within 2048px
INFO photoshop.jpg: 235960 bytes, profile=sRGB IEC61966-2.1
PASS rotated.jpg: RGB JPEG (JPEG RGB)
PASS rotated.jpg: 800x1600 within 2048px
INFO rotated.jpg: 24789 bytes, profile=sRGB IEC61966-2.1
PASS small.jpg: RGB JPEG (JPEG RGB)
PASS small.jpg: 600x400 within 2048px
INFO small.jpg: 26510 bytes, profile=sRGB IEC61966-2.1
PASS sub folder/深层/黄尧 山水 1975.jpg: RGB JPEG (JPEG RGB)
PASS sub folder/深层/黄尧 山水 1975.jpg: 1365x2048 within 2048px
INFO sub folder/深层/黄尧 山水 1975.jpg: 240907 bytes, profile=sRGB IEC61966-2.1
PASS limits -dash.jpg: OK and 135595 < 300000
PASS limits A.jpg: OK and 214881 < 300000
PASS limits A_tif.jpg: OK and 233679 < 300000
PASS limits alpha.jpg: OK and 76637 < 300000
PASS limits big_noise.jpg: OVER LIMIT and 316334 >= 300000
PASS limits cmyk.jpg: OK and 196814 < 300000
PASS limits fine_detail.jpg: OVER LIMIT and 358850 >= 300000
PASS limits gray16.jpg: OK and 136907 < 300000
PASS limits meta.jpg: OK and 246363 < 300000
PASS limits motion.jpg: OK and 247751 < 300000
PASS limits pano.jpg: OK and 36857 < 300000
PASS limits phone.jpg: OK and 230070 < 300000
PASS limits photoshop.jpg: OK and 235960 < 300000
PASS limits rotated.jpg: OK and 24789 < 300000
PASS limits small.jpg: OK and 26510 < 300000
PASS limits sub folder/深层/黄尧 山水 1975.jpg: OK and 240907 < 300000

SUMMARY limits: 48 passed, 0 failed
=== JPEG stress tests (scripts/jpeg_tests.py)
INFO small source: S800x600_small.jpg 56743 bytes at q55
PASS [matrix 500/30K] generic checks on 10 outputs (side 500, limit 30000)
INFO matrix 500/30K (0.2s): E1000x750=OK/q50/28K E1001x751=OK/q50/28K E1600x900=OK/q68/29K E1601x901=OK/q68/29K L4000x3000=OK/q72/28K M1600x1067=OK/q64/29K P3000x4000=OK/q72/28K S800x600_small=OK/q45/26K W5000x40_strip=OK/q92/5K one1x1=OK/q92/3K
PASS [matrix 500/100K] generic checks on 10 outputs (side 500, limit 100000)
INFO matrix 500/100K (0.2s): E1000x750=OK/q92/98K E1001x751=OK/q92/98K E1600x900=OK/q92/54K E1601x901=OK/q92/54K L4000x3000=OK/q92/47K M1600x1067=OK/q92/62K P3000x4000=OK/q92/47K S800x600_small=OK/q92/91K W5000x40_strip=OK/q92/5K one1x1=OK/q92/3K
PASS [matrix 500/250K] generic checks on 10 outputs (side 500, limit 250000)
INFO matrix 500/250K (0.2s): E1000x750=OK/q92/98K E1001x751=OK/q92/98K E1600x900=OK/q92/54K E1601x901=OK/q92/54K L4000x3000=OK/q92/47K M1600x1067=OK/q92/62K P3000x4000=OK/q92/47K S800x600_small=OK/q92/91K W5000x40_strip=OK/q92/5K one1x1=OK/q92/3K
PASS [matrix 500/500K] generic checks on 10 outputs (side 500, limit 500000)
INFO matrix 500/500K (0.2s): E1000x750=OK/q92/98K E1001x751=OK/q92/98K E1600x900=OK/q92/54K E1601x901=OK/q92/54K L4000x3000=OK/q92/47K M1600x1067=OK/q92/62K P3000x4000=OK/q92/47K S800x600_small=OK/q92/91K W5000x40_strip=OK/q92/5K one1x1=OK/q92/3K
PASS [matrix 500/2000K] generic checks on 10 outputs (side 500, limit 2000000)
INFO matrix 500/2000K (0.2s): E1000x750=OK/q92/98K E1001x751=OK/q92/98K E1600x900=OK/q92/54K E1601x901=OK/q92/54K L4000x3000=OK/q92/47K M1600x1067=OK/q92/62K P3000x4000=OK/q92/47K S800x600_small=OK/q92/91K W5000x40_strip=OK/q92/5K one1x1=OK/q92/3K
PASS [matrix 1000/30K] generic checks on 10 outputs (side 1000, limit 30000)
INFO matrix 1000/30K (1.0s): E1000x750=OVER/q30/60K E1001x751=OVER/q30/54K E1600x900=OVER/q30/34K E1601x901=OVER/q30/34K L4000x3000=OVER/q30/32K M1600x1067=OVER/q30/38K P3000x4000=OVER/q30/31K S800x600_small=OVER/q30/56K W5000x40_strip=OK/q92/8K one1x1=OK/q92/3K
PASS [matrix 1000/100K] generic checks on 10 outputs (side 1000, limit 100000)
INFO matrix 1000/100K (0.5s): E1000x750=OK/q35/78K E1001x751=OK/q40/86K E1600x900=OK/q55/96K E1601x901=OK/q55/96K L4000x3000=OK/q64/93K M1600x1067=OK/q50/87K P3000x4000=OK/q64/91K S800x600_small=OK/q64/96K W5000x40_strip=OK/q92/8K one1x1=OK/q92/3K
PASS [matrix 1000/250K] generic checks on 10 outputs (side 1000, limit 250000)
INFO matrix 1000/250K (0.4s): E1000x750=OK/q55/243K E1001x751=OK/q64/235K E1600x900=OK/q84/238K E1601x901=OK/q84/238K L4000x3000=OK/q92/243K M1600x1067=OK/q80/242K P3000x4000=OK/q92/242K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/8K one1x1=OK/q92/3K
PASS [matrix 1000/500K] generic checks on 10 outputs (side 1000, limit 500000)
INFO matrix 1000/500K (0.2s): E1000x750=OK/q92/438K E1001x751=OK/q92/396K E1600x900=OK/q92/275K E1601x901=OK/q92/275K L4000x3000=OK/q92/243K M1600x1067=OK/q92/322K P3000x4000=OK/q92/242K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/8K one1x1=OK/q92/3K
INFO small source re-encode: 60KB-class 800x600 -> 135757 bytes (x2.39), q92
PASS [matrix 1000/2000K] generic checks on 10 outputs (side 1000, limit 2000000)
INFO matrix 1000/2000K (0.2s): E1000x750=OK/q92/438K E1001x751=OK/q92/396K E1600x900=OK/q92/275K E1601x901=OK/q92/275K L4000x3000=OK/q92/243K M1600x1067=OK/q92/322K P3000x4000=OK/q92/242K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/8K one1x1=OK/q92/3K
PASS [matrix 1600/30K] generic checks on 10 outputs (side 1600, limit 30000)
INFO matrix 1600/30K (1.8s): E1000x750=OVER/q30/60K E1001x751=OVER/q30/59K E1600x900=OVER/q30/108K E1601x901=OVER/q30/97K L4000x3000=OVER/q30/70K M1600x1067=OVER/q30/125K P3000x4000=OVER/q30/67K S800x600_small=OVER/q30/56K W5000x40_strip=OK/q92/16K one1x1=OK/q92/3K
PASS [matrix 1600/100K] generic checks on 10 outputs (side 1600, limit 100000)
INFO matrix 1600/100K (1.2s): E1000x750=OK/q35/78K E1001x751=OK/q35/77K E1600x900=OVER/q30/108K E1601x901=OK/q30/97K L4000x3000=OK/q35/82K M1600x1067=OVER/q30/125K P3000x4000=OK/q35/81K S800x600_small=OK/q64/96K W5000x40_strip=OK/q92/16K one1x1=OK/q92/3K
PASS [matrix 1600/250K] generic checks on 10 outputs (side 1600, limit 250000)
INFO matrix 1600/250K (0.9s): E1000x750=OK/q55/243K E1001x751=OK/q55/243K E1600x900=OK/q40/199K E1601x901=OK/q45/206K L4000x3000=OK/q60/235K M1600x1067=OK/q40/232K P3000x4000=OK/q60/233K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/16K one1x1=OK/q92/3K
PASS [matrix 1600/500K] generic checks on 10 outputs (side 1600, limit 500000)
INFO matrix 1600/500K (0.7s): E1000x750=OK/q92/438K E1001x751=OK/q92/438K E1600x900=OK/q55/497K E1601x901=OK/q68/495K L4000x3000=OK/q80/485K M1600x1067=OK/q50/418K P3000x4000=OK/q80/483K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/16K one1x1=OK/q92/3K
PASS [matrix 1600/2000K] generic checks on 10 outputs (side 1600, limit 2000000)
INFO matrix 1600/2000K (0.3s): E1000x750=OK/q92/438K E1001x751=OK/q92/438K E1600x900=OK/q92/843K E1601x901=OK/q92/763K L4000x3000=OK/q92/687K M1600x1067=OK/q92/993K P3000x4000=OK/q92/685K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/16K one1x1=OK/q92/3K
PASS [matrix 4000/30K] generic checks on 10 outputs (side 4000, limit 30000)
INFO matrix 4000/30K (5.9s): E1000x750=OVER/q30/60K E1001x751=OVER/q30/59K E1600x900=OVER/q30/108K E1601x901=OVER/q30/109K L4000x3000=OVER/q30/773K M1600x1067=OVER/q30/125K P3000x4000=OVER/q30/769K S800x600_small=OVER/q30/56K W5000x40_strip=OK/q45/27K one1x1=OK/q92/3K
PASS [matrix 4000/100K] generic checks on 10 outputs (side 4000, limit 100000)
INFO matrix 4000/100K (6.0s): E1000x750=OK/q35/78K E1001x751=OK/q35/77K E1600x900=OVER/q30/108K E1601x901=OVER/q30/109K L4000x3000=OVER/q30/773K M1600x1067=OVER/q30/125K P3000x4000=OVER/q30/769K S800x600_small=OK/q64/96K W5000x40_strip=OK/q92/79K one1x1=OK/q92/3K
PASS [matrix 4000/250K] generic checks on 10 outputs (side 4000, limit 250000)
INFO matrix 4000/250K (5.3s): E1000x750=OK/q55/243K E1001x751=OK/q55/243K E1600x900=OK/q40/199K E1601x901=OK/q40/200K L4000x3000=OVER/q30/773K M1600x1067=OK/q40/232K P3000x4000=OVER/q30/769K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/79K one1x1=OK/q92/3K
PASS [matrix 4000/500K] generic checks on 10 outputs (side 4000, limit 500000)
INFO matrix 4000/500K (5.2s): E1000x750=OK/q92/438K E1001x751=OK/q92/438K E1600x900=OK/q55/497K E1601x901=OK/q50/359K L4000x3000=OVER/q30/773K M1600x1067=OK/q50/418K P3000x4000=OVER/q30/769K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/79K one1x1=OK/q92/3K
PASS [matrix 4000/2000K] generic checks on 10 outputs (side 4000, limit 2000000)
INFO matrix 4000/2000K (2.5s): E1000x750=OK/q92/438K E1001x751=OK/q92/438K E1600x900=OK/q92/843K E1601x901=OK/q92/848K L4000x3000=OK/q40/1509K M1600x1067=OK/q92/993K P3000x4000=OK/q40/1506K S800x600_small=OK/q92/135K W5000x40_strip=OK/q92/79K one1x1=OK/q92/3K
PASS [matrix nometa 1000/100K] generic checks on 10 outputs (side 1000, limit 100000)
PASS [matrix nometa 4000/2000K] generic checks on 10 outputs (side 4000, limit 2000000)
INFO profiles: {'cmyk': '/System/Library/ColorSync/Profiles/Generic CMYK Profile.icc', 'srgb': '/System/Library/ColorSync/Profiles/sRGB Profile.icc', 'gray': '/System/Library/ColorSync/Profiles/Generic Gray Gamma 2.2 Profile.icc', 'prophoto': '/System/Library/ColorSync/Profiles/ROMM RGB.icc', 'adobe': '/System/Library/ColorSync/Profiles/AdobeRGB1998.icc', 'p3': '/System/Library/ColorSync/Profiles/Display P3.icc'}
INFO fixture p3: ICC 'Display P3', raw patch values [(233, 52, 35), (117, 251, 76), (0, 0, 244), (190, 124, 74)] (sRGB originals [(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)])
INFO fixture adobe: ICC 'Adobe RGB (1998)', raw patch values [(218, 0, 0), (144, 255, 60), (0, 0, 250), (180, 118, 67)] (sRGB originals [(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)])
INFO fixture prophoto: ICC 'ROMM RGB: ISO 22028-2:2013', raw patch values [(178, 69, 26), (137, 237, 77), (86, 35, 234), (148, 111, 59)] (sRGB originals [(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)])
INFO fixture cmyk_sips: mode CMYK
INFO thumbnail: embedded EXIF thumbnail 34553 bytes
INFO huge: 16522013 bytes
INFO clash folder listing: ['A.jpeg', 'a.JPEG.jpg', 'a.jpg', 'a_jpeg.jpg', 'café.jpeg', 'café.jpg']
special fixtures: 52 files
--- special run A: side 1000 limit 500000 nometa=False rc=0 0.6s SCAN files=52 skipped=0 subfolders=40
PASS [special A] generic checks on 46 outputs (side 1000, limit 500000)
   LOG OK	clash/A.jpeg	clash/A.jpg	300x200	92	5	
   LOG OK	clash/a.JPEG.jpg	clash/a.JPEG.jpg	300x200	92	5	
   LOG OK	clash/a.jpg	clash/a_jpg.jpg	300x200	92	4	
   LOG OK	clash/a_jpeg.jpg	clash/a_jpeg.jpg	300x200	92	5	
   LOG OK	clash/café.jpeg	clash/café.jpg	300x200	92	5	
   LOG OK	clash/café.jpg	clash/café_jpg.jpg	300x200	92	5	
   LOG OK	colour/cmyk_adobe.jpg	colour/cmyk_adobe.jpg	400x100	92	5	
   LOG OK	colour/cmyk_noadobe.jpg	colour/cmyk_noadobe.jpg	400x100	92	5	
   LOG OK	colour/cmyk_sips_generic.jpg	colour/cmyk_sips_generic.jpg	400x100	92	5	
   LOG OK	colour/gray_L.jpg	colour/gray_L.jpg	500x100	92	5	
   LOG OK	colour/gray_L_tagged.jpg	colour/gray_L_tagged.jpg	500x100	92	5	
   LOG OK	colour/p3_pure_red.jpg	colour/p3_pure_red.jpg	200x100	92	4	
   LOG OK	colour/tagged_adobe.jpg	colour/tagged_adobe.jpg	400x100	92	5	
   LOG OK	colour/tagged_p3.jpg	colour/tagged_p3.jpg	400x100	92	5	
   LOG OK	colour/tagged_prophoto.jpg	colour/tagged_prophoto.jpg	400x100	92	5	
   LOG OK	colour/untagged.jpg	colour/untagged.jpg	400x100	92	5	
   LOG OK	deep/d01/d02/d03/d04/d05/d06/d07/d08/d09/d10/d11/d12/d13/d14/d15/d16/d17/d18/d19/d20/d21/d22/d23/d24/d25/d26/d27/d28/d29/d30/deep.jpg	deep/d01/d02/d03/d04/d05/d06/d07/d08/d09/d10/d11/d12/d13/d14/d15/d16/d17/d18/d19/d20/d21/d22/d23/d24/d25/d26/d27/d28/d29/d30/deep.jpg	300x200	92	4	
   LOG OK	edge/exact1000.jpg	edge/exact1000.jpg	1000x600	92	354	
   LOG OK	edge/huge12000x8000.jpg	edge/huge12000x8000.jpg	1000x667	92	215	
   LOG FAILED	edge/notajpeg.jpg	-	-	-	-	Could not be read — the file may be damaged or in an unsupported format
   LOG OK	edge/one1x1.jpg	edge/one1x1.jpg	1x1	92	3	
   LOG OK	edge/plus1_1001.jpg	edge/plus1_1001.jpg	1000x600	92	321	
   LOG FAILED	edge/truncated_half.jpg	-	-	-	-	The file is incomplete — it looks cut off or only partly downloaded
   LOG FAILED	edge/truncated_half_progressive.jpg	-	-	-	-	The file is incomplete — it looks cut off or only partly downloaded
   LOG FAILED	edge/zero.jpg	-	-	-	-	Could not be read — the file may be damaged or in an unsupported format
   LOG OK	enc/optimized_restart.jpg	enc/optimized_restart.jpg	1000x667	92	257	
   LOG OK	enc/progressive.jpg	enc/progressive.jpg	1000x667	92	261	
   LOG OK	enc/q100.jpg	enc/q100.jpg	1000x667	92	261	
   LOG OK	enc/s420.jpg	enc/s420.jpg	1000x667	92	261	
   LOG OK	enc/s444.jpg	enc/s444.jpg	1000x667	92	263	
   LOG OK	ext/ext_v.jfif	ext/ext_v.jpg	300x200	92	5	
   LOG OK	ext/ext_w.jpe	ext/ext_w.jpg	300x200	92	5	
   LOG OK	ext/ext_x.jpeg	ext/ext_x.jpg	300x200	92	5	
   LOG OK	ext/ext_y.JPG	ext/ext_y.jpg	300x200	92	5	
   LOG OK	ext/ext_z.Jpeg	ext/ext_z.jpg	300x200	92	5	
   LOG OK	meta/all.jpg	meta/all.jpg	1000x750	92	410	
   LOG OK	meta/exif.jpg	meta/exif.jpg	1000x750	92	357	
   LOG OK	meta/exif_thumb.jpg	meta/exif_thumb.jpg	1000x750	92	357	
   LOG OK	meta/flat_xmp50k.jpg	meta/flat_xmp50k.jpg	1000x750	92	68	
   LOG OK	meta/iptc.jpg	meta/iptc.jpg	1000x750	92	360	
   LOG OK	meta/xmp50k.jpg	meta/xmp50k.jpg	1000x750	92	410	
   LOG OK	meta/xmp_iccstring.jpg	meta/xmp_iccstring.jpg	1000x750	92	360	
   LOG OK	orient/o1.jpg	orient/o1.jpg	600x400	92	11	
   LOG OK	orient/o2.jpg	orient/o2.jpg	600x400	92	11	
   LOG OK	orient/o3.jpg	orient/o3.jpg	600x400	92	11	
   LOG OK	orient/o4.jpg	orient/o4.jpg	600x400	92	11	
   LOG OK	orient/o5.jpg	orient/o5.jpg	600x400	92	11	
   LOG OK	orient/o6.jpg	orient/o6.jpg	600x400	92	11	
   LOG OK	orient/o6_xmp.jpg	orient/o6_xmp.jpg	600x400	92	14	
   LOG OK	orient/o7.jpg	orient/o7.jpg	600x400	92	11	
   LOG OK	orient/o8.jpg	orient/o8.jpg	600x400	92	11	
   LOG OK	unicode/Ünïcödé 文件夹/照片 é.jpg	unicode/Ünïcödé 文件夹/照片 é.jpg	300x200	92	4	
--- special run B: side 1000 limit 500000 nometa=True rc=0 0.6s SCAN files=52 skipped=0 subfolders=40
PASS [special B] generic checks on 46 outputs (side 1000, limit 500000)
--- special run C: side 1000 limit 30000 nometa=False rc=0 1.9s SCAN files=52 skipped=0 subfolders=40
PASS [special C] generic checks on 46 outputs (side 1000, limit 30000)
--- special run D: side 1000 limit 30000 nometa=True rc=0 1.2s SCAN files=52 skipped=0 subfolders=40
PASS [special D] generic checks on 46 outputs (side 1000, limit 30000)
--- special run E: side 500 limit 100000 nometa=False rc=0 0.5s SCAN files=52 skipped=0 subfolders=40
PASS [special E] generic checks on 46 outputs (side 500, limit 100000)
--- special run F: side 1000 limit 100000 nometa=False rc=0 1.2s SCAN files=52 skipped=0 subfolders=40
PASS [special F] generic checks on 46 outputs (side 1000, limit 100000)
--- special run G: side 1000 limit 100000 nometa=True rc=0 1.3s SCAN files=52 skipped=0 subfolders=40
PASS [special G] generic checks on 46 outputs (side 1000, limit 100000)
PASS orientation 1 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 2 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 3 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 4 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 5 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 6 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 7 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 8 run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 6_xmp run A (meta): quadrants upright, size (600, 400), EXIF orient 1
PASS orientation 1 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 2 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 3 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 4 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 5 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 6 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 7 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 8 run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS orientation 6_xmp run B (nometa): quadrants upright, size (600, 400), EXIF orient None
PASS colour colour/tagged_p3.jpg -> sRGB: out [(254, 5, 0), (4, 255, 0), (0, 0, 254), (201, 120, 64)] want ~[(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)] (raw source [(233, 52, 35), (117, 251, 76), (0, 0, 244), (190, 124, 74)])
PASS colour colour/tagged_adobe.jpg -> sRGB: out [(254, 0, 0), (0, 255, 3), (0, 0, 254), (200, 120, 61)] want ~[(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)] (raw source [(218, 0, 0), (144, 255, 60), (0, 0, 250), (180, 118, 67)])
PASS colour colour/tagged_prophoto.jpg -> sRGB: out [(254, 2, 0), (0, 255, 1), (13, 0, 255), (200, 121, 62)] want ~[(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)] (raw source [(178, 69, 26), (137, 237, 77), (86, 35, 234), (148, 111, 59)])
PASS colour P3 pure red -> sRGB red: out (254, 0, 0)
PASS colour untagged treated as sRGB: out [(254, 0, 0), (0, 255, 1), (0, 0, 254), (200, 120, 61)]
PASS colour colour/gray_L.jpg -> neutral RGB: out [(0, 0, 0), (64, 64, 64), (128, 128, 128), (192, 192, 192), (255, 255, 255)] want ~(0, 64, 128, 192, 255)
PASS colour colour/gray_L_tagged.jpg -> neutral RGB: out [(0, 0, 0), (64, 64, 64), (128, 128, 128), (192, 192, 192), (255, 255, 255)] want ~(0, 64, 128, 192, 255)
PASS colour CMYK (Adobe inverted) white/cyan/black/red: out [(255, 255, 255), (0, 163, 218), (27, 25, 26), (216, 35, 42)]
INFO colour/cmyk_noadobe.jpg: row OK, colours [(255, 255, 255), (0, 163, 218), (27, 25, 26), (216, 35, 42)]
INFO colour/cmyk_sips_generic.jpg: row OK, colours [(219, 75, 48), (149, 200, 131), (46, 85, 150), (200, 121, 64)]
PASS encoding enc/progressive.jpg: OK 1000x667 q92 261KB
PASS encoding enc/s444.jpg: OK 1000x667 q92 263KB
PASS encoding enc/s420.jpg: OK 1000x667 q92 261KB
PASS encoding enc/q100.jpg: OK 1000x667 q92 261KB
PASS encoding enc/optimized_restart.jpg: OK 1000x667 q92 257KB
INFO meta meta/exif.jpg run A [OK q92 357924B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='EXIF Artist' exif_desc='EXIF Description' xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 120): b'EXIF Description', (2, 116): b'EXIF Copyright Holder', (2, 80): b'EXIF Artist'} thumb=0 any_copyright=True
PASS meta meta/exif.jpg run A keeps EXIF copyright: 'EXIF Copyright Holder' artist 'EXIF Artist' desc 'EXIF Description'
INFO meta meta/exif.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif.jpg run B nometa strips metadata
INFO meta meta/exif.jpg run C [OVER LIMIT q30 37856B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='EXIF Artist' exif_desc='EXIF Description' xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 120): b'EXIF Description', (2, 116): b'EXIF Copyright Holder', (2, 80): b'EXIF Artist'} thumb=0 any_copyright=True
INFO meta meta/exif.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif.jpg run D nometa strips metadata
INFO meta meta/exif.jpg run F [OK q50 87953B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='EXIF Artist' exif_desc='EXIF Description' xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 120): b'EXIF Description', (2, 116): b'EXIF Copyright Holder', (2, 80): b'EXIF Artist'} thumb=0 any_copyright=True
PASS meta meta/exif.jpg run F keeps EXIF copyright: 'EXIF Copyright Holder' artist 'EXIF Artist' desc 'EXIF Description'
INFO meta meta/exif.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif.jpg run G nometa strips metadata
INFO meta meta/iptc.jpg run A [OK q92 360716B notes='']: exif_copy='IPTC Copyright Holder' exif_artist='IPTC Author' exif_desc='IPTC Caption' xmp_len=2751 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'IPTC Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'IPTC Title', (2, 120): b'IPTC Caption'} thumb=0 any_copyright=True
PASS meta meta/iptc.jpg run A keeps IPTC/copyright: iptc {(2, 116): b'IPTC Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'IPTC Title', (2, 120): b'IPTC Caption'} xmp_len 2751
INFO meta meta/iptc.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/iptc.jpg run B nometa strips metadata
INFO meta meta/iptc.jpg run C [OVER LIMIT q30 40648B notes='']: exif_copy='IPTC Copyright Holder' exif_artist='IPTC Author' exif_desc='IPTC Caption' xmp_len=2751 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'IPTC Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'IPTC Title', (2, 120): b'IPTC Caption'} thumb=0 any_copyright=True
INFO meta meta/iptc.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/iptc.jpg run D nometa strips metadata
INFO meta meta/iptc.jpg run F [OK q50 90745B notes='']: exif_copy='IPTC Copyright Holder' exif_artist='IPTC Author' exif_desc='IPTC Caption' xmp_len=2751 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'IPTC Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'IPTC Title', (2, 120): b'IPTC Caption'} thumb=0 any_copyright=True
PASS meta meta/iptc.jpg run F keeps IPTC/copyright: iptc {(2, 116): b'IPTC Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'IPTC Title', (2, 120): b'IPTC Caption'} xmp_len 2751
INFO meta meta/iptc.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/iptc.jpg run G nometa strips metadata
INFO meta meta/xmp50k.jpg run A [OK q92 410625B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc ' xmp_len=52718 xmp_title=True xmp_rights=True xmp_blob=True iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc '} thumb=0 any_copyright=False
PASS meta meta/xmp50k.jpg run A keeps XMP title+rights: xmp_len 52718 blob True
INFO meta meta/xmp50k.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp50k.jpg run B nometa strips metadata
INFO meta meta/xmp50k.jpg run C [OVER LIMIT q30 90557B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc ' xmp_len=52718 xmp_title=True xmp_rights=True xmp_blob=True iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc '} thumb=0 any_copyright=False
INFO meta meta/xmp50k.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp50k.jpg run D nometa strips metadata
INFO meta meta/xmp50k.jpg run F [OK q35 97885B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc ' xmp_len=52718 xmp_title=True xmp_rights=True xmp_blob=True iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc '} thumb=0 any_copyright=False
PASS meta meta/xmp50k.jpg run F keeps XMP title+rights: xmp_len 52718 blob True
INFO meta meta/xmp50k.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp50k.jpg run G nometa strips metadata
INFO meta meta/exif_thumb.jpg run A [OK q92 357834B notes='']: exif_copy='EXIF Copyright Holder' exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'EXIF Copyright Holder'} thumb=0 any_copyright=True
PASS meta meta/exif_thumb.jpg run A keeps EXIF copyright: 'EXIF Copyright Holder' artist None desc None
INFO meta meta/exif_thumb.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif_thumb.jpg run B nometa strips metadata
INFO meta meta/exif_thumb.jpg run C [OVER LIMIT q30 37766B notes='']: exif_copy='EXIF Copyright Holder' exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'EXIF Copyright Holder'} thumb=0 any_copyright=True
INFO meta meta/exif_thumb.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif_thumb.jpg run D nometa strips metadata
INFO meta meta/exif_thumb.jpg run F [OK q50 87863B notes='']: exif_copy='EXIF Copyright Holder' exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={(2, 116): b'EXIF Copyright Holder'} thumb=0 any_copyright=True
PASS meta meta/exif_thumb.jpg run F keeps EXIF copyright: 'EXIF Copyright Holder' artist None desc None
INFO meta meta/exif_thumb.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/exif_thumb.jpg run G nometa strips metadata
INFO meta meta/all.jpg run A [OK q92 410754B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='IPTC Author' exif_desc='desc ' xmp_len=52799 xmp_title=True xmp_rights=False xmp_blob=True iptc={(2, 116): b'EXIF Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 120): b'desc '} thumb=0 any_copyright=True
INFO meta meta/all.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/all.jpg run B nometa strips metadata
INFO meta meta/all.jpg run C [OVER LIMIT q30 90686B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='IPTC Author' exif_desc='desc ' xmp_len=52799 xmp_title=True xmp_rights=False xmp_blob=True iptc={(2, 116): b'EXIF Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 120): b'desc '} thumb=0 any_copyright=True
INFO meta meta/all.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/all.jpg run D nometa strips metadata
INFO meta meta/all.jpg run F [OK q35 98014B notes='']: exif_copy='EXIF Copyright Holder' exif_artist='IPTC Author' exif_desc='desc ' xmp_len=52799 xmp_title=True xmp_rights=False xmp_blob=True iptc={(2, 116): b'EXIF Copyright Holder', (2, 80): b'IPTC Author', (2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 120): b'desc '} thumb=0 any_copyright=True
INFO meta meta/all.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/all.jpg run G nometa strips metadata
INFO meta meta/flat_xmp50k.jpg run A [OK q92 68979B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc ' xmp_len=52718 xmp_title=True xmp_rights=True xmp_blob=True iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc '} thumb=0 any_copyright=False
PASS meta flat+50KB XMP at 500KB: no drop note: notes ''
INFO meta meta/flat_xmp50k.jpg run B [OK q92 16100B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/flat_xmp50k.jpg run B nometa strips metadata
INFO meta meta/flat_xmp50k.jpg run C [OK q92 16100B notes='metadata dropped to save space']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta flat+50KB XMP at 30KB: metadata dropped, note shown, under limit: OK 16100B notes 'metadata dropped to save space'
INFO meta meta/flat_xmp50k.jpg run D [OK q92 16100B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/flat_xmp50k.jpg run D nometa strips metadata
INFO meta meta/flat_xmp50k.jpg run F [OK q92 68979B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc ' xmp_len=52718 xmp_title=True xmp_rights=True xmp_blob=True iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc '} thumb=0 any_copyright=False
INFO meta meta/flat_xmp50k.jpg run G [OK q92 16100B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/flat_xmp50k.jpg run G nometa strips metadata
INFO meta meta/xmp_iccstring.jpg run A [OK q92 360660B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc mentions ICC_PROFILE in text' xmp_len=2697 xmp_title=True xmp_rights=True xmp_blob=False iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc mentions ICC_PROFILE in text'} thumb=0 any_copyright=False
PASS meta meta/xmp_iccstring.jpg run A keeps XMP title+rights: xmp_len 2697 blob False
INFO meta meta/xmp_iccstring.jpg run B [OK q92 357746B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp_iccstring.jpg run B nometa strips metadata
INFO meta meta/xmp_iccstring.jpg run C [OVER LIMIT q30 40592B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc mentions ICC_PROFILE in text' xmp_len=2697 xmp_title=True xmp_rights=True xmp_blob=False iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc mentions ICC_PROFILE in text'} thumb=0 any_copyright=False
INFO meta meta/xmp_iccstring.jpg run D [OVER LIMIT q30 37678B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp_iccstring.jpg run D nometa strips metadata
INFO meta meta/xmp_iccstring.jpg run F [OK q50 90689B notes='']: exif_copy='XMP Rights Holder' exif_artist=None exif_desc='desc mentions ICC_PROFILE in text' xmp_len=2697 xmp_title=True xmp_rights=True xmp_blob=False iptc={(2, 5): b'XMP Title \xe9\xbb\x84\xe5\xb0\xa7', (2, 116): b'XMP Rights Holder', (2, 120): b'desc mentions ICC_PROFILE in text'} thumb=0 any_copyright=False
PASS meta meta/xmp_iccstring.jpg run F keeps XMP title+rights: xmp_len 2697 blob False
INFO meta meta/xmp_iccstring.jpg run G [OK q50 87775B notes='']: exif_copy=None exif_artist=None exif_desc=None xmp_len=0 xmp_title=False xmp_rights=False xmp_blob=False iptc={} thumb=0 any_copyright=False
PASS meta meta/xmp_iccstring.jpg run G nometa strips metadata
INFO quality cost of keeping metadata meta/xmp50k.jpg @100KB: with meta OK q35 97KB '' | nometa OK q50 87KB
INFO quality cost of keeping metadata meta/all.jpg @100KB: with meta OK q35 98KB '' | nometa OK q50 87KB
INFO quality cost of keeping metadata meta/exif_thumb.jpg @100KB: with meta OK q50 87KB '' | nometa OK q50 87KB
PASS edge edge/zero.jpg reported FAILED: ['FAILED', 'edge/zero.jpg', '-', '-', '-', '-', 'Could not be read — the file may be damaged or in an unsupported format']
PASS edge edge/notajpeg.jpg reported FAILED: ['FAILED', 'edge/notajpeg.jpg', '-', '-', '-', '-', 'Could not be read — the file may be damaged or in an unsupported format']
PASS edge edge/truncated_half.jpg: damaged file flagged (FAILED or note): row ['FAILED', 'edge/truncated_half.jpg', '-', '-', '-', '-', 'The file is incomplete — it looks cut off or only partly downloaded']
PASS edge edge/truncated_half_progressive.jpg: damaged file flagged (FAILED or note): row ['FAILED', 'edge/truncated_half_progressive.jpg', '-', '-', '-', '-', 'The file is incomplete — it looks cut off or only partly downloaded']
PASS edge huge 12000x8000: ['OK', 'edge/huge12000x8000.jpg', 'edge/huge12000x8000.jpg', '1000x667', '92', '215', '']
PASS ext ext_x.jpeg processed
PASS ext ext_y.JPG processed
PASS ext ext_z.Jpeg processed
INFO ext ext_w.jpe: processed
INFO ext ext_v.jfif: processed
PASS clash names: one distinct output per source, right content: 6 files out; A.jpeg->clash/A.jpg (0, 255, 1); a_jpeg.jpg->clash/a_jpeg.jpg (0, 0, 254); a.JPEG.jpg->clash/a.JPEG.jpg (255, 255, 1); café.jpg->clash/café_jpg.jpg (255, 0, 254); café.jpeg->clash/café.jpg (1, 255, 255); a.jpg->clash/a_jpg.jpg (128, 128, 128)
PASS NFD unicode subfolder+name: unicode/Ünïcödé 文件夹/照片 é.jpg
PASS deep nesting 30 levels keeps layout: deep/d01/d02/d03/d04/d05/d06/d07/d08/d09/d10/d11/d12/d13/d14/d15/d16/d17/d18/d19/d20/d21/d22/d23/d24/d25/d26/d27/d28/d29/d30/deep.jpg
PASS every JPEG input has a log row: []
INFO TIMING 50 x 4000x3000 (241 MB) at 1000px/500KB: 2.3s wall, 46 ms/image, statuses ['OK'], q range 92-92
INFO TIMING 50 x 4000x3000 (241 MB) at 1600px/250KB: 7.8s wall, 155 ms/image, statuses ['OK'], q range 60-60
INFO TIMING edge folder incl. 12000x8000: 0.2s
JPEG SUMMARY: 105 passed, 0 failed
JPEG tests wall time: 59s
=== GUI launch smoke test
PASS app launched and is running
