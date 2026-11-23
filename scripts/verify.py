"""Checks ImageShrink self-test output independently (not from the app's own log).
Usage: verify.py <out dir> <max side> <max bytes> full|limits
"""
import io
import os
import sys
import unicodedata

from PIL import Image, ImageCms

out, max_side, max_bytes, mode = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
fails = []
passes = 0


def check(cond, label):
    global passes
    if cond:
        passes += 1
        print("PASS", label)
    else:
        fails.append(label)
        print("FAIL", label)


def find(rel):
    for form in ("NFC", "NFD"):
        p = os.path.join(out, unicodedata.normalize(form, rel))
        if os.path.exists(p):
            return p
    return None


outputs = []
for dp, _, fs in os.walk(out):
    for f in fs:
        if f != "ImageShrink log.txt":
            outputs.append(os.path.relpath(os.path.join(dp, f), out))
outputs.sort()
print("OUTPUT FILES:", len(outputs))
log = open(os.path.join(out, "ImageShrink log.txt"), encoding="utf-8").read()

# Every output: JPEG, within the side limit, sRGB tagged
for rel in outputs:
    p = os.path.join(out, rel)
    im = Image.open(p)
    size = os.path.getsize(p)
    check(im.format == "JPEG" and im.mode == "RGB", f"{rel}: RGB JPEG ({im.format} {im.mode})")
    check(max(im.size) <= max_side, f"{rel}: {im.size[0]}x{im.size[1]} within {max_side}px")
    icc = im.info.get("icc_profile")
    desc = ""
    if icc:
        try:
            desc = ImageCms.getProfileDescription(ImageCms.ImageCmsProfile(io.BytesIO(icc))).strip()
        except Exception as e:  # noqa
            desc = f"unreadable ({e})"
    print(f"INFO {rel}: {size} bytes, profile={desc or 'none'}")
    if mode == "full":
        check(size < max_bytes, f"{rel}: {size} bytes under {max_bytes}")
        check("sRGB" in desc, f"{rel}: sRGB profile ({desc or 'none'})")

if mode == "full":
    expect = {
        "big_noise.jpg": (1000, 667), "fine_detail.jpg": (1000, 1000), "A.jpg": (667, 1000),
        "A_tif.jpg": (1000, 667), "-dash.jpg": (1000, 667), "small.jpg": (600, 400),
        "pano.jpg": (1000, 67), "gray16.jpg": (1000, 667), "cmyk.jpg": (1000, 667),
        "alpha.jpg": (1000, 1000), "rotated.jpg": (500, 1000), "meta.jpg": (1000, 667),
        "photoshop.jpg": (1000, 667), "phone.jpg": (1000, 667), "motion.jpg": (1000, 667),
        "sub folder/深层/黄尧 山水 1975.jpg": (667, 1000),
    }
    for rel, (w, h) in expect.items():
        p = find(rel)
        check(p is not None, f"exists: {rel}")
        if p:
            sw, sh = Image.open(p).size
            check(abs(sw - w) <= 1 and abs(sh - h) <= 1, f"dims {rel}: got {sw}x{sh}, want {w}x{h}")
    check(len(outputs) == len(expect), f"exactly {len(expect)} outputs (got {len(outputs)}: {outputs})")
    for bad in ["notes.jpg", ".hidden.jpg", "previous_1000px/old.jpg", "broken.jpg"]:
        check(find(bad) is None, f"not created: {bad}")
    check("FAILED\tbroken.jpg" in log, "log reports broken.jpg as FAILED")

    p = find("alpha.jpg")
    if p:
        im = Image.open(p).convert("RGB")
        corner, centre = im.getpixel((5, 5)), im.getpixel((500, 500))
        check(min(corner) > 240, f"transparent area became white (corner {corner})")
        check(centre[0] > 150 and centre[1] < 90, f"opaque area kept its colour (centre {centre})")

    p = find("rotated.jpg")
    if p:
        im = Image.open(p)
        orient = im.getexif().get(0x0112, 1)
        rgb = im.convert("RGB")
        top, bottom = rgb.getpixel((250, 100)), rgb.getpixel((250, 900))
        check(orient in (1, None), f"rotation tag reset (orientation={orient})")
        check(top[0] > 200 and top[2] < 60, f"rotated upright: top is red {top}")
        check(bottom[2] > 200 and bottom[0] < 60, f"rotated upright: bottom is blue {bottom}")

    p = find("meta.jpg")
    if p:
        ex = Image.open(p).getexif()
        check(ex.get(0x8298) == "Huang Yao Foundation", f"copyright kept ({ex.get(0x8298)!r})")
        check(ex.get(0x010E) == "Test title for ImageShrink", f"title kept ({ex.get(0x010E)!r})")

if mode == "limits":
    rows = [l.split("\t") for l in log.splitlines() if l.startswith(("OK\t", "OVER LIMIT\t"))]
    for row in rows:
        status, rel_out = row[0], row[2]
        p = find(rel_out)
        if not p:
            check(False, f"log names missing output {rel_out}")
            continue
        size = os.path.getsize(p)
        if status == "OK":
            check(size < max_bytes, f"limits {rel_out}: OK and {size} < {max_bytes}")
        else:
            check(size >= max_bytes, f"limits {rel_out}: OVER LIMIT and {size} >= {max_bytes}")

print(f"\nSUMMARY {mode}: {passes} passed, {len(fails)} failed")
for f in fails:
    print("  FAILED:", f)
sys.exit(1 if fails else 0)
