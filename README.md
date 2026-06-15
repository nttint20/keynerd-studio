# Keynerd Studio

Shopify theme repo for [keynerd-studio.myshopify.com](https://keynerd-studio.myshopify.com)

Sells custom keycaps, 3D-printed figures, and resin/epoxy lamps — all handcrafted in Vietnam.

## Setup

```bash
git clone https://github.com/nttint20/keynerd-studio.git
cd keynerd-studio
cp .env.example .env
# Fill in .env with your Shopify credentials
```

## Dev server

```bash
cd theme
shopify theme dev --store=keynerd-studio.myshopify.com --password=$SHOPIFY_ACCESS_TOKEN
```

## Structure

```
keynerd-studio/
├── theme/          ← Shopify theme files
├── .env.example    ← Credentials template (copy to .env)
├── NOTES.md        ← Project log & handoff notes
└── README.md
```
