#!/usr/bin/env bash
set -euo pipefail

BASE="/zpool/olsonlab/active_drive/ranesh/hcp_7t"
OUTDIR="${BASE}/GroupAverage/all_tracts"
mkdir -p "$OUTDIR"

# Overlap counts are needed only as an intermediate calculation. Keep them in a
# temporary working directory so the published atlas contains overlap
# proportions and 50% consensus maps only.
WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/mesoconnect-atlas.XXXXXX")"
trap 'rm -rf "$WORKDIR"' EXIT

CSV="${OUTDIR}/GroupAverage_subject_counts.csv"
echo "tract,n_subjects" > "$CSV"

TRACTS=(
  l_hipp_l_accumbens
  r_hipp_r_accumbens
  l_hipp_l_vp
  r_hipp_r_vp
  l_vta_l_anterior_hipp
  l_vta_l_posterior_hipp
  r_vta_r_anterior_hipp
  r_vta_r_posterior_hipp
  l_vta_l_amygdala
  r_vta_r_amygdala
  l_vp_l_vta
  r_vp_r_vta
  inferior_l_vta_l_accumbens
  inferior_r_vta_r_accumbens
  superior_l_vta_l_accumbens
  superior_r_vta_r_accumbens
)

is_numeric_dirname() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

for t in "${TRACTS[@]}"; do
  echo
  echo "=== ${t} ==="

  files=()

  for subjpath in "${BASE}"/*/; do
    [[ -d "$subjpath" ]] || continue

    s="$(basename "${subjpath%/}")"
    is_numeric_dirname "$s" || continue

    f="${BASE}/${s}/tckmap/${t}/${t}_1mm_MNI.nii.gz"

    if [[ -f "$f" ]]; then
      files+=("$f")
    fi
  done

  n="${#files[@]}"
  echo "Found ${n} files"
  echo "${t},${n}" >> "$CSV"

  if (( n == 0 )); then
    echo "Skipping ${t}: no inputs"
    continue
  fi

  out_count="${WORKDIR}/${t}_GroupOverlapCount.nii.gz"
  out_prop="${OUTDIR}/${t}_GroupMean_OverlapProp.nii.gz"
  out_50="${OUTDIR}/${t}_GroupMean_thr50.nii.gz"

  cmd=(fslmaths "${files[0]}")

  for ((i=1; i<n; i++)); do
    cmd+=(-add "${files[i]}")
  done

  cmd+=("$out_count")

  echo "Writing overlap count"
  "${cmd[@]}"

  echo "Writing overlap proportion"
  fslmaths "$out_count" -div "$n" "$out_prop"

  echo "Writing 50% threshold map"
  fslmaths "$out_prop" -thr 0.5 -bin "$out_50"

  echo "Done ${t}"
done

echo
echo "All done."
echo "Outputs written to: $OUTDIR"
echo "Counts CSV: $CSV"
