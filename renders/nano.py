#!/usr/bin/env python3
"""
Nano Banana (Google Gemini image model) helper — true image-to-image / reference blending.

Setup once:
  1. Get a free API key at https://aistudio.google.com/apikey
  2. Save it (this file is gitignored, never pushed):
       echo 'YOUR_KEY' > /Users/joelzee/Documents/HOME_PLAN/.gemini_key
     ...or export GEMINI_API_KEY=YOUR_KEY

Usage:
  # blend reference photo(s) into a fresh render for a room, write renders/<room>.jpg
  python3 renders/nano.py --room living --prompt "keep our layout, adopt this warm moody lighting" \
      --ref ref1.jpg ref2.jpg

  # text-only generation to an explicit file
  python3 renders/nano.py --out renders/test.jpg --prompt "moody walnut living room, paper lanterns"

Notes:
  - The key is free to create. Image OUTPUT may require enabling billing on the
    Google Cloud project (cost is ~US$0.04/image). It will tell you if so.
"""
import argparse, base64, json, os, sys, urllib.request, urllib.error, mimetypes, pathlib

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
MODEL = os.environ.get("NANO_MODEL", "gemini-2.5-flash-image")

def load_key():
    k = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if k:
        return k.strip()
    kf = ROOT / ".gemini_key"
    if kf.exists():
        return kf.read_text().strip()
    sys.exit("No API key. Put it in .gemini_key or set GEMINI_API_KEY. "
             "Get one free at https://aistudio.google.com/apikey")

def part_for_image(path):
    p = pathlib.Path(path)
    if not p.is_absolute():
        p = ROOT / p
    if not p.exists():
        sys.exit(f"Reference image not found: {p}")
    mime = mimetypes.guess_type(str(p))[0] or "image/jpeg"
    data = base64.b64encode(p.read_bytes()).decode()
    return {"inline_data": {"mime_type": mime, "data": data}}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--prompt", required=True)
    ap.add_argument("--room", help="room id -> writes renders/<room>.jpg")
    ap.add_argument("--out", help="explicit output path")
    ap.add_argument("--ref", nargs="*", default=[], help="reference image path(s)")
    args = ap.parse_args()

    out = args.out or (str(HERE / f"{args.room}.jpg") if args.room else None)
    if not out:
        sys.exit("Provide --room or --out for the output path.")

    parts = [{"text": args.prompt}] + [part_for_image(r) for r in args.ref]
    payload = {"contents": [{"parts": parts}]}
    # Optional higher-res output (Nano Banana Pro): NANO_SIZE=1K|2K|4K, NANO_AR=4:3 etc.
    img_cfg = {}
    if os.environ.get("NANO_SIZE"): img_cfg["imageSize"] = os.environ["NANO_SIZE"]
    if os.environ.get("NANO_AR"): img_cfg["aspectRatio"] = os.environ["NANO_AR"]
    if img_cfg: payload["generationConfig"] = {"imageConfig": img_cfg}
    body = json.dumps(payload).encode()
    url = (f"https://generativelanguage.googleapis.com/v1beta/models/"
           f"{MODEL}:generateContent?key={load_key()}")
    req = urllib.request.Request(url, data=body,
                                 headers={"Content-Type": "application/json"})
    try:
        resp = json.load(urllib.request.urlopen(req, timeout=180))
    except urllib.error.HTTPError as e:
        sys.exit(f"API error {e.code}:\n{e.read().decode()[:800]}")

    img_b64 = None
    for cand in resp.get("candidates", []):
        for p in cand.get("content", {}).get("parts", []):
            inline = p.get("inlineData") or p.get("inline_data")
            if inline and inline.get("data"):
                img_b64 = inline["data"]; break
        if img_b64:
            break
    if not img_b64:
        sys.exit("No image in response:\n" + json.dumps(resp)[:800])

    pathlib.Path(out).write_bytes(base64.b64decode(img_b64))
    print(f"Wrote {out}")

if __name__ == "__main__":
    main()
