# MesoConnect

MesoConnect is a human 7T diffusion tractography atlas of seven bilateral mesolimbic pathways. This repository contains the public atlas package, a static tutorial website, an annotated Inferior VTA–NAc application script, selected manuscript figures, and the FSL MNI152 1 mm brain reference used with the atlas.

**[Open the tutorial website](https://mesoconnect.vercel.app)** · **[Download the complete atlas](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip)** · **[Download the analysis code](https://mesoconnect.vercel.app/downloads/MesoConnect_Analysis_Code.zip)** · **[Browse the atlas files](data/MesoConnect_Atlas)**

## Start here

| I want to… | Go to |
| --- | --- |
| Learn what the atlas contains | [Live atlas overview](https://mesoconnect.vercel.app) |
| Download everything in one file | [MesoConnect_Atlas.zip](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip) |
| Browse individual NIfTI maps | [`data/MesoConnect_Atlas/`](data/MesoConnect_Atlas) |
| Follow the application workflow | [Worked tutorial](https://mesoconnect.vercel.app/tutorial/) |
| Extract whole-tract or nodewise microstructure | [Microstructure tutorial](https://mesoconnect.vercel.app/microstructure/) |
| Run an annotated example | [`examples/mesoconnect_inferior_vta_nac_template.sh`](examples/mesoconnect_inferior_vta_nac_template.sh) |
| Reproduce or extend manuscript analyses | [`analysis-code/`](analysis-code) |
| Download the anatomical ROIs used by the manuscript | [`ROI_RESOURCES.md`](ROI_RESOURCES.md) |
| Edit the website | [`website/docs/EDITING_GUIDE.md`](website/docs/EDITING_GUIDE.md) |

## Repository map

| Folder | What it contains |
| --- | --- |
| [`data/MesoConnect_Atlas/`](data/MesoConnect_Atlas) | **The actual atlas:** NIfTI maps, subject counts, MNI reference, and atlas documentation |
| [`analysis-code/`](analysis-code) | Manuscript and downstream analysis scripts, including tractography, atlas construction, cleaning, NODDI, nodewise sampling, and endpoint analyses |
| [`downloads/`](downloads) | Ready-to-download ZIP archives and SHA-256 checksums |
| [`examples/`](examples) | Annotated, runnable atlas-application example |
| [`website/`](website) | **Website source files only:** pages, styles, scripts, images, and maintainer documentation |

There is one atlas-data location: `data/MesoConnect_Atlas/`. The folder `website/pages/atlas-documentation/` is only the source for a webpage that explains the atlas files.

## Download the atlas

- [Download the complete MesoConnect Atlas ZIP](https://mesoconnect.vercel.app/downloads/MesoConnect_Atlas.zip)
- [Browse the atlas package on GitHub](data/MesoConnect_Atlas)
- [Review atlas filenames and map types](https://mesoconnect.vercel.app/atlas-documentation/)
- [Download the third-party anatomical ROIs from their original providers](ROI_RESOURCES.md)

The ZIP contains all 28 atlas maps, `mesoconnect_subject_counts.csv`, the FSL MNI152 1 mm brain reference, and the package documentation and licensing notices. Its SHA-256 checksum is stored in `downloads/MesoConnect_Atlas.zip.sha256`.

## What is included

- A responsive overview of the seven pathways and three proposed functional groupings.
- Atlas documentation covering MNI space, `overlap_prop` and `thr50` maps, filenames, thresholds, and interpolation.
- The complete atlas package under `data/MesoConnect_Atlas`, including 28 NIfTI maps and hemisphere-specific subject counts.
- An eight-step Inferior VTA–NAc corridor tutorial with copyable commands.
- Three optional steps for pyAFQ cleaning, AMICO-NODDI, and whole-tract or nodewise microstructure extraction.
- Study scripts for ROI preparation, tractography, cleaning, tract maps, atlas construction, NODDI, endpoint analyses, and hippocampal subfields.
- A well-annotated single-participant shell template with dry-run checks and overwrite protection.
- Manuscript Figures 1–3 in the sections where they explain the atlas most clearly.
- Editable workflow diagrams marking recommended locations for future participant-specific corridor and quality-control screenshots.
- Editing, figure-placement, source-handling, licensing, and provenance notes.

## Preview locally

From the repository root:

```bash
npm run dev
```

Then open `http://localhost:4173`. The site uses plain HTML, CSS, and JavaScript. The command assembles a generated preview in `dist/`; edit the source under `website/`, not `dist/`.

## Validate before publishing edits

```bash
npm run check
```

The checker validates local links and assets, duplicate HTML IDs, image alternative text, and all published shell and Python syntax.

## Repository structure

```text
.
├── data/MesoConnect_Atlas/
│   ├── README.md                      # Atlas package documentation
│   ├── LICENSE                        # Material-specific data and software terms
│   ├── mesoconnect_subject_counts.csv
│   ├── templates/                     # FSL MNI152 1 mm brain + provenance
│   └── <seven pathway folders>/       # Left/right overlap_prop and thr50 maps
├── downloads/
│   ├── MesoConnect_Atlas.zip            # Complete downloadable atlas package
│   ├── MesoConnect_Atlas.zip.sha256     # Atlas archive integrity checksum
│   ├── MesoConnect_Analysis_Code.zip    # Complete downloadable analysis code
│   └── MesoConnect_Analysis_Code.zip.sha256
├── examples/
│   └── mesoconnect_inferior_vta_nac_template.sh
├── analysis-code/
│   ├── README.md                       # Script inventory, dependencies, and cautions
│   ├── tracking_and_atlas/             # Tracking, cleaning, maps, atlas construction
│   ├── noddi/                          # AMICO-NODDI and nodewise profiles
│   ├── microstructure/                 # Generic whole-tract scalar extraction
│   ├── center_of_mass_analyses/        # Endpoint-coordinate analyses
│   └── hpc_endpoints/                  # FreeSurfer hippocampal-subfield workflows
├── ROI_RESOURCES.md                   # Official ROI downloads and citations
├── website/                           # Website source only; no atlas data
│   ├── README.md                      # Website-source map
│   ├── index.html                     # Landing page source
│   ├── pages/
│   │   ├── atlas-documentation/       # Atlas-file explanation page
│   │   ├── tutorial/                  # Worked application page
│   │   ├── microstructure/            # Optional downstream workflows
│   │   ├── methods/                   # Manuscript methods page
│   │   └── resources/                 # ROI links, QA, and troubleshooting
│   ├── assets/                        # Shared styles, scripts, and images
│   ├── docs/                          # Website editing and figure notes
│   └── scripts/                       # Site build and validation scripts
├── package.json
└── vercel.json
```

## Editing the website

### Text and navigation

Each page is an ordinary `index.html` file. Search for the visible heading you want to change. The header and footer are repeated on every page so navigation works without JavaScript; update every HTML page when adding or renaming a navigation item.

### Colors and typography

Edit the design variables at the top of `website/assets/css/styles.css`. `--font-sans` begins with Helvetica Neue and Helvetica, with Arial and system sans-serif fallbacks. Code uses a separate monospace stack.

### Figures

Manuscript Figures 1–3 live in `website/assets/images/manuscript`. The remaining tutorial and QA figure slots use editable SVGs under `website/assets/images/figures`. When replacing a figure, update its image path, alternative text, dimensions, and caption together. See `website/docs/FIGURE_PLAN.md` for placement and screenshot guidance.

### Tutorial commands

Keep these files synchronized:

- `website/pages/tutorial/index.html` for reader-facing commands.
- `examples/mesoconnect_inferior_vta_nac_template.sh` for the runnable workflow.
- `website/pages/microstructure/index.html` for optional downstream guidance.
- `analysis-code/` for the downloadable study and extraction scripts.

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

## Analysis code

The complete code package is available as [`downloads/MesoConnect_Analysis_Code.zip`](downloads/MesoConnect_Analysis_Code.zip) and as browsable source under [`analysis-code/`](analysis-code). The original project paths and HCP subject lists are retained where they document the study workflow, so users must edit configuration blocks before running the scripts elsewhere. The older atlas copy supplied alongside the scripts was not imported; the canonical atlas remains under `data/MesoConnect_Atlas/` with only `overlap_prop` and `thr50` maps.

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
