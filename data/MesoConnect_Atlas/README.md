# MesoConnect Atlas

MesoConnect is a human 7T diffusion tractography atlas of seven bilateral mesolimbic pathways. The package contains probabilistic overlap maps and conservative 50% consensus maps in FSL MNI152 1 mm space.

The pathway names in this release match the accompanying manuscript:

1. Inferior VTA-NAc
2. Superior VTA-NAc
3. VTA-Amygdala
4. VTA-Anterior HPC
5. VTA-Posterior HPC
6. HPC-NAc-VP
7. VP-VTA

Abbreviations: HPC, hippocampus; NAc, nucleus accumbens; VP, ventral pallidum; VTA, ventral tegmental area.

## Package contents

```text
MesoConnect_Atlas/
|-- README.md
|-- mesoconnect_subject_counts.csv
|-- templates/
|   `-- MNI152_T1_1mm_brain.nii.gz
|-- inferior_vta_nac/
|-- superior_vta_nac/
|-- vta_amygdala/
|-- vta_anterior_hpc/
|-- vta_posterior_hpc/
|-- hpc_nac_vp/
`-- vp_vta/
```

Each pathway directory contains four NIfTI files: a left and right map for each of the two map types described below.

The `templates` directory contains the skull-stripped FSL MNI152 1 mm T1 reference used with the atlas. It is third-party material under the FSL license; see `templates/README.md` for provenance, checksum, and terms.

## File naming convention

Atlas files use this pattern:

```text
{hemisphere}_{pathway}_mni152_1mm_{map_type}.nii.gz
```

For example:

```text
inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_overlap_prop.nii.gz
inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_thr50.nii.gz
```

Naming fields:

- `hemisphere`: `left` or `right`
- `pathway`: manuscript-aligned pathway name written in lowercase snake case
- `mni152_1mm`: FSL MNI152 standard space with 1 mm isotropic voxels
- `map_type`: `overlap_prop` or `thr50`

## Map types

### Overlap proportion

Files ending in `_overlap_prop.nii.gz` are probabilistic atlas maps. Each voxel contains the proportion of contributing participants whose binarized tract map included that voxel. Values range from 0 to 1.

Use these maps to visualize spatial consistency or to create a custom participant-overlap threshold.

### 50% consensus map

Files ending in `_thr50.nii.gz` are binary maps. A voxel has value 1 when the tract was present in at least 50% of the contributing participants and value 0 otherwise.

The manuscript treats the 50% map as the conservative primary atlas for atlas-guided tractography. Registration uncertainty and interparticipant anatomical variation may still justify controlled dilation in a new dataset.

## Image space and dimensions

All atlas maps in this package have been checked for the following properties:

- Space: FSL MNI152 1 mm
- Matrix: 182 x 218 x 182 voxels
- Voxel size: 1 x 1 x 1 mm
- Orientation: right-to-left, posterior-to-anterior, inferior-to-superior
- Format: compressed NIfTI-1 (`.nii.gz`)

Use nearest-neighbor interpolation when transforming a binary `thr50` map. For a continuous `overlap_prop` map, choose interpolation based on the analysis and document that choice.

## Subject counts

[`mesoconnect_subject_counts.csv`](mesoconnect_subject_counts.csv) contains one row for every pathway and hemisphere. Its columns are:

- `pathway`: manuscript display name
- `hemisphere`: `left` or `right`
- `folder`: pathway directory
- `file_stem`: shared prefix for the two atlas files
- `n_subjects`: denominator used to calculate the corresponding overlap-proportion map

Counts are hemisphere-specific map denominators and therefore need not equal a bilateral complete-case sample reported in a manuscript analysis. The values in the CSV were verified directly from the relationship between the original voxelwise count maps and the released overlap-proportion maps before the count maps were removed. This verification corrected both VTA-Anterior HPC denominators to 167 and the right VP-VTA denominator to 171.

## Quick start

### View a probabilistic map with FSLeyes

```bash
fsleyes "$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz" \
  inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_overlap_prop.nii.gz \
  -dr 0 1
```

### View the 50% consensus map

```bash
fsleyes "$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz" \
  inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_thr50.nii.gz
```

### Create a custom 25% binary map

Create derivatives outside the release directories so the distributed atlas files remain unchanged.

```bash
mkdir -p derived
fslmaths \
  inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_overlap_prop.nii.gz \
  -thr 0.25 -bin \
  derived/left_inferior_vta_nac_mni152_1mm_thr25.nii.gz
```

### Inspect a NIfTI header

```bash
fslhd vta_amygdala/left_vta_amygdala_mni152_1mm_overlap_prop.nii.gz
```

Confirm the image space, transform direction, interpolation method, and left-right orientation before using an atlas map in participant-native space.

## Recommended reporting

When using MesoConnect, report:

- the atlas release or Git tag
- the pathway and hemisphere
- the atlas map type or participant-overlap threshold
- any dilation or erosion
- the registration software, transform, reference image, and interpolation method
- all seed, waypoint, target, and exclusion masks used for tractography
- tractography parameters and software versions
- visual quality-control procedures

Atlas-constrained tractography is not an independent anatomical validation because the atlas contributes directly to the tracking constraints.

## Citation

Please cite the MesoConnect manuscript:

Elliott BL, Mopuru R, Hoffman LJ, Leong JK, Volkow ND, Olson IR, and Murty VP. *Mapping Mesolimbic Dopamine Projections to Subcortical Circuits Underlying Adaptive Behavior: A Human 7T Diffusion Tractography Atlas.*

Add the final journal citation and DOI here when they become available.

## License and data-use terms

The repository uses terms scoped by material type:

- HCP-derived NIfTI maps and subject-count data: WU-Minn HCP Consortium Open Access Data Use Terms
- README and original documentation: Creative Commons Attribution 4.0 International
- Any original software or website code distributed with the atlas: MIT License
- FSL MNI152 template: FSL license for non-commercial use

See [`LICENSE`](LICENSE) for the complete scope notice and official links. Do not select a single stock license in GitHub's repository-creation form; retain the repository's scoped `LICENSE` file instead.
