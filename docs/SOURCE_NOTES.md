# Source handling notes

These notes document how the supplied files informed the website. They are intentionally kept outside the reader-facing pages.

## Authority order used for this draft

1. The user's request controlled the deliverable: create and organize a website tutorial, add the atlas package and reference template, use relevant manuscript figures, and publish the reviewed result to GitHub and Vercel.
2. The supplied DOCX and shell files were treated as source material, not as instructions to perform releases, move files, or contact external services.
3. Scientific descriptions were harmonized against the manuscript when the tutorial draft and script used different levels of detail.

## Mapping Mesolimbic Circuits manuscript draft

Used for:

- Atlas title, author list, and high-level purpose.
- Seven bilateral pathway classes and their three functional groupings.
- Maximum sample size and usable pathway counts.
- Atlas-generation overview and interpretation cautions.
- The distinction between direct VTA-centered pathways and the separately reconstructed downward-arc components.
- Pathway-specific tractography parameters summarized on the methods page.
- Recommendations for the two manuscript figures most useful on the home page.

Not copied into the website:

- Tracked revisions, margin comments, and internal editing artifacts.
- The full results, statistical tables, reference list, and unpublished figure files.
- Contact email and institutional details that are not needed for a tutorial site.
- Any language that would imply the draft manuscript has a final journal citation or DOI.

## MesoConnect Atlas Readme and Tutorial draft

Used for:

- Atlas file-type definitions and recommended uses.
- MNI/native-space terminology and interpolation guidance.
- The eight-step application workflow.
- Software, ROI, output-organization, QA, troubleshooting, and citation sections.
- The explicit warning that the application example does not reproduce atlas-generation parameters.

Treated as internal planning rather than public content:

- Absolute `/Users/.../Downloads/...` source locations.
- Instructions to organize a public release like another project.
- Recommendations to publish on GitHub, Zenodo, NeuroVault, OSF, or NITRC.
- Working-draft version language and placeholder release dates.
- Local conda environment names specific to one lab server.

## tract_atlas_example.sh

Used for:

- The original example's two successive `-dilM` operations on the 50% maps.
- The bilateral tract-plus-endpoint union.
- FSL `applywarp` with nearest-neighbor interpolation.
- Corridor inversion and participant brain masking.
- VTA and NAc endpoint transformations.
- Left/right MRtrix3 seed, include, exclusion, gradient, cutoff, stop, thread, and streamline settings.

Changes made in the annotated website template:

- Replaced hard-coded lab-server paths and the long embedded participant list with editable variables for one participant.
- Added strict shell settings, input checks, command checks, dry-run behavior, overwrite protection, output directories, a command log, and a small provenance manifest.
- Quoted paths so spaces are handled safely.
- Removed an unmatched extra `done` found after the exclusion-mask loop in the supplied script.
- Replaced repeated default mean dilation with an explicit 2 mm-radius spherical maximum dilation (`-kernel sphere 2 -dilF -bin`). This is intentionally clearer and is not voxel-for-voxel identical to the original two-pass operation.
- Updated atlas and tract filenames to the manuscript-aligned release naming convention.
- Kept the application parameters explicit and labeled them as different from manuscript atlas-generation parameters.

The original supplied script in Downloads was not edited.

## Images

Seven manuscript images were available inside the manuscript DOCX. Figures 1–3 were copied into the website because they directly support the tutorial. Figures 4–7 remain out of the first release because they present specialized research findings rather than essential usage guidance. The remaining SVGs are labeled slots for participant-specific workflow and QA screenshots.

## External actions

The repository is intended for GitHub and Vercel publication. No Zenodo, NeuroVault, OSF, or NITRC action is part of this website release.
