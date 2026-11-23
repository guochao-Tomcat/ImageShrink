"""Creates the self-test image folder. Usage: make_fixtures.py <dir>"""
import os
import sys

import numpy as np
from PIL import Image

root = sys.argv[1]
sub = os.path.join(root, "sub folder", "深层")
os.makedirs(sub, exist_ok=True)
os.makedirs(os.path.join(root, "previous_1000px"), exist_ok=True)
rng = np.random.default_rng(7)


def noise(w, h):
    return Image.fromarray(rng.integers(0, 256, (h, w, 3), dtype=np.uint8))


def smooth(w, h):
    x = np.linspace(0, 255, w)
    y = np.linspace(0, 255, h)
    a = np.dstack([np.tile(x, (h, 1)), np.tile(y[:, None], (1, w)), np.full((h, w), 120)])
    return Image.fromarray(a.astype(np.uint8))


p = lambda *n: os.path.join(root, *n)

noise(6000, 4000).save(p("big_noise.tif"))
noise(1000, 1000).save(p("fine_detail.tif"))
smooth(3000, 4500).save(p("A.png"))
smooth(3000, 2000).save(p("A.tif"))
smooth(1500, 1000).save(p("-dash.png"))
smooth(600, 400).save(p("small.jpg"), quality=90)
smooth(12000, 800).save(p("pano.tif"))
smooth(2400, 3600).save(os.path.join(sub, "黄尧 山水 1975.JPG"), quality=90)

g = (np.tile(np.linspace(0, 65535, 3000), (2000, 1))).astype(np.uint16)
Image.fromarray(g).save(p("gray16.tif"))

smooth(3000, 2000).convert("CMYK").save(p("cmyk.jpg"), quality=90)

a = Image.new("RGBA", (2000, 2000), (0, 0, 0, 0))
a.paste((200, 30, 30, 255), (700, 700, 1300, 1300))
a.save(p("alpha.png"))

# Stored sideways: left half red, right half blue, EXIF orientation 6 (rotate 90° clockwise to view)
r = Image.new("RGB", (1600, 800), (0, 0, 255))
r.paste((255, 0, 0), (0, 0, 800, 800))
ex = Image.Exif()
ex[0x0112] = 6
r.save(p("rotated.jpg"), quality=92, exif=ex.tobytes())

m = smooth(3000, 2000)
ex = Image.Exif()
ex[0x010E] = "Test title for ImageShrink"
ex[0x8298] = "Huang Yao Foundation"
m.save(p("meta.jpg"), quality=92, exif=ex.tobytes())

import io as _io
_b = _io.BytesIO(); smooth(3000, 2000).save(_b, "JPEG", quality=90)
open(p("motion.jpg"), "wb").write(_b.getvalue() + bytes(rng.integers(0, 256, 1_000_000, dtype=np.uint8)))  # video appended after the JPEG
open(p("broken.jpg"), "wb").write(b"this is not an image")
open(p("notes.txt"), "w").write("not an image")
smooth(2000, 2000).save(p(".hidden.jpg"))
smooth(2000, 2000).save(p("previous_1000px", "old.jpg"))
open(p("previous_1000px", "ImageShrink log.txt"), "w").write("old log")
print("fixtures written to", root)
