---
name: newsletter-builder
description: >-
  Build the Major Key Group monthly "Inland Northwest Real Estate" newsletter — a
  single self-contained, responsive HTML page (Spokane & Coeur d'Alene market data,
  seller/buyer tips, events, food, outdoors) styled to the Major Key Group brand,
  with interactive Chart.js charts and an iframe embed for Luxury Presence. Use when
  the user asks to create, update, or regenerate the monthly real estate newsletter,
  or to produce a responsive embed for it.
---

# Newsletter Builder — Major Key Group Monthly Real Estate Report

Produces one self-contained `index.html` (no build step; Chart.js loaded from CDN).
The page is responsive across mobile / tablet / desktop and broadcasts its own height
for iframe auto-sizing. Deployed as a static site on Netlify; embedded on a Luxury
Presence blog.

`assets/example-newsletter.html` is the canonical reference (June 2026 edition). Copy
it and swap the monthly content rather than building from scratch.

## Workflow

1. **Copy** `assets/example-newsletter.html` → `index.html`.
2. **Update the masthead**: month/year in `.masthead-sub` and the `<title>`.
3. **Update the data** for the new month (see "Monthly content checklist").
4. **Verify responsiveness** in a browser at 375 / 768 / 1280 px (see "Verifying").
5. **Deploy** to Netlify (drag-and-drop the folder, or push to the connected repo).
6. **Generate the embed** for Luxury Presence (see "Embeds").

## Design system (do not drift)

- Fonts: **Cormorant Garamond** (serif, headlines/numbers) + **Montserrat** (sans, body), via Google Fonts.
- CSS variables in `:root`:
  - `--ink:#1a1a1a` `--cream:#faf8f4` `--warm-mid:#ece8e1` `--pine:#262524` (dark brand block)
  - `--rust:#9a8f7e` `--gold:#bdb9b1` (Major Key Group gold) `--muted:#8a8074` `--border:#e3ddd3`
- Chart palette: Spokane `#185F9F` (blue), Kootenai `#bdb9b1` (gold), secondary dashed `#85B7EB`.
- Content column: `.wrapper` is `width:100%; max-width:816px; margin:0 auto` (816 = print-style max).
- Dark blocks (masthead, stat highlight cell, pullquote, footer) use `--pine` / `--ink`.

## Page structure (section order)

masthead → intro bar → Market Snapshot (Spokane + Kootenai stat grids, two-column
commentary, interactive charts) → pullquote → For Sellers → For First-Time Buyers →
Watch Out For → June Around Spokane (events) → June Around Coeur d'Alene (events) →
Food & Drink → Get Outside (hikes) → footer (logo, team photo, contact, disclaimer).

## Responsive system (three tiers)

- **Desktop (≥816px):** default styles; centered 816px column, 48px section padding.
- **Tablet (541–815px):** `@media (min-width:541px) and (max-width:815px)` — 36px padding, masthead 40px, h2 26px, pullquote bleed −36px.
- **Mobile (≤540px):** `@media (max-width:540px)` — edge-to-edge (body padding 0), 24px padding, masthead 34px, h2 24px, and `.two-col / .footer-cols / .stats-grid` collapse to one column.

Rule: every layout grid that is 2-up on desktop must collapse to 1-up on mobile.
After any structural change, re-verify there is **no horizontal overflow** at 320/375/768/1280.

## Charts (Chart.js v4, CDN)

Six `<canvas>` elements cover {Spokane, Kootenai} × {prices, market conditions, sales
activity}. Two button rows toggle area and metric via `showArea()` / `showMetric()`.
All charts are `responsive:true, maintainAspectRatio:false` inside a fixed 220px-tall
container. Monthly series run Apr 2023 → current month (`ml` labels array). Update the
data arrays and append the new month's label/value to each dataset.

## Auto-height reporter (already in the template)

A script before `</body>` posts the document height to the parent so an iframe can
auto-size:

```js
parent.postMessage({ mkgNewsletterHeight: <pixels> }, '*');
```

It fires on `load`, on `resize`, and at 300/800/1500/3000ms (so charts + fonts settle).
Keep this — `embed-autoheight.html` depends on it.

## Embeds

Two embed snippets live in `assets/`:

- **`embed-autoheight.html`** — exact fit, zero whitespace. Needs a host that runs
  inline `<script>` (landing-page custom-code sections, WordPress Custom HTML, raw HTML).
- **`embed-luxury-presence.html`** — **no JavaScript**, pure CSS media-query heights.
  Use inside a Luxury Presence **blog** "Embed / Code / HTML" block, which strips
  `<script>`. Guarantees no cutoff; accepts minor trailing whitespace.

Choosing: if the target host executes scripts on the *published* page (not just the
editor preview), prefer auto-height. Luxury Presence blog bodies do **not** — use the
no-JS version there.

### Generating the no-JS embed (re-measure when content length changes)

The CSS heights in `embed-luxury-presence.html` are specific to one edition. When the
newsletter's length changes, re-measure and regenerate:

1. Serve the new `index.html` locally (e.g. a Ruby WEBrick one-liner — macOS `python3 -m http.server` may be sandbox-blocked).
2. At each width, load the page and read `document.documentElement.scrollHeight` after a
   ~2.5s wait (let Chart.js + fonts settle). Measure ~360, 390, 414, 480, 540, 541, 620, 700, 815, 816.
3. For each `@media (min-width:W)` step, set `height` = measured height at W **+ ~300–500px buffer**
   (never below the tallest height in that range, or it clips).
4. Verify in a parent-page harness at 375 / 768 / 1280 that the rendered iframe height
   ≥ the content height (no cutoff) and the footer is fully visible.

Height falls as width grows (a phone is ~17.6k tall; desktop caps ~11k at the 816 column).
Note the small bump at 541px where the tablet breakpoint restores 2-column grids.

## Monthly content checklist

- [ ] Masthead month/year + `<title>`
- [ ] Intro bar lede (1 paragraph, current-month framing)
- [ ] Spokane Co. stat grid: median price, median cumulative DOM, months supply, closed sales (+ YoY notes)
- [ ] Kootenai Co. stat grid: same four metrics
- [ ] Two-column Spokane/Kootenai commentary
- [ ] Chart datasets: append the new month to `ml` and every dataset; update y-axis min/max if needed
- [ ] Pullquote (a current, attributed market quote)
- [ ] For Sellers / For First-Time Buyers / Watch Out For (refresh to the month's data)
- [ ] Spokane events + Coeur d'Alene events (dates/venues for the month)
- [ ] Food & Drink openings; Get Outside (seasonal trails/lakes)
- [ ] Footer contact/links unchanged unless team info changes
- [ ] Re-measure + regenerate the no-JS embed if length changed
- [ ] Update Netlify site name / embed `src` if a new URL is used

## Verifying

In a browser at 375 / 768 / 1280 px confirm: no horizontal scroll; 2-up grids collapse
to 1-up on mobile; charts render and toggle; footer fully visible. For the no-JS embed,
test inside a parent harness (an outer HTML page that iframes the live URL) — the
in-editor preview of most hosts does not reflect script/height behavior.

## Compliance notes (real estate)

Idaho is non-disclosure: do not publish individual Kootenai sale prices. Washington
(Spokane) is a disclosure state. Keep the footer disclaimer (informational only, not a
solicitation; Equal Housing Opportunity; KW Coeur d'Alene + KW Spokane). Cite data
sources (Spokane REALTORS®, MLS of CDA Regional REALTORS® / InfoSparks).
