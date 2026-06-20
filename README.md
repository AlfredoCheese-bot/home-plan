# Our Home — Design & Walkthrough

Interactive visualisation of our 4-room flat: explore the layout in 3D and review the
interior design room by room. All pages are self-contained HTML — no build step, no
dependencies.

## Pages

| File | What it is |
|------|------------|
| `index.html` | Landing page linking the two tools below |
| `home-3d-model.html` | 3D walkthrough of the whole unit |
| `home-design-board.html` | Clickable floor plan with per-room design direction, palette, and renders |

## View it

Open `index.html` in any browser, or visit the published link (see **Publishing** below).

### 3D walkthrough controls
- **Orbit:** drag (one finger on touch)
- **Zoom / pan:** scroll, or pinch and two-finger drag
- **Iso / Top / Reset:** fixed camera angles
- **Walls / Ceiling / Labels / Furniture:** toggle on/off
- **Walk through:** step inside at eye level — on-screen pad or WASD to move, drag to look,
  **↺ Entrance** to return to the front door, Esc to exit

### Design board
- Tap a room to see its palette and design notes.
- **Add render:** save a render image, then tap "Add render" on that room. Saved renders
  persist on the device when run inside the Claude app; on a plain web host they show for
  the session only.

## Layout notes

Dimensions are scaled from the original blueprint (millimetres). These are **concept
visuals — not to construction scale**; use the source drawings for any build measurements.

## Publishing (GitHub Pages)

1. Push this folder to a **public** GitHub repository.
2. **Settings → Pages →** Source: *Deploy from a branch*, Branch: `main`, folder `/ (root)`.
3. Wait ~1 minute — the live link appears at the top of the Pages settings:
   `https://<username>.github.io/<repo>/`
