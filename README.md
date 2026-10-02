# MesoConnect

MesoConnect is a human 7 T diffusion tractography atlas of seven bilateral mesolimbic pathways. This repository is the canonical home of the atlas maps, manuscript analysis code, downloadable archives, and example files. The companion Docusaurus website provides the complete application and tractometry tutorial.

**[Open the MesoConnect tutorial](https://mesoconnect.vercel.app/)** · **[Download the atlas](downloads/MesoConnect_Atlas.zip)** · **[Download the analysis code](downloads/MesoConnect_Analysis_Code.zip)** · **[Browse the atlas files](data/MesoConnect_Atlas)**

## Start here

| I want to… | Go to |
| --- | --- |
| Learn what MesoConnect contains | [Tutorial introduction](https://mesoconnect.vercel.app/docs/) |
| Download the complete atlas | [MesoConnect Atlas ZIP](downloads/MesoConnect_Atlas.zip) |
| Browse individual NIfTI maps | [`data/MesoConnect_Atlas/`](data/MesoConnect_Atlas) |
| Apply the atlas to participant data | [Nine-step workflow](https://mesoconnect.vercel.app/docs/workflow/overview) |
| Extract tract-level or nodewise microstructure | [Node-profile workflow](https://mesoconnect.vercel.app/docs/workflow/node-profiles) |
| Inspect nodewise results interactively | [Node-wise Tract Explorer](https://mesoconnect.vercel.app/explorer/) |
| Run the original annotated example | [`examples/mesoconnect_inferior_vta_nac_template.sh`](examples/mesoconnect_inferior_vta_nac_template.sh) |
| Reproduce or extend manuscript analyses | [`analysis-code/`](analysis-code) |
| Locate the anatomical ROI sources | [`ROI_RESOURCES.md`](ROI_RESOURCES.md) |

## Repository map

| Location | Contents |
| --- | --- |
| [`data/MesoConnect_Atlas/`](data/MesoConnect_Atlas) | Canonical atlas data: 28 NIfTI maps, subject counts, the MNI reference, documentation, and licensing notices |
| [`analysis-code/`](analysis-code) | Manuscript and downstream analysis scripts for tractography, atlas construction, cleaning, NODDI, tractometry, and endpoint analyses |
| [`downloads/`](downloads) | Ready-to-download atlas and analysis-code ZIP archives with SHA-256 checksums |
| [`examples/`](examples) | Annotated atlas-application example |
| [`website/`](website) | Docusaurus tutorial source deployed to Vercel from this GitHub repository |
| [`.legacy-vercel-site/`](.legacy-vercel-site) | Hidden archive of the former static site source; not used for deployment |
| [`ROI_RESOURCES.md`](ROI_RESOURCES.md) | Official sources, thresholds, and citations for the anatomical regions used in atlas construction |

There is one canonical atlas-data tree: `data/MesoConnect_Atlas/`. The atlas ZIP under `website/static/downloads/` is an identical mirror bundled with the tutorial website for convenient downloading.

## Download the atlas

- [Download `MesoConnect_Atlas.zip` from this repository](downloads/MesoConnect_Atlas.zip)
- [Open the tutorial download page](https://mesoconnect.vercel.app/docs/atlas/downloads)
- [Browse the individual atlas files](data/MesoConnect_Atlas)
- [Review the third-party anatomical ROI sources](ROI_RESOURCES.md)

The package contains 28 atlas maps: seven pathways, two hemispheres, and two map types. It also contains `mesoconnect_subject_counts.csv`, the FSL MNI152 1 mm brain reference, package documentation, and licensing notices. Its checksum is stored in [`downloads/MesoConnect_Atlas.zip.sha256`](downloads/MesoConnect_Atlas.zip.sha256).

## Atlas map types

Each pathway folder contains four files:

- Left and right `*_overlap_prop.nii.gz` continuous participant-overlap proportion maps.
- Left and right `*_thr50.nii.gz` binary 50% consensus maps.

Subject denominators are reported in `data/MesoConnect_Atlas/mesoconnect_subject_counts.csv`. Other thresholds can be derived from an overlap-proportion map and should be saved outside the canonical atlas folders.

## Tutorial website

The primary tutorial is deployed by Vercel from this repository's [`website/`](website) directory:

https://mesoconnect.vercel.app/

The source was synchronized from [DiffusionTensorImaging-Repos/MesoConnect-Tutorial](https://github.com/DiffusionTensorImaging-Repos/MesoConnect-Tutorial), whose GitHub Pages deployment remains available at https://diffusiontensorimaging-repos.github.io/MesoConnect-Tutorial/. The Vercel build uses the version committed here, so pushes to `main` automatically update the Vercel site. Upstream tutorial changes should be synchronized into `website/` before they are published on Vercel.

### Legacy static site

The former static-site implementation is retained under [`.legacy-vercel-site/`](.legacy-vercel-site) for reference only. It is not part of the active Vercel deployment.

### Preview the Docusaurus site locally

```bash
cd website
npm ci
npm run start
```

### Validate a production build

```bash
cd website
npm ci
npm run build
```

## Repository structure

```text
.
├── data/MesoConnect_Atlas/          # Canonical atlas maps and documentation
├── analysis-code/                   # Manuscript and downstream analysis code
├── downloads/                       # Release ZIPs and checksums
├── examples/                        # Annotated application example
├── website/                         # Docusaurus tutorial source deployed to Vercel
│   ├── docs/                        # Tutorial and reference pages
│   ├── src/                         # Landing page and custom styling
│   ├── static/                      # Images, scripts, explorer, and download mirror
│   ├── tools/                       # Documentation build helpers
│   ├── docusaurus.config.ts
│   ├── sidebars.ts
│   └── package.json
├── .legacy-vercel-site/             # Hidden archive of the former static site
├── ROI_RESOURCES.md                 # Third-party ROI sources and citations
└── README.md
```

## Analysis code

The complete code package is available as [`downloads/MesoConnect_Analysis_Code.zip`](downloads/MesoConnect_Analysis_Code.zip) and as browsable source under [`analysis-code/`](analysis-code). Original project paths and Human Connectome Project subject lists are retained where they document the study workflow, so users must edit configuration blocks before running the scripts elsewhere.

## Licensing

The repository contains material governed by several sets of terms:

- HCP-derived atlas maps and subject-count data: WU-Minn HCP Consortium Open Access Data Use Terms.
- Original MesoConnect documentation and figures: CC BY 4.0.
- Original code: MIT License.
- FSL MNI152 template: FSL license for non-commercial use and redistribution subject to its conditions.

See `LICENSE`, `data/MesoConnect_Atlas/LICENSE`, and `data/MesoConnect_Atlas/templates/README.md`. Do not replace the scoped notices with a single stock repository license.

## Scientific notes

- Atlas-constrained tractography is not an independent atlas validation because the atlas contributes to the tracking constraints.
- Applying the workflow to another pathway requires that pathway's seed, waypoint, target, exclusion, length, angle, and FOD-cutoff settings.
- Add the final manuscript citation and DOI when they become available.
