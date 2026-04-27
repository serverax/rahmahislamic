"""Optimize the Rahma 3D icon set.

Reads each `*_3d.{png,jpg}` in assets/icons/, downscales to 512x512
(preserving aspect via PIL.Image.thumbnail), strips metadata, and writes
two outputs side by side:

  - <name>.webp  : WebP, quality 90, method 6 (best compression)
  - <name>.png   : PNG, optimized (used as fallback if Flutter has issues
                   with WebP for that specific image; usually it doesn't)

Why both: WebP is smaller and Flutter supports it fine on iOS/Android/Web,
but Windows desktop's image_io plugin has occasional WebP issues. Keeping
optimized PNG as fallback costs little.

After this runs, switch IconAssets.dart constants to point at the .webp
variants and delete the originals.

Idempotent. Safe to re-run.
"""

import sys
from pathlib import Path

from PIL import Image

ICONS_DIR = Path(__file__).resolve().parent.parent / 'assets' / 'icons'
TARGET_MAX = 512  # max dimension; smaller dimension scales proportionally

ICONS = [
    'mosque_3d.png',
    'quran_3d.png',
    'tasbih_3d.png',
    'dua_3d.png',
    'qibla_3d.jpg',
    'sheikh_3d.png',
    'books_3d.png',
    'dream_3d.png',
]


def kb(p: Path) -> int:
    return p.stat().st_size // 1024


def optimize(name: str) -> None:
    src = ICONS_DIR / name
    if not src.exists():
        print(f'  SKIP (not found): {name}')
        return

    before_kb = kb(src)
    img = Image.open(src)

    # Strip EXIF / metadata by recreating
    if img.mode not in ('RGBA', 'RGB'):
        img = img.convert('RGBA')

    img.thumbnail((TARGET_MAX, TARGET_MAX), Image.Resampling.LANCZOS)

    stem = src.stem
    webp_out = ICONS_DIR / f'{stem}.webp'
    png_out = ICONS_DIR / f'{stem}.png'

    # WebP — quality 90, method 6 (slowest, best compression)
    img.save(webp_out, format='WEBP', quality=90, method=6)

    # PNG — optimized
    if img.mode != 'RGBA':
        img.convert('RGBA').save(png_out, format='PNG', optimize=True)
    else:
        img.save(png_out, format='PNG', optimize=True)

    print(
        f'  {name:20s}  {before_kb:>4d} KB  ->  '
        f'webp {kb(webp_out):>3d} KB  /  png {kb(png_out):>3d} KB'
    )


def main() -> None:
    print(f'Optimizing icons in {ICONS_DIR}')
    print(f'Target max dimension: {TARGET_MAX}x{TARGET_MAX}\n')
    if not ICONS_DIR.exists():
        print(f'ERROR: icons directory not found: {ICONS_DIR}', file=sys.stderr)
        sys.exit(1)
    for name in ICONS:
        optimize(name)
    print('\nDone. Update IconAssets.dart to point at the .webp files,')
    print('then delete the original *_3d.png/.jpg if you want the savings to land.')


if __name__ == '__main__':
    main()
