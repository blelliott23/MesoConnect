# MesoConnect Atlas and tutorial website

MesoConnect is a human 7T diffusion tractography atlas of seven bilateral mesolimbic pathways. This repository contains the public atlas package, a static tutorial website, an annotated Inferior VTA–NAc application script, selected manuscript figures, and the FSL MNI152 1 mm brain reference used with the atlas.

**[Open the tutorial website](https://mesoconnect.vercel.app)** · **[Download the complete atlas](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip)** · **[Browse the atlas files](data/MesoConnect_Atlas)** · **[Open the worked script](examples/mesoconnect_inferior_vta_nac_template.sh)**

## Start here

| I want to… | Go to |
| --- | --- |
| Learn what the atlas contains | [Live atlas overview](https://mesoconnect.vercel.app) |
| Download everything in one file | [MesoConnect_Atlas.zip](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip) |
| Browse individual NIfTI maps | [`data/MesoConnect_Atlas/`](data/MesoConnect_Atlas) |
| Follow the application workflow | [Worked tutorial](https://mesoconnect.vercel.app/tutorial/) |
| Run an annotated example | [`examples/mesoconnect_inferior_vta_nac_template.sh`](examples/mesoconnect_inferior_vta_nac_template.sh) |
| Edit the website | [`docs/EDITING_GUIDE.md`](docs/EDITING_GUIDE.md) |

The similarly named paths serve different purposes: `atlas-files/` is the source for the website's **Atlas files** explanatory page; `data/MesoConnect_Atlas/` contains the actual downloadable atlas data. There is no second atlas-data folder.

## Download the atlas

- [Download the complete MesoConnect Atlas ZIP](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip)
- [Browse the atlas package on GitHub](data/MesoConnect_Atlas)
- [Review atlas filenames and map types](https://mesoconnect.vercel.app/atlas-files/)

The ZIP contains all 28 atlas maps, `mesoconnect_subject_counts.csv`, the FSL MNI152 1 mm brain reference, and the package documentation and licensing notices. Its SHA-256 checksum is stored in `downloads/MesoConnect_Atlas.zip.sha256`.

## What is included

- A responsive overview of the seven pathways and three proposed functional groupings.
- An atlas-files guide covering MNI space, `overlap_prop` and `thr50` maps, filenames, thresholds, and interpolation.
- The complete atlas package under `data/MesoConnect_Atlas`, including 28 NIfTI maps and hemisphere-specific subject counts.
- An eight-step Inferior VTA–NAc corridor tutorial with copyable commands.
- A well-annotated single-participant shell template with dry-run checks and overwrite protection.
- Manuscript Figures 1–3 in the sections where they explain the atlas most clearly.
- Clearly labeled placeholders for future participant-specific corridor and quality-control screenshots.
- Editing, figure-placement, source-handling, licensing, and provenance notes.

## Preview locally

From the repository root:

```bash
npm run dev
```

Then open `http://localhost:4173`. The site uses plain HTML, CSS, and JavaScript; it has no runtime dependencies or build step.

## Validate before publishing edits

```bash
npm run check
```

The checker validates local links and assets, duplicate HTML IDs, image alternative text, and shell syntax for the runnable example.

## Repository structure

```text
.
├── index.html                         # Landing page and atlas overview
├── atlas-files/index.html             # Map types, names, thresholds, downloads
├── tutorial/index.html                # Eight-step application tutorial
├── methods/index.html                 # Atlas methods and parameter distinctions
├── resources/index.html               # Software, QA, troubleshooting, citation
├── assets/
│   ├── css/styles.css                 # Entire visual system; Helvetica-led font stack
│   ├── js/site.js                     # Navigation, copy buttons, tutorial progress
│   └── images/
│       ├── brand/                     # MesoConnect mark
│       ├── manuscript/                # Extracted manuscript Figures 1–3
│       └── figures/                   # Remaining editable SVG placeholders
├── data/MesoConnect_Atlas/
│   ├── README.md                      # Atlas package documentation
│   ├── LICENSE                        # Material-specific data and software terms
│   ├── mesoconnect_subject_counts.csv
│   ├── templates/                     # FSL MNI152 1 mm brain + provenance
│   └── <seven pathway folders>/       # Left/right overlap_prop and thr50 maps
├── downloads/
│   ├── MesoConnect_Atlas.zip           # Complete downloadable atlas package
│   └── MesoConnect_Atlas.zip.sha256    # Archive integrity checksum
├── examples/
│   └── mesoconnect_inferior_vta_nac_template.sh
├── docs/
│   ├── EDITING_GUIDE.md
│   ├── FIGURE_PLAN.md
│   └── SOURCE_NOTES.md
├── scripts/check-site.mjs
├── package.json
└── vercel.json
```

## Editing the website

### Text and navigation

Each page is an ordinary `index.html` file. Search for the visible heading you want to change. The header and footer are repeated on every page so navigation works without JavaScript; update all five HTML pages when adding or renaming a navigation item.

### Colors and typography

Edit the design variables at the top of `assets/css/styles.css`. `--font-sans` begins with Helvetica Neue and Helvetica, with Arial and system sans-serif fallbacks. Code uses a separate monospace stack.

### Figures

Manuscript Figures 1–3 live in `assets/images/manuscript`. The remaining tutorial and QA figure slots use editable SVGs under `assets/images/figures`. When replacing a figure, update its image path, alternative text, dimensions, and caption together. See `docs/FIGURE_PLAN.md` for placement and screenshot guidance.

### Tutorial commands

Keep these files synchronized:

- `tutorial/index.html` for reader-facing commands.
- `examples/mesoconnect_inferior_vta_nac_template.sh` for the runnable workflow.

The dilation step uses an explicit 2 mm-radius spherical kernel:

```bash
fslmaths input_thr50.nii.gz -kernel sphere 2 -dilF -bin output_thr50_dil2mm.nii.gz
```

This is more explicit than repeating FSL's default `-dilM` operation. It is intentionally a 2 mm spherical maximum dilation and is not voxel-for-voxel identical to two default mean-dilation passes.

## Atlas package

Each of the seven pathway folders contains four maps:

- Left and right `*_overlap_prop.nii.gz` continuous overlap-proportion maps.
- Left and right `*_thr50.nii.gz` binary 50% consensus maps.

Subject denominators are in `data/MesoConnect_Atlas/mesoconnect_subject_counts.csv`. See the atlas package README for the exact naming convention, dimensions, and quick-start commands.

## Licensing

The repository needs scoped terms because it combines several material types:

- HCP-derived atlas maps and subject-count data: WU-Minn HCP Consortium Open Access Data Use Terms.
- Original MesoConnect documentation and figures: CC BY 4.0.
- Original website and shell-script code: MIT License.
- FSL MNI152 template: FSL license for non-commercial use and redistribution subject to its conditions.

See `LICENSE`, `data/MesoConnect_Atlas/LICENSE`, and `data/MesoConnect_Atlas/templates/README.md`. Do not replace the root notice with a single stock GitHub license.

## Scientific and implementation notes

- Atlas-constrained tractography is not an independent atlas validation because the atlas contributes to the tracking constraints.
- The 1,000-streamline, 10,000,000-attempt, cutoff-0.05 application example differs from the manuscript atlas-generation workflow.
- Applying the example to another pathway requires that pathway's seed, waypoint, target, exclusion, length, angle, and FOD-cutoff settings.
- Add the final manuscript journal citation and DOI when they become available.
