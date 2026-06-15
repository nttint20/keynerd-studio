# Keynerd Studio — Project Notes

Shared progress log for Donald + Codex handoff. Update this file with every meaningful decision so the next person (or AI) has full context.

---

## Project snapshot

| Item | Value |
|------|-------|
| Store | keynerd-studio.myshopify.com |
| Theme dir | `./theme/` |
| Base theme | **Shopify Skeleton** (see note below) |
| Branch | `master` |
| Last updated | 2026-06-15 |

---

## What's done

### 1. Theme initialized (`./theme/`)
- Initialized with `shopify theme init` → cloned **Shopify Skeleton** (the CLI default starter).
- **Important:** The original brief asked for the "Craft" theme. Craft is a paid Shopify theme and is not available via `shopify theme init`. Skeleton is the open-source starter. If you need the commercial Craft theme, purchase it from the Shopify Theme Store and download the `.zip` to replace `./theme/`.

### 2. Color scheme (`config/settings_schema.json` + `config/settings_data.json`)
Three colors are now wired as CSS variables throughout the theme:

| Variable | Hex | Use |
|---|---|---|
| `--color-background` | `#FAFAF8` | Page background (warm white) |
| `--color-foreground` | `#2B2B2B` | Body text, headings |
| `--color-accent` | `#D8A24A` | CTAs, eyebrows, highlights |

**Accent color decision — warm amber `#D8A24A`:**
Chosen over soft teal `#5FA8A0` because: resin/epoxy lamps have inherently golden, amber tones; artisan keycaps in the vintage/craft space use warm palettes; amber reads "handmade" where teal reads "tech/medical". Override: change `accent_color` in `settings_data.json` → `"current"` and rebuild.

### 3. CSS variable exposure (`snippets/css-variables.liquid`)
Added `--color-accent: {{ settings.accent_color }};` alongside the existing background/foreground variables. All three are available site-wide via CSS custom properties.

### 4. Homepage sections (new, in `sections/`)
Three Liquid sections were created for the homepage. Note: Skeleton does not ship with rich homepage sections — these were written from scratch to fulfil the homepage layout requirement.

| File | Purpose |
|------|---------|
| `sections/homepage-hero.liquid` | Full-width hero — eyebrow, H1, subheading, CTA button. All text editable via theme editor. |
| `sections/featured-collections.liquid` | 3-card grid. Each card has title, description, URL (configurable). Placeholder amber circle in card media until collection images are set. |
| `sections/about-teaser.liquid` | 2-column text+image layout. Left: eyebrow + H2 + body + outlined CTA. Right: image picker with warm-grey placeholder. |

### 5. Homepage template (`templates/index.json`)
Sections wired up in order: `hero → collections → about`. All placeholder content is set via `settings` (not hardcoded) so you can change copy in the Shopify admin Theme Editor without touching code.

---

## What's pending

- [ ] **Connect to Shopify** — run `shopify theme dev --store=keynerd-studio.myshopify.com` and complete browser OAuth to push theme to dev environment. See "Dev server" section below.
- [ ] **Create collections in Shopify admin** — three slugs expected by the homepage: `/collections/custom-keycaps`, `/collections/custom-3d-figures`, `/collections/resin-epoxy-lamps`. Create these in admin → Products → Collections.
- [ ] **Upload hero image** — the hero section uses a solid background for now. Swap to a product/lifestyle photo via the Theme Editor.
- [ ] **About image** — upload a workshop/craft photo in Theme Editor → About Teaser → Image.
- [ ] **Navigation menus** — see the menu tree below. Apply in Shopify admin → Online Store → Navigation.
- [ ] **Custom Orders page** — create a Shopify page (`/pages/custom-orders`) with a contact or request form.
- [ ] **FAQ page** — create `/pages/faq` with accordion-style content.
- [ ] **About page** — create `/pages/about` for the "Our story" CTA.
- [ ] **Typography** — current font is Work Sans (Skeleton default). Consider a serif or slab-serif for headings to reinforce the craft aesthetic.
- [ ] **Footer content** — populate links and contact info in `sections/footer.liquid` + Shopify admin.
- [ ] **Favicon + logo** — upload in Shopify admin → Online Store → Preferences.

---

## Open decisions

1. **Craft vs Skeleton** — If the commercial Craft theme is needed, it must be purchased. Worth evaluating whether Skeleton (with these custom sections) is sufficient before buying.
2. **Accent color override** — amber was chosen; teal is the alternative. Easy to swap in `settings_data.json`.
3. **Hero layout** — currently text-only left-aligned. Could add a right-side product image. Requires updating `homepage-hero.liquid`.
4. **Font pairing** — Work Sans (current) is clean but neutral. A heavier serif for H1 (e.g., Playfair Display or Lora) would reinforce the artisan brand. Change `type_primary_font` in `settings_data.json` or via Theme Editor.

---

## Recommended navigation menu tree

> Apply in: Shopify admin → Online Store → Navigation → Main menu

```
Home                    → /
Keycaps                 → /collections/custom-keycaps
3D Figures              → /collections/custom-3d-figures
Lamps & Crafts          → /collections/resin-epoxy-lamps
About                   → /pages/about
FAQ                     → /pages/faq
Custom Orders           → /pages/custom-orders
```

Footer menu (suggested):
```
About          → /pages/about
FAQ            → /pages/faq
Custom Orders  → /pages/custom-orders
Shipping       → /pages/shipping
Returns        → /pages/returns
Contact        → /pages/contact
```

---

## Dev server

To preview the theme live:

```bash
cd "~/Keynerd Web/theme"
shopify theme dev --store=keynerd-studio.myshopify.com
```

On first run this opens a browser for Shopify Partners/admin OAuth. Complete login there, then the CLI will print a local preview URL (usually `http://127.0.0.1:9292`).

**Theme push (when ready):**
```bash
shopify theme push --store=keynerd-studio.myshopify.com
```

---

## Repo structure

```
Keynerd Web/
├── theme/                  ← Shopify theme (Skeleton base)
│   ├── assets/
│   ├── blocks/
│   ├── config/
│   │   ├── settings_schema.json   ← color + font + layout schema
│   │   └── settings_data.json     ← active values (background, foreground, accent)
│   ├── layout/
│   │   └── theme.liquid
│   ├── locales/
│   ├── sections/
│   │   ├── homepage-hero.liquid         ← new: hero banner
│   │   ├── featured-collections.liquid  ← new: 3-card collection grid
│   │   ├── about-teaser.liquid          ← new: text+image about section
│   │   ├── custom-section.liquid        ← Skeleton built-in (blocks-based)
│   │   ├── header.liquid
│   │   ├── footer.liquid
│   │   └── ...
│   ├── snippets/
│   │   └── css-variables.liquid         ← exposes --color-accent
│   └── templates/
│       └── index.json                   ← homepage: hero → collections → about
├── keynerd-studio-theme/   ← empty placeholder (can delete)
└── NOTES.md                ← this file
```
