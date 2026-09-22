# MesoConnect analysis code

This directory contains the cleaned, study-specific scripts used to generate or analyze MesoConnect tractography products. The scripts are published as transparent reference code, not as a turnkey pipeline. Read each configuration block, replace the original project paths and subject lists, confirm software versions, and test on one participant before batch execution.

The older `atlas_nifti_files` directory supplied with the scripts is intentionally excluded. The current atlas has one canonical location at [`data/MesoConnect_Atlas`](../data/MesoConnect_Atlas) and contains only `overlap_prop` and `thr50` maps.

## Start with these workflows

| Goal | Script | Important behavior |
| --- | --- | --- |
| Fit AMICO-NODDI | [`noddi/NODDI.py`](noddi/NODDI.py) | Saves tissue-fraction-modulated NDI and ODI maps and an FWF map. |
| Extract nodewise NODDI profiles | [`noddi/nodewise_noddi.py`](noddi/nodewise_noddi.py) | Orients streamlines to a centroid, samples 100 nodes with Gaussian weights, and writes tract CSVs and plots. |
| Clean streamline bundles | [`tracking_and_atlas/pyafq_tract_cleaning.py`](tracking_and_atlas/pyafq_tract_cleaning.py) | Uses pyAFQ `clean_bundle`; edit roots, tracts, subjects, and thresholds first. |
| Extract a whole-tract scalar mean | [`microstructure/whole_tract_microstructure.sh`](microstructure/whole_tract_microstructure.sh) | Creates a binary tract mask and reports a scalar-map mean with FSL. |
| Generate tract and endpoint maps | [`tracking_and_atlas/tckmaps.sh`](tracking_and_atlas/tckmaps.sh) | Uses cleaned streamlines and a participant anatomical template. |
| Generate tract statistics | [`tracking_and_atlas/tckstats.sh`](tracking_and_atlas/tckstats.sh) | Writes one CSV per tract from MRtrix3 `tckstats`. |
| Compute endpoint centers of mass | [`center_of_mass_analyses/`](center_of_mass_analyses) | Creates endpoint maps and transforms weighted centers to MNI coordinates. |

## Full inventory

### `tracking_and_atlas/`

- `prepare_rois.sh`: skull stripping, MNI-to-native registration, ROI transformation, and ROI cleanup.
- `tractography_commands.sh`: manuscript tractography commands and pathway-specific anatomical constraints.
- `pyafq_tract_cleaning.py`: pyAFQ streamline cleaning.
- `quickbundles.py`: DIPY QuickBundles clustering for specified pathway families.
- `tckmaps.sh`: whole-tract and endpoint-density voxel maps.
- `tckstats.sh`: tract-length summary tables.
- `warp_to_mni_tract_tckmap.sh`: binary native tract maps transformed to the 1 mm MNI grid.
- `build_tract_atlas.sh`: overlap-proportion and 50% consensus atlas construction. Overlap counts are temporary working files and are not retained.

### `noddi/`

- `NODDI.py`: AMICO-NODDI model fitting with `doSaveModulatedMaps=True`.
- `nodewise_noddi.py`: 100-node NDI, ODI, and FWF profiles. The published copy corrects a missing comma between two tract names in the supplied script.

### `center_of_mass_analyses/`

- `accumbens_endpoint_com.py`: weighted mean and weighted median accumbens endpoint coordinates.
- `vta_endpoint_com.py`: weighted mean VTA endpoint coordinates.

### `hpc_endpoints/`

- `freesurfer.sh`: FreeSurfer reconstruction and hippocampal-subfield segmentation.
- `extract_hpc_subfields.sh`: subfield-label extraction and reorientation.

### `inf_sup_exclusion_rois/`

Two NIfTI exclusion masks used when separating inferior and superior VTA–NAc reconstructions. Confirm their grid and anatomical placement before use.

## NODDI tissue weighting

The NODDI script saves modulated NDI and ODI maps so tissue metrics can be analyzed with tissue-fraction weighting rather than allowing low-tissue-fraction voxels to contribute equally. This follows the rationale described by Parker et al.:

> Parker CS, Veale T, Bocchetta M, et al. Not all voxels are created equal: Reducing estimation bias in regional NODDI metrics using tissue-weighted means. *NeuroImage*. 2021;245:118749. https://doi.org/10.1016/j.neuroimage.2021.118749

The modulated map alone is the numerator contribution. For a regional tissue-weighted mean, sum the modulated tissue metric inside the tract or ROI and divide by the corresponding summed tissue fraction. Do not describe a simple arithmetic mean of the modulated map as a tissue-weighted mean.

## Dependencies

The scripts collectively use MRtrix3, FSL, ANTs, FreeSurfer, Python 3, AMICO, DIPY, pyAFQ, nibabel, NumPy, pandas, and matplotlib. `requirements.txt` lists Python package names but intentionally does not invent versions that were not recorded in the supplied scripts. For reproducibility, add the exact versions used in the final analysis environment.

## Safety and quality control

- These scripts contain original study paths and HCP subject lists; edit the configuration blocks for a new project.
- Review every transform direction, interpolation mode, image grid, and left/right label.
- Run shell syntax checks and Python compilation before execution.
- Perform visual QC on masks, tractograms, tract maps, and nodewise orientation.
- Preserve command logs, software versions, exclusions, missing-data decisions, and parameter changes.
- The atlas can be used as a template with MRtrix3, DSI Studio, FSL, DIPY, pyAFQ, or another validated tractography workflow; the public MRtrix3 example is not a software restriction.

See the [microstructure tutorial](https://mesoconnect.vercel.app/microstructure/) for guided whole-tract and nodewise workflows.
