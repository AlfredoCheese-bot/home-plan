#!/usr/bin/env bash
# Regenerate inspiration/manifest.json by scanning each room's folder.
# Run this after adding/removing images in inspiration/<roomId>/.
cd "$(dirname "$0")"
python3 - <<'PY'
import os, json
rooms = ["master","ensuite","bed2","bed3","living","ensbath","kitchen"]
exts = (".jpg",".jpeg",".png",".webp")
m = {}
for r in rooms:
    if os.path.isdir(r):
        files = sorted(f for f in os.listdir(r) if f.lower().endswith(exts))
        if files:
            m[r] = files
json.dump(m, open("manifest.json","w"), indent=2)
print("wrote manifest.json:", json.dumps(m))
PY
