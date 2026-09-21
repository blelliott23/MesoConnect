#!/usr/bin/env bash

# MesoConnect Inferior VTA-NAc atlas-guided tractography template
# ============================================================================
# Purpose
#   Apply the bilateral 50% MesoConnect Inferior VTA-NAc atlas as a 2 mm-
#   dilated corridor for one participant's native-space MRtrix3 tractography.
#
# Important scientific distinction
#   This script mirrors the supplied APPLICATION example:
#     - 1,000 accepted streamlines
#     - up to 10,000,000 seeding attempts
#     - FOD cutoff 0.05
#   It does NOT reproduce the manuscript's atlas-generation settings, which used
#   pathway-specific parameters, 2,500 accepted streamlines, and up to 25 million
#   seeding attempts (Inferior VTA-NAc manuscript FOD cutoff: 0.03).
#
# Safety and editing model
#   1. Edit only the CONFIGURATION section first.
#   2. The default is DRY_RUN=1, which prints commands but does not run them.
#   3. Set DRY_RUN=0 only after checking every printed path and overlaying inputs.
#   4. Existing outputs stop the script unless ALLOW_OVERWRITE=1 is explicit.
#
# Example invocation after editing paths
#   DRY_RUN=1 bash mesoconnect_inferior_vta_nac_template.sh
#   DRY_RUN=0 bash mesoconnect_inferior_vta_nac_template.sh

set -Eeuo pipefail
IFS=$'\n\t'

# ---------------------------------------------------------------------------
# CONFIGURATION: replace every /REPLACE_ME/... value with a real absolute path.
# Environment variables can override these defaults without editing the file.
# ---------------------------------------------------------------------------

PARTICIPANT_ID="${PARTICIPANT_ID:-sub-1006}"

# Group-space atlas and endpoint inputs (FSL MNI152 1 mm space).
LEFT_ATLAS_50="${LEFT_ATLAS_50:-/REPLACE_ME/MesoConnect/data/MesoConnect_Atlas/inferior_vta_nac/left_inferior_vta_nac_mni152_1mm_thr50.nii.gz}"
RIGHT_ATLAS_50="${RIGHT_ATLAS_50:-/REPLACE_ME/MesoConnect/data/MesoConnect_Atlas/inferior_vta_nac/right_inferior_vta_nac_mni152_1mm_thr50.nii.gz}"
LEFT_VTA_ROI="${LEFT_VTA_ROI:-/REPLACE_ME/MesoConnect/roi_maps/left_vta.nii.gz}"
RIGHT_VTA_ROI="${RIGHT_VTA_ROI:-/REPLACE_ME/MesoConnect/roi_maps/right_vta.nii.gz}"
LEFT_NAC_ROI="${LEFT_NAC_ROI:-/REPLACE_ME/MesoConnect/roi_maps/left_accumbens.nii.gz}"
RIGHT_NAC_ROI="${RIGHT_NAC_ROI:-/REPLACE_ME/MesoConnect/roi_maps/right_accumbens.nii.gz}"

# Participant-native diffusion inputs.
NATIVE_BRAIN_MASK="${NATIVE_BRAIN_MASK:-/REPLACE_ME/project/sourcedata/sub-1006/nodif_brain_mask.nii.gz}"
MNI_TO_NATIVE_WARP="${MNI_TO_NATIVE_WARP:-/REPLACE_ME/project/derivatives/sub-1006/xfm/standard2acpc_dc.nii.gz}"
WHITE_MATTER_FOD="${WHITE_MATTER_FOD:-/REPLACE_ME/project/derivatives/sub-1006/dwi/wm_fod_norm.mif}"
BVEC_FILE="${BVEC_FILE:-/REPLACE_ME/project/sourcedata/sub-1006/dwi/bvecs}"
BVAL_FILE="${BVAL_FILE:-/REPLACE_ME/project/sourcedata/sub-1006/dwi/bvals}"
LEFT_HEMI_MASK="${LEFT_HEMI_MASK:-/REPLACE_ME/project/derivatives/sub-1006/roi/T1_MNI_Lhemi_bin.nii.gz}"
RIGHT_HEMI_MASK="${RIGHT_HEMI_MASK:-/REPLACE_ME/project/derivatives/sub-1006/roi/T1_MNI_Rhemi_bin.nii.gz}"

