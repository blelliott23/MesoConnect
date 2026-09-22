#!/usr/bin/env bash
set -euo pipefail

export FREESURFER_HOME=/usr/local/freesurfer/8.0.0
source "$FREESURFER_HOME/SetUpFreeSurfer.sh"

export SUBJECTS_DIR="/zpool/olsonlab/active_drive/ranesh/hcp_7t/freesurfer/recon_all_output"
OUT_BASE="/zpool/olsonlab/active_drive/ranesh/hcp_7t/hipp_subfields"

SUBJECTS=(
100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426
126931 128935 130114 130518 131217 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528
429040 436845 463040 467351 525541 541943 547046 550439 562345 572045 573249 581450 585256 601127 617748 627549 638049
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147
910241 926862 927359 942658 943862 951457 958976 966975 971160
)

declare -A LABELS=(
  [presubiculum_head]=233
  [presubiculum_body]=234
  [subiculum_head]=235
  [subiculum_body]=236
  [CA1_head]=237
  [CA1_body]=238
  [CA3_head]=239
  [CA3_body]=240
  [CA4_head]=241
  [CA4_body]=242
  [DG_head]=243
  [DG_body]=244
  [parasubiculum]=203
)

for s in "${SUBJECTS[@]}"; do
  echo "Processing ${s}"

  MRI_DIR="${SUBJECTS_DIR}/${s}/mri"
  LH_SEG="${MRI_DIR}/lh.hippoAmygLabels-T1.v22.FSvoxelSpace.mgz"
  RH_SEG="${MRI_DIR}/rh.hippoAmygLabels-T1.v22.FSvoxelSpace.mgz"

  ROI_DIR="${OUT_BASE}/${s}/freesurfer_roi"
  REORIENT_DIR="${OUT_BASE}/${s}/reoriented_roi"

  mkdir -p "$ROI_DIR" "$REORIENT_DIR"

  if [[ ! -f "$LH_SEG" || ! -f "$RH_SEG" ]]; then
    echo "Missing segmentation for ${s}, skipping"
    continue
  fi

  for hemi in lh rh; do
    if [[ "$hemi" == "lh" ]]; then
      SEG="$LH_SEG"
    else
      SEG="$RH_SEG"
    fi

    for roi in "${!LABELS[@]}"; do
      mri_binarize \
        --i "$SEG" \
        --match "${LABELS[$roi]}" \
        --o "${ROI_DIR}/${hemi}_${roi}.nii.gz"
    done

    fslmaths "${ROI_DIR}/${hemi}_CA1_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_CA1_body.nii.gz" \
      -bin "${ROI_DIR}/${hemi}_CA1.nii.gz"

    fslmaths "${ROI_DIR}/${hemi}_CA3_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_CA3_body.nii.gz" \
      -bin "${ROI_DIR}/${hemi}_CA3.nii.gz"

    fslmaths "${ROI_DIR}/${hemi}_CA4_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_CA4_body.nii.gz" \
      -bin "${ROI_DIR}/${hemi}_CA4.nii.gz"

    fslmaths "${ROI_DIR}/${hemi}_DG_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_DG_body.nii.gz" \
      -bin "${ROI_DIR}/${hemi}_DG.nii.gz"

    fslmaths "${ROI_DIR}/${hemi}_subiculum_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_subiculum_body.nii.gz" \
      -add "${ROI_DIR}/${hemi}_presubiculum_head.nii.gz" \
      -add "${ROI_DIR}/${hemi}_presubiculum_body.nii.gz" \
      -add "${ROI_DIR}/${hemi}_parasubiculum.nii.gz" \
      -bin "${ROI_DIR}/${hemi}_subiculum.nii.gz"
  done

  for f in "${ROI_DIR}"/*.nii.gz; do
    fslreorient2std "$f" "${REORIENT_DIR}/$(basename "$f")"
  done

done

echo "All done"
