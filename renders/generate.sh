#!/usr/bin/env bash
# Generate room renders for free via Pollinations.ai (FLUX). No API key needed.
# Direction: warm Japandi / modern-Asian apartment, inspired by an @inmustudio
# reference set the owner supplied (walnut joinery, cream stone, dark walnut
# floors, rice-paper lantern lighting, moody warm light, green marble accent).
# Re-run any time; change SEED for new variations.
set -euo pipefail
cd "$(dirname "$0")"
SEED="${SEED:-31}"
W=1024; H=768
STYLE="warm Japandi modern-Asian apartment interior, floor-to-ceiling walnut wood cabinetry and joinery, cream travertine and limestone stone surfaces, round rice-paper Noguchi-style lantern pendant lighting, soft warm dim ambient lighting 2700K, hanging plants and greenery, cozy collected eclectic decor, cinematic real-estate render, photorealistic, wide-angle architectural interior photography, 4k, highly detailed"

gen () {
  local id="$1"; local prompt="$2"
  local full="Photorealistic interior design render, ${prompt}, ${STYLE}"
  local enc; enc=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$full")
  local url="https://image.pollinations.ai/prompt/${enc}?width=${W}&height=${H}&nologo=true&model=flux&seed=${SEED}"
  echo "→ ${id}"
  curl -s -L --max-time 180 -o "${id}.jpg" "$url"
  file "${id}.jpg" | grep -q "image data" || { echo "FAILED ${id}"; return 1; }
}

gen master  "main bedroom, walnut slat headboard feature wall, oatmeal and camel linen bedding with a mustard throw and a cobalt blue cushion, woven rattan pendant, warm walnut hardwood floor, one large leafy plant, calm and cozy"
gen ensuite "small ensuite bathroom, walnut vanity, cream stone countertop, terracotta and cream zellige accent tiles, round mirror, brass fixtures, warm moody task lighting"
gen bed2    "soft bedroom, warm walnut joinery, cream walls, dusty-pink bedding and textiles, walnut desk, a playful graphic print on the wall, rattan accents, paper lantern, plants"
gen bed3    "bedroom with a deep cobalt-blue feature wall, walnut bed frame and joinery, mustard yellow throw, mid-century desk lamp, warm dim lighting, walnut floor"
gen living  "open living and dining room, sage-green fabric sofa, dark walnut hardwood floor, low cream stone coffee table, round white rice-paper lantern pendant, green moody marble feature wall beside a walnut dry-kitchen counter, warm dim cove lighting, hanging trailing plants, cozy eclectic tiger-print throw, full-height walnut cabinetry, wood dining table with black-frame leather chairs"
gen ensbath "common bathroom, walnut accents, muted green stone tile, cream stone counter, brass fixtures, round mirror, warm moody lighting"
gen kitchen "galley kitchen, warm walnut wood cabinetry top and bottom, cream stone countertops, grey stone tile floor, black induction cooktop, integrated stainless appliances, green moody marble backsplash accent, warm backlit shoji-style panel, wooden fruit bowl, minimal and warm"

echo "Done. Generated $(ls -1 *.jpg | wc -l | tr -d ' ') renders."