# Writable output locations.
ATLAS_OUTPUT_DIR="${ATLAS_OUTPUT_DIR:-/REPLACE_ME/project/derivatives/mesoconnect/group_derived}"
SUBJECT_OUTPUT_DIR="${SUBJECT_OUTPUT_DIR:-/REPLACE_ME/project/derivatives/mesoconnect/sub-1006}"

# Runtime controls. Keep DRY_RUN=1 for the first pass.
DRY_RUN="${DRY_RUN:-1}"
ALLOW_OVERWRITE="${ALLOW_OVERWRITE:-0}"
NTHREADS="${NTHREADS:-16}"

# Application-example tracking settings from the supplied script.
SELECT_STREAMLINES="${SELECT_STREAMLINES:-1000}"
MAX_SEED_ATTEMPTS="${MAX_SEED_ATTEMPTS:-10000000}"
FOD_CUTOFF="${FOD_CUTOFF:-0.05}"

# ---------------------------------------------------------------------------
# DERIVED OUTPUTS: normally do not edit below this line.
# ---------------------------------------------------------------------------

ROI_DIR="${SUBJECT_OUTPUT_DIR}/roi"
TRACT_DIR="${SUBJECT_OUTPUT_DIR}/tractography"
COMMAND_DIR="${SUBJECT_OUTPUT_DIR}/commands"

LEFT_ATLAS_DIL2MM="${ATLAS_OUTPUT_DIR}/left_inferior_vta_nac_mni152_1mm_thr50_dil2mm.nii.gz"
RIGHT_ATLAS_DIL2MM="${ATLAS_OUTPUT_DIR}/right_inferior_vta_nac_mni152_1mm_thr50_dil2mm.nii.gz"
MNI_CORRIDOR="${ATLAS_OUTPUT_DIR}/inferior_vta_accumbens_inclusion_corridor.nii.gz"

NATIVE_CORRIDOR="${ROI_DIR}/inferior_vta_accumbens_inclusion_corridor.nii.gz"
INVERSE_CORRIDOR="${ROI_DIR}/inverse_inferior_vta_accumbens_inclusion_corridor.nii.gz"
EXCLUSION_CORRIDOR="${ROI_DIR}/inferior_vta_accumbens_exclusion_corridor.nii.gz"

NATIVE_LEFT_VTA="${ROI_DIR}/left_vta.nii.gz"
NATIVE_RIGHT_VTA="${ROI_DIR}/right_vta.nii.gz"
NATIVE_LEFT_NAC="${ROI_DIR}/left_accumbens.nii.gz"
NATIVE_RIGHT_NAC="${ROI_DIR}/right_accumbens.nii.gz"

LEFT_TCK="${TRACT_DIR}/left_inferior_vta_nac.tck"
RIGHT_TCK="${TRACT_DIR}/right_inferior_vta_nac.tck"
COMMAND_LOG="${COMMAND_DIR}/${PARTICIPANT_ID}_tractography_commands.txt"
MANIFEST="${SUBJECT_OUTPUT_DIR}/manifest.tsv"

INPUTS=(
  "$LEFT_ATLAS_50" "$RIGHT_ATLAS_50"
  "$LEFT_VTA_ROI" "$RIGHT_VTA_ROI"
  "$LEFT_NAC_ROI" "$RIGHT_NAC_ROI"
  "$NATIVE_BRAIN_MASK" "$MNI_TO_NATIVE_WARP"
  "$WHITE_MATTER_FOD" "$BVEC_FILE" "$BVAL_FILE"
  "$LEFT_HEMI_MASK" "$RIGHT_HEMI_MASK"
)

OUTPUTS=(
  "$LEFT_ATLAS_DIL2MM" "$RIGHT_ATLAS_DIL2MM" "$MNI_CORRIDOR"
  "$NATIVE_CORRIDOR" "$INVERSE_CORRIDOR" "$EXCLUSION_CORRIDOR"
  "$NATIVE_LEFT_VTA" "$NATIVE_RIGHT_VTA" "$NATIVE_LEFT_NAC" "$NATIVE_RIGHT_NAC"
  "$LEFT_TCK" "$RIGHT_TCK"
)

