# MesoConnect Atlas Tutorial

This directory contains the Docusaurus source that Vercel builds for the MesoConnect Atlas Tutorial.

- Primary website: https://mesoconnect.vercel.app/
- GitHub Pages copy: https://diffusiontensorimaging-repos.github.io/MesoConnect-Tutorial/
- Upstream source: https://github.com/DiffusionTensorImaging-Repos/MesoConnect-Tutorial
- Snapshot source commit: `8c747183cab6f3ac66400eaf0844c212744a5a44`

The source replaces the former static website that was stored in this repository. Vercel is connected to the main MesoConnect repository and uses `website/` as its project root, so pushes to `main` deploy this copy. Changes here do not update the separate GitHub Pages deployment; synchronize changes with the upstream tutorial repository when both versions should match.

## Site contents

The tutorial documents corridor-constrained participant-level tractography with the MesoConnect atlas. It covers registration, corridor construction, tractography, pyAFQ cleaning, visual quality control, whole-tract and nodewise microstructure, statistical analysis, and an interactive nodewise-results explorer.

```text
docs/                Tutorial and reference pages
src/                 Landing page and custom styling
static/atlas/        Seed and target regions used in the example
static/downloads/    Atlas-package mirror served by the tutorial
static/explorer/     Node-wise Tract Explorer and sample data
static/img/          De-identified example figures
static/scripts/      Reusable workflow scripts
static/supplement/   Supplementary Methods in PDF and DOCX formats
tools/               Documentation build helpers
```

The canonical atlas files remain in [`../data/MesoConnect_Atlas/`](../data/MesoConnect_Atlas/). The ZIP under `static/downloads/` is the tutorial's download mirror.

## Local development

Node.js 20 or later is required.

```bash
npm ci
npm run start
```

Build and validate the static site with:

```bash
npm run build
```

The default build uses the GitHub Pages base path. To reproduce Vercel's root-path build locally, use:

```bash
VERCEL=1 npm run build
```

The production build is written to `build/`, which is ignored by Git.

## Synchronizing from upstream

When the upstream tutorial changes, copy its tracked source files into this directory while excluding the upstream `.git/` directory and `.github/` deployment workflow. Record the imported upstream commit in this README and run `npm ci && npm run build` before committing the synchronized snapshot.
