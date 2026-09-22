# Website source files

This directory contains only the source files for the MesoConnect website. It does **not** contain the atlas itself. The downloadable NIfTI atlas maps are under [`data/MesoConnect_Atlas/`](../data/MesoConnect_Atlas/).

## Page source and public URLs

| Source | Public URL | Purpose |
| --- | --- | --- |
| `index.html` | `/` | Landing page and atlas overview |
| `pages/atlas-documentation/` | `/atlas-documentation/` | Atlas map types, filenames, and spatial-reference documentation |
| `pages/tutorial/` | `/tutorial/` | Worked atlas-application tutorial |
| `pages/microstructure/` | `/microstructure/` | Optional NODDI and microstructure workflows |
| `pages/methods/` | `/methods/` | Manuscript methods and parameter distinctions |
| `pages/resources/` | `/resources/` | Software, ROI sources, QA, troubleshooting, and citation guidance |

Shared styles, scripts, and images are in `assets/`. Maintainer notes are in `docs/`. Build and validation scripts are in `scripts/`.

From the repository root, run `npm run dev` to build the deployable copy in `dist/` and preview it locally. Do not edit `dist/`; it is generated and ignored by Git.
