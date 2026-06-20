#!/usr/bin/env bash
# Generate room renders for free via Pollinations.ai (FLUX). No API key needed.
# Re-run any time to regenerate; change SEED for new variations.
set -euo pipefail
cd "$(dirname "$0")"
SEED="${SEED:-7}"
W=1024; H=768
STYLE="bright natural daylight, wide-angle architectural interior photography, photorealistic, 4k, highly detailed"

gen () {
  local id="$1"; local prompt="$2"
  local full="Photorealistic interior design render, ${prompt}, ${STYLE}"
  local enc; enc=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$full")
  local url="https://image.pollinations.ai/prompt/${enc}?width=${W}&height=${H}&nologo=true&model=flux&seed=${SEED}"
  echo "→ ${id}"
  curl -s -L --max-time 180 -o "${id}.jpg" "$url"
  # sanity check it's a real image
  file "${id}.jpg" | grep -q "image data" || { echo "FAILED ${id}"; return 1; }
}

gen master  "main bedroom, oak slat headboard wall, oatmeal and camel linen bedding, mustard and cobalt blue cushions, woven rattan pendant light, warm oak floor, one large leafy plant, calm and warm"
gen ensuite "small ensuite bathroom, terracotta and cream zellige tiles, oak vanity, round mirror, brass fixtures, warm task lighting"
gen bed2    "soft light bedroom, cream walls, dusty pink textiles and bedding, oak desk, playful graphic print on wall, rattan accents"
gen bed3    "bedroom with cobalt blue feature wall, oak bed frame, mustard yellow throw blanket, mid-century desk lamp"
gen living  "living and dining room, camel velvet tufted sectional sofa, dusty pink accents, travertine coffee tables, mid-century spindle lounge chairs, teak dining table with cobalt blue Cesca chairs, brass globe pendant light, mustard graphic wall art, oak trim, lots of greenery"
gen ensbath "common bathroom, muted green and cobalt blue tile, oak accents, brass fixtures, round mirror"
gen kitchen "kitchen with oak cabinetry, cream and terracotta tiled splashback, brass tap, open shelving with ceramics"

echo "Done. Generated $(ls -1 *.jpg | wc -l | tr -d ' ') renders."