# Print one command in a shell-reusable form. If DRY_RUN=0, run it as well.
run() {
  printf '  '
  printf '%q ' "$@"
  printf '\n'
  if [[ "$DRY_RUN" == "0" ]]; then
    "$@"
  fi
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

require_value() {
  local label="$1"
  local value="$2"
  [[ -n "$value" ]] || fail "$label is empty."
  [[ "$value" != *REPLACE_ME* ]] || fail "$label still contains REPLACE_ME: $value"
}

require_file() {
  local label="$1"
  local value="$2"
  require_value "$label" "$value"
  [[ -f "$value" ]] || fail "$label does not exist as a file: $value"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command is not available: $1"
}

printf 'MesoConnect Inferior VTA-NAc application example\n'
printf 'Participant: %s\n' "$PARTICIPANT_ID"
printf 'Dry run: %s\n' "$DRY_RUN"

require_value "ATLAS_OUTPUT_DIR" "$ATLAS_OUTPUT_DIR"
require_value "SUBJECT_OUTPUT_DIR" "$SUBJECT_OUTPUT_DIR"
require_file "LEFT_ATLAS_50" "$LEFT_ATLAS_50"
require_file "RIGHT_ATLAS_50" "$RIGHT_ATLAS_50"
require_file "LEFT_VTA_ROI" "$LEFT_VTA_ROI"
require_file "RIGHT_VTA_ROI" "$RIGHT_VTA_ROI"
require_file "LEFT_NAC_ROI" "$LEFT_NAC_ROI"
require_file "RIGHT_NAC_ROI" "$RIGHT_NAC_ROI"
require_file "NATIVE_BRAIN_MASK" "$NATIVE_BRAIN_MASK"
require_file "MNI_TO_NATIVE_WARP" "$MNI_TO_NATIVE_WARP"
require_file "WHITE_MATTER_FOD" "$WHITE_MATTER_FOD"
require_file "BVEC_FILE" "$BVEC_FILE"
require_file "BVAL_FILE" "$BVAL_FILE"
require_file "LEFT_HEMI_MASK" "$LEFT_HEMI_MASK"
require_file "RIGHT_HEMI_MASK" "$RIGHT_HEMI_MASK"

if [[ "$DRY_RUN" == "0" ]]; then
  require_command fslmaths
  require_command applywarp
  require_command tckgen
fi

if [[ "$ALLOW_OVERWRITE" != "1" ]]; then
  for output_path in "${OUTPUTS[@]}"; do
    [[ ! -e "$output_path" ]] || fail "Output already exists: $output_path (set ALLOW_OVERWRITE=1 only after review)"
  done
fi

printf '\nStep 0: create output folders\n'
run mkdir -p "$ATLAS_OUTPUT_DIR" "$ROI_DIR" "$TRACT_DIR" "$COMMAND_DIR"

printf '\nStep 1: dilate the left and right 50%% atlas maps with a 2 mm sphere\n'
run fslmaths "$LEFT_ATLAS_50" -kernel sphere 2 -dilF -bin "$LEFT_ATLAS_DIL2MM"
run fslmaths "$RIGHT_ATLAS_50" -kernel sphere 2 -dilF -bin "$RIGHT_ATLAS_DIL2MM"

printf '\nStep 2: build and binarize the bilateral MNI-space corridor\n'
run fslmaths "$RIGHT_ATLAS_DIL2MM" \
  -add "$LEFT_ATLAS_DIL2MM" \
  -add "$LEFT_VTA_ROI" -add "$RIGHT_VTA_ROI" \
  -add "$LEFT_NAC_ROI" -add "$RIGHT_NAC_ROI" \
  -bin "$MNI_CORRIDOR"

printf '\nStep 3: transform the binary corridor to native diffusion space\n'
run applywarp \
  "--in=${MNI_CORRIDOR}" \
  "--ref=${NATIVE_BRAIN_MASK}" \
  "--warp=${MNI_TO_NATIVE_WARP}" \
  "--out=${NATIVE_CORRIDOR}" \
  --interp=nn

printf '\nStep 4: create the outside-corridor exclusion mask\n'
run fslmaths "$NATIVE_CORRIDOR" -binv "$INVERSE_CORRIDOR"
run fslmaths "$NATIVE_BRAIN_MASK" -mas "$INVERSE_CORRIDOR" "$EXCLUSION_CORRIDOR"

printf '\nStep 5: transform VTA and NAc endpoint regions\n'
run applywarp "--in=${LEFT_VTA_ROI}" "--ref=${NATIVE_BRAIN_MASK}" "--warp=${MNI_TO_NATIVE_WARP}" "--out=${NATIVE_LEFT_VTA}" --interp=nn
run applywarp "--in=${RIGHT_VTA_ROI}" "--ref=${NATIVE_BRAIN_MASK}" "--warp=${MNI_TO_NATIVE_WARP}" "--out=${NATIVE_RIGHT_VTA}" --interp=nn
run applywarp "--in=${LEFT_NAC_ROI}" "--ref=${NATIVE_BRAIN_MASK}" "--warp=${MNI_TO_NATIVE_WARP}" "--out=${NATIVE_LEFT_NAC}" --interp=nn
run applywarp "--in=${RIGHT_NAC_ROI}" "--ref=${NATIVE_BRAIN_MASK}" "--warp=${MNI_TO_NATIVE_WARP}" "--out=${NATIVE_RIGHT_NAC}" --interp=nn

LEFT_TCKGEN=(
  tckgen "$WHITE_MATTER_FOD" "$LEFT_TCK"
  -seed_image "$NATIVE_LEFT_VTA"
  -seed_unidirectional -select "$SELECT_STREAMLINES" -seeds "$MAX_SEED_ATTEMPTS"
  -include "$NATIVE_LEFT_NAC"
  -exclude "$EXCLUSION_CORRIDOR"
  -exclude "$RIGHT_HEMI_MASK"
  -fslgrad "$BVEC_FILE" "$BVAL_FILE"
  -cutoff "$FOD_CUTOFF" -stop -nthreads "$NTHREADS"
)

RIGHT_TCKGEN=(
  tckgen "$WHITE_MATTER_FOD" "$RIGHT_TCK"
  -seed_image "$NATIVE_RIGHT_VTA"
  -seed_unidirectional -select "$SELECT_STREAMLINES" -seeds "$MAX_SEED_ATTEMPTS"
  -include "$NATIVE_RIGHT_NAC"
  -exclude "$EXCLUSION_CORRIDOR"
  -exclude "$LEFT_HEMI_MASK"
  -fslgrad "$BVEC_FILE" "$BVAL_FILE"
  -cutoff "$FOD_CUTOFF" -stop -nthreads "$NTHREADS"
)

if [[ "$ALLOW_OVERWRITE" == "1" ]]; then
  LEFT_TCKGEN+=(-force)
  RIGHT_TCKGEN+=(-force)
fi

printf '\nStep 6: run left and right tractography\n'
run "${LEFT_TCKGEN[@]}"
run "${RIGHT_TCKGEN[@]}"

if [[ "$DRY_RUN" == "0" ]]; then
  {
    printf '# Commands used for %s\n' "$PARTICIPANT_ID"
    printf '# Application example: 1,000 streamlines; 10,000,000 attempts; cutoff 0.05\n'
    printf '%q ' "${LEFT_TCKGEN[@]}"; printf '\n'
    printf '%q ' "${RIGHT_TCKGEN[@]}"; printf '\n'
  } > "$COMMAND_LOG"

  {
    printf 'field\tvalue\n'
    printf 'participant_id\t%s\n' "$PARTICIPANT_ID"
    printf 'workflow\tMesoConnect Inferior VTA-NAc atlas-guided application example\n'
    printf 'atlas_threshold\t50 percent\n'
    printf 'dilation_kernel\tsphere\n'
    printf 'dilation_radius_mm\t2\n'
    printf 'interpolation\tnearest neighbor\n'
    printf 'accepted_streamlines\t%s\n' "$SELECT_STREAMLINES"
    printf 'maximum_seeding_attempts\t%s\n' "$MAX_SEED_ATTEMPTS"
    printf 'fod_cutoff\t%s\n' "$FOD_CUTOFF"
    printf 'stop_rule\t-stop\n'
    printf 'mni_to_native_warp\t%s\n' "$MNI_TO_NATIVE_WARP"
    printf 'native_brain_mask\t%s\n' "$NATIVE_BRAIN_MASK"
    printf 'white_matter_fod\t%s\n' "$WHITE_MATTER_FOD"
  } > "$MANIFEST"

  printf '\nCompleted. Inspect all masks and streamlines before analysis.\n'
  printf 'Command log: %s\n' "$COMMAND_LOG"
  printf 'Manifest: %s\n' "$MANIFEST"
else
  printf '\nDry run complete. No commands were executed.\n'
  printf 'Review every printed path, then rerun with DRY_RUN=0.\n'
fi
