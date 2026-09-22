# Figure placement plan

Manuscript Figures 1–3 are included because they directly explain atlas generation, pathway organization, and VTA–NAc topography. The remaining slots use editable workflow diagrams where participant-specific images are not available in the manuscript.

## Current figure inventory

| Figure | File | Page and location | Status and purpose |
|---|---|---|---|
| Manuscript Figure 2 | `website/assets/images/manuscript/figure-2-mesoconnect-atlas.png` | Home, after the three pathway groups | Included; introduces the full atlas and functional grouping scheme. |
| Manuscript Figure 1 | `website/assets/images/manuscript/figure-1-atlas-generation-workflow.jpg` | Home, after the workflow strip | Included; explains how participant tractograms became group atlas maps. |
| Manuscript Figure 3 | `website/assets/images/manuscript/figure-3-vta-nac-endpoint-topography.png` | Atlas documentation page, after pathway names | Included; shows endpoint separation of inferior and superior VTA–NAc pathways. |
| MNI corridor | `website/assets/images/figures/04-mni-corridor.svg` | Tutorial Step 3 | Editable diagram; replace with matched slices before and after the bilateral union. |
| Native-space overlay | `website/assets/images/figures/05-native-space-overlay.svg` | Tutorial Step 4 | Editable diagram; replace with axial, coronal, and sagittal alignment views. |
| Exclusion mask | `website/assets/images/figures/06-exclusion-mask.svg` | Tutorial Step 5 | Editable diagram; replace with corridor, inverse, and brain-masked exclusion views. |
| Tractography QC | `website/assets/images/figures/07-tractography-qc.svg` | Tutorial Step 8 | Editable diagram; replace with paired left/right streamlines plus seed, target, and corridor. |
| QA comparison | `website/assets/images/figures/08-qa-comparison.svg` | Resources troubleshooting | Editable diagram; replace with matched acceptable and failed registration examples. |
| Registration direction | `website/assets/images/figures/09-registration-direction.svg` | Atlas documentation, spatial-reference section | Included; explains moving versus fixed images, forward transform estimation, and inverse atlas transformation. |

## Optional future figures

- Manuscript Figure 4 for anterior versus posterior VTA–HPC endpoint territories.
- Manuscript Figure 5 for VTA endpoint topography across the five direct pathway classes.
- Manuscript Figures 6–7 only if the site gains a separate research-findings page; they are not required for the atlas tutorial.

## Replacing a workflow diagram

1. Use a non-identifiable example participant and remove local paths or interface chrome.
2. Export at a readable resolution; for raster images, target at least 1600 pixels across.
3. Keep slice coordinates, orientation, underlay, zoom, and display range matched across panels.
4. Replace the image path in the corresponding HTML page.
5. Update the image `alt` text, `width`, `height`, and caption together.
6. Run `npm run check`, then inspect the page at desktop and phone widths and at 200% zoom.

Use the same colors for corridor, seed, target, and exclusion masks throughout the site. Include orientation labels and enough surrounding anatomy to judge registration.
