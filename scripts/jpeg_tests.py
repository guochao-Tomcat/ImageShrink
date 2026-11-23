"""JPEG stress tests for ImageShrink --selftest. Verifies outputs independently of the app's log.
Usage: jpeg_tests.py <app binary> <work dir>
"""
import glob
import io
import os
import random
import shutil
import struct
import subprocess
import sys
import time
import unicodedata

import numpy as np
import piexif
from PIL import Image, ImageCms, IptcImagePlugin

BIN, T = sys.argv[1], sys.argv[2]
shutil.rmtree(T, ignore_errors=True)
os.makedirs(T)
SIPS = shutil.which("sips")
FAILS = []
NPASS = 0


def rec(case, ok, detail=""):
    global NPASS
    print(("PASS " if ok else "FAIL ") + case + (": " + detail if detail else ""), flush=True)
    if ok:
        NPASS += 1
    else:
        FAILS.append(case)


def info(case, detail):
    print("INFO " + case + ": " + detail, flush=True)


# ---------------------------------------------------------------- fixtures
def photo(w, h, seed=0):
    rng = np.random.default_rng(seed)
    if w * h > 20_000_000:
        small = photo(w // 4, h // 4, seed)
        return small.resize((w, h), Image.BICUBIC)
    y, x = np.mgrid[0:h, 0:w].astype(np.float32)
    r = 127 + 90 * np.sin(x / w * 12.6 + seed)
    g = 127 + 90 * np.cos(y / h * 18.8 + seed)
    b = 127 + 90 * np.sin((x + y) / (w + h) * 25 + seed)
    a = np.stack([r, g, b], -1) + rng.standard_normal((h, w, 3), dtype=np.float32) * 14
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGB")


def quads(w=600, h=400):
    """Upright pattern: red TL, green TR, blue BL, white BR."""
    a = np.zeros((h, w, 3), np.uint8)
    a[: h // 2, : w // 2] = (255, 0, 0)
    a[: h // 2, w // 2:] = (0, 255, 0)
    a[h // 2:, : w // 2] = (0, 0, 255)
    a[h // 2:, w // 2:] = (255, 255, 255)
    return Image.fromarray(a)


QCOL = [((0.25, 0.25), (255, 0, 0)), ((0.75, 0.25), (0, 255, 0)),
        ((0.25, 0.75), (0, 0, 255)), ((0.75, 0.75), (255, 255, 255))]


def quads_ok(im, tol=60):
    im = im.convert("RGB")
    for (fx, fy), col in QCOL:
        px = im.getpixel((int(im.width * fx), int(im.height * fy)))
        if max(abs(px[i] - col[i]) for i in range(3)) > tol:
            return False, f"at {fx},{fy} got {px} want {col}"
    return True, "quadrants upright"


def segs_insert(data, marker, payload):
    """Insert a segment after the existing APP0/APP1 segments."""
    pos = 2
    while data[pos] == 0xFF and data[pos + 1] in (0xE0, 0xE1):
        pos += 2 + struct.unpack(">H", data[pos + 2:pos + 4])[0]
    seg = b"\xff" + bytes([marker]) + struct.pack(">H", len(payload) + 2) + payload
    return data[:pos] + seg + data[pos:]


def xmp_packet(extra="", size=0, orient=None):
    rnd = random.Random(1)
    blob = "".join(rnd.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") for _ in range(size))
    o = f' tiff:Orientation="{orient}"' if orient else ""
    return (
        '<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>'
        '<x:xmpmeta xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">'
        '<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/" '
        'xmlns:tiff="http://ns.adobe.com/tiff/1.0/" xmlns:ts="http://example.com/ts/1.0/"'
        f'{o} ts:Blob="{blob}">'
        '<dc:title><rdf:Alt><rdf:li xml:lang="x-default">XMP Title 黄尧</rdf:li></rdf:Alt></dc:title>'
        '<dc:rights><rdf:Alt><rdf:li xml:lang="x-default">XMP Rights Holder</rdf:li></rdf:Alt></dc:rights>'
        f'<dc:description><rdf:Alt><rdf:li xml:lang="x-default">desc {extra}</rdf:li></rdf:Alt></dc:description>'
        '</rdf:Description></rdf:RDF></x:xmpmeta><?xpacket end="w"?>'
    ).encode("utf-8")


def add_xmp(path, pkt):
    d = open(path, "rb").read()
    d = segs_insert(d, 0xE1, b"http://ns.adobe.com/xap/1.0/\x00" + pkt)
    open(path, "wb").write(d)


def add_iptc(path):
    def ds(n, v):
        v = v.encode()
        return b"\x1c\x02" + bytes([n]) + struct.pack(">H", len(v)) + v
    iptc = b"\x1c\x02\x00\x00\x02\x00\x04" + ds(5, "IPTC Title") + ds(80, "IPTC Author") + \
        ds(116, "IPTC Copyright Holder") + ds(120, "IPTC Caption")
    if len(iptc) % 2:
        iptc += b"\x00"
    res = b"8BIM\x04\x04\x00\x00" + struct.pack(">I", len(iptc)) + iptc
    d = open(path, "rb").read()
    d = segs_insert(d, 0xED, b"Photoshop 3.0\x00" + res)
    open(path, "wb").write(d)


DIMS = {}  # rel path -> upright (w, h)


def save(folder, rel, im, upright=None, **kw):
    p = os.path.join(folder, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    kw.setdefault("quality", 90)
    im.save(p, "JPEG", **kw)
    DIMS[(folder, rel)] = upright or im.size
    return p


# ---------------------------------------------------------------- run app
def run_app(inp, out, side, mb, nometa=False):
    args = [BIN, "--selftest", inp, out, str(side), str(mb)] + (["nometa"] if nometa else [])
    t0 = time.time()
    p = subprocess.run(args, capture_output=True, text=True, timeout=900)
    dt = time.time() - t0
    rows, scan = {}, ""
    for line in p.stdout.splitlines():
        if line.startswith("SCAN"):
            scan = line
        parts = line.split("\t")
        if len(parts) == 7 and parts[0] in ("OK", "OVER LIMIT", "FAILED"):
            rows[unicodedata.normalize("NFC", parts[1])] = parts
    if p.returncode != 0:
        print(p.stdout[-2000:], p.stderr[-2000:])
    return rows, scan, dt, p.returncode


def icc_desc(im):
    icc = im.info.get("icc_profile")
    if not icc:
        return None
    try:
        return ImageCms.getProfileDescription(ImageCms.ImageCmsProfile(io.BytesIO(icc))).strip()
    except Exception as e:
        return f"unreadable ICC ({e})"


def find_out(out, rel):
    for form in ("NFC", "NFD"):
        p = os.path.join(out, unicodedata.normalize(form, rel))
        if os.path.exists(p):
            return p
    return None


def verify_generic(label, inp, out, rows, side, mb):
    """Size, side, OVER LIMIT, RGB, sRGB ICC, aspect, orientation for every output."""
    bad = []
    n = 0
    for (folder, rel), (uw, uh) in DIMS.items():
        if folder != inp:
            continue
        r = rows.get(unicodedata.normalize("NFC", rel))
        if r is None:
            bad.append(f"{rel}: no log row")
            continue
        if r[0] == "FAILED":
            continue
        p = find_out(out, r[2])
        if not p:
            bad.append(f"{rel}: output {r[2]} missing")
            continue
        n += 1
        sz = os.path.getsize(p)
        im = Image.open(p)
        errs = []
        if im.format != "JPEG":
            errs.append(f"format {im.format}")
        if im.mode != "RGB":
            errs.append(f"mode {im.mode}")
        if max(im.size) > side:
            errs.append(f"side {im.size}>{side}")
        exp_long = min(side, max(uw, uh))
        s = exp_long / max(uw, uh)
        ew, eh = (round(uw * s), round(uh * s))
        if abs(im.width - ew) > 1 or abs(im.height - eh) > 1:
            errs.append(f"dims {im.size} want ~{ew}x{eh}")
        over = sz >= mb
        if (r[0] == "OVER LIMIT") != over:
            errs.append(f"status {r[0]} but size {sz} vs limit {mb}")
        d = icc_desc(im)
        if not d or "srgb" not in d.lower():
            errs.append(f"ICC {d!r}")
        raw = open(p, "rb").read()
        if raw.count(b"ICC_PROFILE\x00") != 1:
            errs.append(f"{raw.count(b'ICC_PROFILE')} ICC segments")
        o = im.getexif().get(0x0112)
        if o not in (None, 1):
            errs.append(f"EXIF orientation {o}")
        xmp = im.info.get("xmp") or b""
        if isinstance(xmp, str):
            xmp = xmp.encode()
        for v in b"2345678":
            if (b'tiff:Orientation="%c"' % v) in xmp or (b"<tiff:Orientation>%c<" % v) in xmp:
                errs.append(f"XMP tiff:Orientation={chr(v)}")
        if r[3] != f"{im.width}x{im.height}":
            errs.append(f"log size {r[3]} != real {im.size}")
        if errs:
            bad.append(f"{rel}: " + ", ".join(errs))
    rec(f"[{label}] generic checks on {n} outputs (side {side}, limit {mb})", not bad, "; ".join(bad[:12]))
    return bad


def color_at(path, fx, fy):
    im = Image.open(path).convert("RGB")
    return im.getpixel((int(im.width * fx), int(im.height * fy)))


def close(a, b, tol):
    return max(abs(a[i] - b[i]) for i in range(3)) <= tol


# ======================================================================
# 1. Parameter matrix
MX = os.path.join(T, "matrix")
save(MX, "L4000x3000.jpg", photo(4000, 3000, 1), quality=92)
save(MX, "P3000x4000.jpg", photo(3000, 4000, 2), quality=92)
save(MX, "M1600x1067.jpg", photo(1600, 1067, 3), quality=90)
sm = photo(800, 600, 4)
for q in range(95, 20, -5):
    b = io.BytesIO(); sm.save(b, "JPEG", quality=q)
    if b.tell() <= 62_000:
        break
save(MX, "S800x600_small.jpg", sm, quality=q)
info("small source", f"S800x600_small.jpg {os.path.getsize(os.path.join(MX, 'S800x600_small.jpg'))} bytes at q{q}")
save(MX, "E1000x750.jpg", photo(1000, 750, 5))
save(MX, "E1001x751.jpg", photo(1001, 751, 6))
save(MX, "E1600x900.jpg", photo(1600, 900, 7))
save(MX, "E1601x901.jpg", photo(1601, 901, 8))
save(MX, "one1x1.jpg", Image.new("RGB", (1, 1), (10, 200, 30)))
save(MX, "W5000x40_strip.jpg", photo(5000, 40, 9))

for side in (500, 1000, 1600, 4000):
    for mb in (30_000, 100_000, 250_000, 500_000, 2_000_000):
        out = os.path.join(T, f"o_matrix_{side}_{mb}")
        rows, scan, dt, rc = run_app(MX, out, side, mb)
        verify_generic(f"matrix {side}/{mb // 1000}K", MX, out, rows, side, mb)
        summ = " ".join(f"{k.split('.')[0]}={v[0][:4]}/q{v[4]}/{v[5]}K" for k, v in sorted(rows.items()))
        info(f"matrix {side}/{mb // 1000}K ({dt:.1f}s)", summ)
        if side == 1000 and mb == 500_000 and "S800x600_small.jpg" in rows:
            sz = os.path.getsize(find_out(out, rows["S800x600_small.jpg"][2]))
            info("small source re-encode", f"60KB-class 800x600 -> {sz} bytes (x{sz / os.path.getsize(os.path.join(MX, 'S800x600_small.jpg')):.2f}), q{rows['S800x600_small.jpg'][4]}")
for side, mb in ((1000, 100_000), (4000, 2_000_000)):
    out = os.path.join(T, f"o_matrix_{side}_{mb}_nometa")
    rows, scan, dt, rc = run_app(MX, out, side, mb, nometa=True)
    verify_generic(f"matrix nometa {side}/{mb // 1000}K", MX, out, rows, side, mb)

# ======================================================================
# 2. Special fixtures
SP = os.path.join(T, "special")
# Orientations
up = quads()
inv = {1: None, 2: Image.FLIP_LEFT_RIGHT, 3: Image.ROTATE_180, 4: Image.FLIP_TOP_BOTTOM,
       5: Image.TRANSPOSE, 6: Image.ROTATE_90, 7: Image.TRANSVERSE, 8: Image.ROTATE_270}
from PIL import ImageOps
for n, op in inv.items():
    st = up if op is None else up.transpose(op)
    ex = Image.Exif(); ex[0x0112] = n
    p = save(SP, f"orient/o{n}.jpg", st, upright=up.size, exif=ex.tobytes(), quality=95)
    chk = ImageOps.exif_transpose(Image.open(p))
    assert quads_ok(chk)[0] and chk.size == up.size, f"fixture o{n} wrong"
# orientation 6 also in XMP
st = up.transpose(Image.ROTATE_90); ex = Image.Exif(); ex[0x0112] = 6
p = save(SP, "orient/o6_xmp.jpg", st, upright=up.size, exif=ex.tobytes(), quality=95)
add_xmp(p, xmp_packet(orient=6))
# orientation with nometa handled in run B

# Colour
patches = [(255, 0, 0), (0, 255, 0), (0, 0, 255), (200, 120, 60)]
pim = Image.new("RGB", (400, 100))
for i, c in enumerate(patches):
    pim.paste(c, (i * 100, 0, i * 100 + 100, 100))
PROF = {}
for pth in glob.glob("/System/Library/ColorSync/Profiles/*") + glob.glob("/Library/ColorSync/Profiles/*"):
    nm = os.path.basename(pth).lower()
    for key, pat in (("srgb", "srgb profile"), ("p3", "display p3"), ("adobe", "adobergb"), ("prophoto", "romm"),
                     ("gray", "generic gray gamma 2.2"), ("cmyk", "generic cmyk")):
        if pat in nm and key not in PROF:
            PROF[key] = pth
info("profiles", str(PROF))
srgb_icc = open(PROF["srgb"], "rb").read() if "srgb" in PROF else None
os.makedirs(os.path.join(SP, "colour"), exist_ok=True)
base = os.path.join(T, "srgb_base.jpg")
pim.save(base, "JPEG", quality=100, subsampling=0, icc_profile=srgb_icc)
COLOUR = {}
for key in ("p3", "adobe", "prophoto"):
    if key in PROF and SIPS:
        dst = os.path.join(SP, "colour", f"tagged_{key}.jpg")
        subprocess.run([SIPS, "-s", "format", "jpeg", "-s", "formatOptions", "100", "--matchTo", PROF[key], base,
                        "--out", dst], capture_output=True)
        if os.path.exists(dst):
            DIMS[(SP, f"colour/tagged_{key}.jpg")] = (400, 100)
            raw = [Image.open(dst).convert("RGB").getpixel((i * 100 + 50, 50)) for i in range(4)]
            COLOUR[f"colour/tagged_{key}.jpg"] = raw
            info(f"fixture {key}", f"ICC {icc_desc(Image.open(dst))!r}, raw patch values {raw} (sRGB originals {patches})")
# P3 pure red (out of sRGB gamut)
if "p3" in PROF:
    save(SP, "colour/p3_pure_red.jpg", Image.new("RGB", (200, 100), (255, 0, 0)), quality=100,
         icc_profile=open(PROF["p3"], "rb").read())
save(SP, "colour/untagged.jpg", pim, quality=100, subsampling=0)
gim = Image.new("L", (500, 100))
for i, v in enumerate((0, 64, 128, 192, 255)):
    gim.paste(v, (i * 100, 0, i * 100 + 100, 100))
save(SP, "colour/gray_L.jpg", gim, quality=100)
if "gray" in PROF:
    save(SP, "colour/gray_L_tagged.jpg", gim, quality=100, icc_profile=open(PROF["gray"], "rb").read())
cm = Image.new("CMYK", (400, 100))
cpat = [(0, 0, 0, 0), (255, 0, 0, 0), (0, 0, 0, 255), (0, 255, 255, 0)]
for i, c in enumerate(cpat):
    cm.paste(c, (i * 100, 0, i * 100 + 100, 100))
pc = save(SP, "colour/cmyk_adobe.jpg", cm, quality=100)
d = open(pc, "rb").read()
i = d.find(b"\xff\xeeAdobe".replace(b"\xff\xeeAdobe", b"\xff\xee"))
# strip the APP14 Adobe segment -> plain (non-inverted interpretation) CMYK
j = d.find(b"Adobe")
if j > 4 and d[j - 4:j - 2] == b"\xff\xee":
    L = struct.unpack(">H", d[j - 2:j])[0]
    d2 = d[:j - 4] + d[j - 2 + L:]
    open(os.path.join(SP, "colour/cmyk_noadobe.jpg"), "wb").write(d2)
    DIMS[(SP, "colour/cmyk_noadobe.jpg")] = (400, 100)
else:
    info("cmyk", "no APP14 Adobe found in Pillow CMYK JPEG")
if "cmyk" in PROF and SIPS:
    dst = os.path.join(SP, "colour/cmyk_sips_generic.jpg")
    subprocess.run([SIPS, "-s", "format", "jpeg", "--matchTo", PROF["cmyk"], base, "--out", dst], capture_output=True)
    if os.path.exists(dst):
        DIMS[(SP, "colour/cmyk_sips_generic.jpg")] = (400, 100)
        info("fixture cmyk_sips", f"mode {Image.open(dst).mode}")

# Encoding variants
ph = photo(2400, 1600, 11)
save(SP, "enc/progressive.jpg", ph, progressive=True, quality=90)
save(SP, "enc/s444.jpg", ph, subsampling=0, quality=90)
save(SP, "enc/s420.jpg", ph, subsampling=2, quality=90)
save(SP, "enc/q100.jpg", ph, quality=100, subsampling=0)
save(SP, "enc/optimized_restart.jpg", ph, optimize=True, quality=85)

# Metadata
mp = photo(2000, 1500, 12)
exif_meta = {"0th": {piexif.ImageIFD.Copyright: b"EXIF Copyright Holder", piexif.ImageIFD.Artist: b"EXIF Artist",
                     piexif.ImageIFD.ImageDescription: b"EXIF Description"}, "Exif": {}, "GPS": {}, "1st": {}}
save(SP, "meta/exif.jpg", mp, exif=piexif.dump(exif_meta))
p = save(SP, "meta/iptc.jpg", mp); add_iptc(p)
p = save(SP, "meta/xmp50k.jpg", mp); add_xmp(p, xmp_packet(size=50_000))
p = save(SP, "meta/xmp_iccstring.jpg", mp); add_xmp(p, xmp_packet(extra="mentions ICC_PROFILE in text"))
for tq in range(95, 10, -5):
    tb = io.BytesIO(); photo(320, 240, 13).save(tb, "JPEG", quality=tq)
    if tb.tell() < 40_000:
        break
info("thumbnail", f"embedded EXIF thumbnail {tb.tell()} bytes")
ex_t = {"0th": {piexif.ImageIFD.Copyright: b"EXIF Copyright Holder"}, "Exif": {}, "GPS": {},
        "1st": {piexif.ImageIFD.Compression: 6, piexif.ImageIFD.XResolution: (72, 1), piexif.ImageIFD.YResolution: (72, 1),
                piexif.ImageIFD.ResolutionUnit: 2}, "thumbnail": tb.getvalue()}
save(SP, "meta/exif_thumb.jpg", mp, exif=piexif.dump(ex_t))
p = save(SP, "meta/all.jpg", mp, exif=piexif.dump(ex_t)); add_iptc(p); add_xmp(p, xmp_packet(size=50_000))
# flat image + big metadata (so pixels alone fit in 30 KB)
flat = Image.new("RGB", (1200, 900), (90, 140, 200))
p = save(SP, "meta/flat_xmp50k.jpg", flat); add_xmp(p, xmp_packet(size=50_000))

# Edge cases
save(SP, "edge/one1x1.jpg", Image.new("RGB", (1, 1), (10, 200, 30)))
save(SP, "edge/exact1000.jpg", photo(1000, 600, 14))
save(SP, "edge/plus1_1001.jpg", photo(1001, 601, 15))
save(SP, "edge/huge12000x8000.jpg", photo(12000, 8000, 16), quality=85)
info("huge", f"{os.path.getsize(os.path.join(SP, 'edge/huge12000x8000.jpg'))} bytes")
tsrc = io.BytesIO(); quads(2000, 1500).save(tsrc, "JPEG", quality=90)
open(os.path.join(SP, "edge/truncated_half.jpg"), "wb").write(tsrc.getvalue()[: tsrc.tell() // 2])
tsp = io.BytesIO(); quads(2000, 1500).save(tsp, "JPEG", quality=90, progressive=True)
open(os.path.join(SP, "edge/truncated_half_progressive.jpg"), "wb").write(tsp.getvalue()[: tsp.tell() // 2])
open(os.path.join(SP, "edge/zero.jpg"), "wb").close()
open(os.path.join(SP, "edge/notajpeg.jpg"), "wb").write(b"hello this is text" * 50)
# extensions
for nm in ("ext_x.jpeg", "ext_y.JPG", "ext_z.Jpeg", "ext_w.jpe", "ext_v.jfif"):
    pth = os.path.join(SP, "ext", nm); os.makedirs(os.path.dirname(pth), exist_ok=True)
    Image.new("RGB", (300, 200), (200, 50, 50)).save(pth, "JPEG")
    if not nm.endswith((".jpe", ".jfif")):
        DIMS[(SP, "ext/" + nm)] = (300, 200)
# name clashes (case-insensitive APFS: a.jpg and A.JPG cannot coexist; test what can)
CL = {"a.jpg": (255, 0, 0), "A.jpeg": (0, 255, 0), "a_jpeg.jpg": (0, 0, 255), "a.JPEG.jpg": (255, 255, 0),
      "café.jpg": (255, 0, 255), "café.jpeg": (0, 255, 255)}
for nm, col in CL.items():
    save(SP, "clash/" + nm, Image.new("RGB", (300, 200), col))
pth = os.path.join(SP, "clash", "A.JPG")
Image.new("RGB", (300, 200), (128, 128, 128)).save(pth, "JPEG")
clash_files = sorted(os.listdir(os.path.join(SP, "clash")))
info("clash folder listing", repr(clash_files))
if "a.jpg" not in clash_files or len(clash_files) < 7:   # A.JPG overwrote a.jpg (case-insensitive FS)
    CL.pop("a.jpg", None); DIMS.pop((SP, "clash/a.jpg"), None)
    CL["A.JPG"] = (128, 128, 128); DIMS[(SP, "clash/A.JPG")] = (300, 200)
    real = [f for f in clash_files if f.lower() == "a.jpg"][0]
    if real != "A.JPG":
        CL[real] = CL.pop("A.JPG"); DIMS[(SP, "clash/" + real)] = DIMS.pop((SP, "clash/A.JPG"))
else:
    CL["A.JPG"] = (128, 128, 128); DIMS[(SP, "clash/A.JPG")] = (300, 200)
# NFD names, deep nesting
nfd = unicodedata.normalize("NFD", "unicode/Ünïcödé 文件夹/照片 é.jpg")
save(SP, nfd, Image.new("RGB", (300, 200), (20, 20, 20)))
deep = "/".join(f"d{i:02d}" for i in range(1, 31)) + "/deep.jpg"
save(SP, "deep/" + deep, Image.new("RGB", (300, 200), (40, 40, 40)))
n_inputs = sum(len(fs) for _, _, fs in os.walk(SP))
print(f"special fixtures: {n_inputs} files", flush=True)

# ---------------------------------------------------------------- run special
RUNS = {"A": (1000, 500_000, False), "B": (1000, 500_000, True), "C": (1000, 30_000, False),
        "D": (1000, 30_000, True), "E": (500, 100_000, False), "F": (1000, 100_000, False), "G": (1000, 100_000, True)}
R = {}
for k, (side, mb, nm) in RUNS.items():
    out = os.path.join(T, f"o_special_{k}")
    rows, scan, dt, rc = run_app(SP, out, side, mb, nm)
    R[k] = (rows, out)
    print(f"--- special run {k}: side {side} limit {mb} nometa={nm} rc={rc} {dt:.1f}s {scan}", flush=True)
    verify_generic(f"special {k}", SP, out, rows, side, mb)
    if k == "A":
        for rel, r in sorted(rows.items()):
            print("   LOG", "\t".join(r), flush=True)


def outp(k, rel):
    rows, out = R[k]
    r = rows.get(unicodedata.normalize("NFC", rel))
    if not r or r[0] == "FAILED":
        return None, r
    return find_out(out, r[2]), r


# orientation
for k in ("A", "B"):
    for n in list(range(1, 9)) + ["6_xmp"]:
        p, r = outp(k, f"orient/o{n}.jpg")
        if not p:
            rec(f"orientation {n} run {k}", False, f"row {r}"); continue
        im = Image.open(p)
        ok, why = quads_ok(im)
        o = im.getexif().get(0x0112)
        rec(f"orientation {n} run {k} ({'nometa' if k == 'B' else 'meta'})", ok and im.size == (600, 400) and o in (None, 1),
            f"{why}, size {im.size}, EXIF orient {o}")

# colour
for rel, raw in COLOUR.items():
    p, r = outp("A", rel)
    if not p:
        rec(f"colour {rel}", False, f"row {r}"); continue
    got = [color_at(p, (i * 100 + 50) / 400, 0.5) for i in range(4)]
    ok = all(close(g, o, 14) for g, o in zip(got, patches))
    rec(f"colour {rel} -> sRGB", ok, f"out {got} want ~{patches} (raw source {raw})")
p, r = outp("A", "colour/p3_pure_red.jpg")
if p:
    c = color_at(p, 0.5, 0.5)
    rec("colour P3 pure red -> sRGB red", c[0] >= 245 and c[1] <= 40 and c[2] <= 40, f"out {c}")
p, r = outp("A", "colour/untagged.jpg")
if p:
    got = [color_at(p, (i * 100 + 50) / 400, 0.5) for i in range(4)]
    rec("colour untagged treated as sRGB", all(close(g, o, 8) for g, o in zip(got, patches)), f"out {got}")
for rel in ("colour/gray_L.jpg", "colour/gray_L_tagged.jpg"):
    p, r = outp("A", rel)
    if p:
        got = [color_at(p, (i * 100 + 50) / 500, 0.5) for i in range(5)]
        exp = (0, 64, 128, 192, 255)
        ok = all(max(g) - min(g) <= 3 and abs(g[0] - e) <= 10 for g, e in zip(got, exp))
        rec(f"colour {rel} -> neutral RGB", ok, f"out {got} want ~{exp}")
p, r = outp("A", "colour/cmyk_adobe.jpg")
if p:
    got = [color_at(p, (i * 100 + 50) / 400, 0.5) for i in range(4)]
    w, cy, bk, rd = got
    ok = min(w) >= 230 and cy[0] < 110 and cy[1] > 120 and cy[2] > 150 and max(bk) < 70 and rd[0] > 170 and rd[1] < 90
    rec("colour CMYK (Adobe inverted) white/cyan/black/red", ok, f"out {got}")
for rel in ("colour/cmyk_noadobe.jpg", "colour/cmyk_sips_generic.jpg"):
    p, r = outp("A", rel)
    info(rel, f"row {r[0] if r else None}, colours {[color_at(p, (i * 100 + 50) / 400, 0.5) for i in range(4)] if p else None}")

# encoding variants
for rel in ("enc/progressive.jpg", "enc/s444.jpg", "enc/s420.jpg", "enc/q100.jpg", "enc/optimized_restart.jpg"):
    p, r = outp("A", rel)
    rec(f"encoding {rel}", p is not None and r[0] == "OK", f"{r[0] if r else None} {r[3] if r else ''} q{r[4] if r else ''} {r[5] if r else ''}KB")


# metadata
def meta(p):
    im = Image.open(p)
    raw = open(p, "rb").read()
    ex = im.getexif()
    xmp = im.info.get("xmp") or b""
    if isinstance(xmp, str):
        xmp = xmp.encode()
    try:
        iptc = IptcImagePlugin.getiptcinfo(im) or {}
    except Exception:
        iptc = {}
    try:
        th = len(piexif.load(raw).get("thumbnail") or b"")
    except Exception:
        th = -1
    return dict(exif_copy=ex.get(0x8298), exif_artist=ex.get(0x013B), exif_desc=ex.get(0x010E),
                xmp_len=len(xmp), xmp_title=("XMP Title".encode() in xmp), xmp_rights=(b"XMP Rights" in xmp),
                xmp_blob=(b"ts:Blob" in xmp or b"<ts:Blob>" in xmp),
                iptc={k: v for k, v in iptc.items() if k[0] == 2 and k[1] != 0},
                thumb=th, any_copyright=(b"Copyright Holder" in raw), size=len(raw))


for rel in ("meta/exif.jpg", "meta/iptc.jpg", "meta/xmp50k.jpg", "meta/exif_thumb.jpg", "meta/all.jpg",
            "meta/flat_xmp50k.jpg", "meta/xmp_iccstring.jpg"):
    for k in ("A", "B", "C", "D", "F", "G"):
        p, r = outp(k, rel)
        if not p:
            info(f"meta {rel} run {k}", f"row {r}"); continue
        m = meta(p)
        info(f"meta {rel} run {k} [{r[0]} q{r[4]} {m['size']}B notes='{r[6]}']",
             " ".join(f"{a}={b!r}" for a, b in m.items() if a != "size"))
        side, mb, nm = RUNS[k]
        if nm:
            rec(f"meta {rel} run {k} nometa strips metadata", not m["any_copyright"] and not m["xmp_title"]
                and not m["exif_copy"] and not m["iptc"], "")
        if not nm and k in ("A", "F"):
            if rel in ("meta/exif.jpg", "meta/exif_thumb.jpg"):
                rec(f"meta {rel} run {k} keeps EXIF copyright", m["exif_copy"] is not None and "Copyright" in str(m["exif_copy"]),
                    f"{m['exif_copy']!r} artist {m['exif_artist']!r} desc {m['exif_desc']!r}")
            if rel == "meta/iptc.jpg":
                rec(f"meta {rel} run {k} keeps IPTC/copyright", m["any_copyright"], f"iptc {m['iptc']} xmp_len {m['xmp_len']}")
            if rel in ("meta/xmp50k.jpg", "meta/xmp_iccstring.jpg"):
                rec(f"meta {rel} run {k} keeps XMP title+rights", m["xmp_title"] and m["xmp_rights"], f"xmp_len {m['xmp_len']} blob {m['xmp_blob']}")
        if rel == "meta/flat_xmp50k.jpg" and k == "C":
            rec("meta flat+50KB XMP at 30KB: metadata dropped, note shown, under limit",
                "metadata dropped" in r[6] and m["size"] < 30_000 and r[0] == "OK", f"{r[0]} {m['size']}B notes '{r[6]}'")
        if rel == "meta/flat_xmp50k.jpg" and k == "A":
            rec("meta flat+50KB XMP at 500KB: no drop note", "metadata dropped" not in r[6], f"notes '{r[6]}'")
        if nm and "metadata dropped" in r[6]:
            rec(f"meta {rel} run {k}: no drop note with nometa", False, r[6])

# quality sacrifice to keep metadata: compare runs F (meta) and G (nometa) at 100 KB
for rel in ("meta/xmp50k.jpg", "meta/all.jpg", "meta/exif_thumb.jpg"):
    pf, rf = outp("F", rel); pg, rg = outp("G", rel)
    if rf and rg:
        info(f"quality cost of keeping metadata {rel} @100KB", f"with meta {rf[0]} q{rf[4]} {rf[5]}KB '{rf[6]}' | nometa {rg[0]} q{rg[4]} {rg[5]}KB")

# edge
rows = R["A"][0]
for rel in ("edge/zero.jpg", "edge/notajpeg.jpg"):
    r = rows.get(rel)
    rec(f"edge {rel} reported FAILED", r is not None and r[0] == "FAILED", f"{r}")
for rel in ("edge/truncated_half.jpg", "edge/truncated_half_progressive.jpg"):
    r = rows.get(rel)
    p, _ = outp("A", rel)
    detail = f"row {r}"
    silent = False
    if p:
        im = Image.open(p).convert("RGB")
        a = np.asarray(im).astype(int)
        bottom = a[int(a.shape[0] * 0.8):]
        detail += f"; bottom-20% mean {bottom.reshape(-1, 3).mean(0).round(0).tolist()} std {bottom.std():.1f}"
        silent = r[0] == "OK" and not r[6]
    rec(f"edge {rel}: damaged file flagged (FAILED or note)", r is not None and not silent, detail)
p, r = outp("A", "edge/huge12000x8000.jpg")
rec("edge huge 12000x8000", p is not None, f"{r}")
SC = [l for l in [R["A"][0]] if l]
# extensions
for nm in ("ext_x.jpeg", "ext_y.JPG", "ext_z.Jpeg"):
    rec(f"ext {nm} processed", ("ext/" + nm) in rows and rows["ext/" + nm][0] == "OK", "")
for nm in ("ext_w.jpe", "ext_v.jfif"):
    info(f"ext {nm}", "processed" if ("ext/" + nm) in rows else "SKIPPED (not in extension list)")
# clashes
outs = {}
okc = True
det = []
for nm, col in CL.items():
    p, r = outp("A", "clash/" + nm)
    if not p:
        okc = False; det.append(f"{nm}: {r}"); continue
    c = color_at(p, 0.5, 0.5)
    det.append(f"{nm}->{r[2]} {c}")
    if not close(c, col, 20):
        okc = False
    if os.path.realpath(p).lower() in outs:
        okc = False
    outs[os.path.realpath(p).lower()] = nm
nfiles = len([f for f in os.listdir(os.path.join(R["A"][1], "clash"))])
rec("clash names: one distinct output per source, right content", okc and nfiles == len(CL), f"{nfiles} files out; " + "; ".join(det))
p, r = outp("A", nfd)
rec("NFD unicode subfolder+name", p is not None, f"{r[2] if r else None}")
p, r = outp("A", "deep/" + deep)
rec("deep nesting 30 levels keeps layout", p is not None and r[2].count("/") == 31, f"{r[2] if r else None}")
missing = [rel for (f, rel) in DIMS if f == SP and unicodedata.normalize("NFC", rel) not in rows]
rec("every JPEG input has a log row", not missing, str(missing))

# ======================================================================
# 3. Timing: 50 x 4000x3000
TM = os.path.join(T, "timing")
os.makedirs(TM)
srcs = []
for s in range(5):
    pth = os.path.join(TM, f"src{s}.jpg"); photo(4000, 3000, 100 + s).save(pth, "JPEG", quality=90); srcs.append(pth)
for i in range(50):
    if i >= 5:
        shutil.copy(srcs[i % 5], os.path.join(TM, f"img{i:02d}.jpg"))
tot = sum(os.path.getsize(os.path.join(TM, f)) for f in os.listdir(TM))
for side, mb in ((1000, 500_000), (1600, 250_000)):
    rows, scan, dt, rc = run_app(TM, os.path.join(T, f"o_timing_{side}"), side, mb)
    qs = sorted(int(r[4]) for r in rows.values() if r[0] != "FAILED")
    info(f"TIMING 50 x 4000x3000 ({tot / 1e6:.0f} MB) at {side}px/{mb // 1000}KB",
         f"{dt:.1f}s wall, {dt / 50 * 1000:.0f} ms/image, statuses {sorted(set(r[0] for r in rows.values()))}, q range {qs[0]}-{qs[-1]}")
rows, scan, dt, rc = run_app(os.path.join(SP, "edge"), os.path.join(T, "o_edge_only"), 1000, 500_000)
info("TIMING edge folder incl. 12000x8000", f"{dt:.1f}s")

print(f"JPEG SUMMARY: {NPASS} passed, {len(FAILS)} failed")
for f in FAILS:
    print("  FAILED:", f)
sys.exit(1 if FAILS else 0)
