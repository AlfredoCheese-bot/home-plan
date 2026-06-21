#!/usr/bin/env bash
# Regenerate board.json by scanning each room's concept/ and inspiration/ folders.
# Concepts = the burned design renders. Inspirations = the reference mood images.
# Run after adding/removing images in concept/<roomId>/ or inspiration/<roomId>/.
cd "$(dirname "$0")"
python3 - <<'PY'
import os, json
rooms = ["master","ensuite","bed2","bed3","living","ensbath","kitchen"]
exts = (".jpg",".jpeg",".png",".webp")
def ls(p): return sorted(f for f in os.listdir(p) if f.lower().endswith(exts)) if os.path.isdir(p) else []
m = {}
for r in rooms:
    c, i = ls(os.path.join("concept", r)), ls(os.path.join("inspiration", r))
    if c or i:
        m[r] = {"concepts": c, "inspirations": i}
json.dump(m, open("board.json", "w"), indent=2)
print(json.dumps(m, indent=2))
PY
