#!/usr/bin/env bash
set -euo pipefail

# Create a binary voxel mask from one tractogram and extract a whole-tract
# microstructure mean. This generic example works with FA, MD, NDI, ODI, or
# another scalar NIfTI map already aligned to the tractogram's native space.
#
# Usage:
#   ./whole_tract_microstructure.sh \
#     <TRACT.tck> <MICROSTRUCTURE_MAP.nii.gz> <OUTPUT_PREFIX>
#
# Example outputs for OUTPUT_PREFIX=/work/sub-01_left_vta_nac_ndi:
#   /work/sub-01_left_vta_nac_ndi_density.nii.gz
#   /work/sub-01_left_vta_nac_ndi_mask.nii.gz
#   /work/sub-01_left_vta_nac_ndi_masked.nii.gz
#   /work/sub-01_left_vta_nac_ndi_summary.tsv

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <TRACT.tck> <MICROSTRUCTURE_MAP.nii.gz> <OUTPUT_PREFIX>" >&2
  exit 2
fi

tract_file="$1"
metric_file="$2"
output_prefix="$3"

for command_name in tckmap fslmaths fslstats; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Required command not found: $command_name" >&2
    exit 1
  fi
done

[[ -f "$tract_file" ]] || { echo "Missing tractogram: $tract_file" >&2; exit 1; }
[[ -f "$metric_file" ]] || { echo "Missing metric map: $metric_file" >&2; exit 1; }

output_dir="$(dirname "$output_prefix")"
mkdir -p "$output_dir"

density_map="${output_prefix}_density.nii.gz"
tract_mask="${output_prefix}_mask.nii.gz"
masked_metric="${output_prefix}_masked.nii.gz"
summary_tsv="${output_prefix}_summary.tsv"

# Use the metric map as the template so the tract mask and scalar map have the
# same voxel grid. Inspect this registration before interpreting the mean.
tckmap "$tract_file" "$density_map" \
  -template "$metric_file" \
  -force

# Binarize streamline density: every traversed voxel contributes once to the
# whole-tract mask, independent of the number of streamlines through that voxel.
fslmaths "$density_map" -bin "$tract_mask"

# Retain the scalar values only inside the binary tract mask.
fslmaths "$metric_file" -mas "$tract_mask" "$masked_metric"

# -M reports the mean of nonzero scalar values within the mask. If zero is a
# biologically valid value for the selected metric, use `fslstats ... -m`
# instead and document that denominator choice.
mean_nonzero="$(fslstats "$metric_file" -k "$tract_mask" -M)"
read -r voxel_count volume_mm3 < <(fslstats "$tract_mask" -V)

printf 'tract\tmetric\tmean_nonzero\tvoxel_count\tvolume_mm3\n' > "$summary_tsv"
printf '%s\t%s\t%s\t%s\t%s\n' \
  "$tract_file" "$metric_file" "$mean_nonzero" "$voxel_count" "$volume_mm3" \
  >> "$summary_tsv"

echo "Wrote: $summary_tsv"
