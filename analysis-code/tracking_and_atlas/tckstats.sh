#!/usr/bin/env bash

set -u

output_dir="/zpool/olsonlab/active_drive/ranesh/hcp_7t/tckstats_csvs"
mkdir -p "$output_dir"

subjects=(100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426 \
126931 128935 130114 130518 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735 \
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343 \
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160)

tracts=(
  "l_vta_l_anterior_hipp"
  "r_vta_r_anterior_hipp"
  "l_vta_l_posterior_hipp"
  "r_vta_r_posterior_hipp"
  "l_vta_l_amygdala"
  "r_vta_r_amygdala"
  "l_hipp_l_accumbens"
  "r_hipp_r_accumbens"
  "l_hipp_l_vp"
  "r_hipp_r_vp"
  "l_vp_l_vta"
  "r_vp_r_vta"
  "inferior_l_vta_l_accumbens"
  "inferior_r_vta_r_accumbens"
  "superior_l_vta_l_accumbens"
  "superior_r_vta_r_accumbens"
)

tck_path_for() {
  local subj="$1"
  local tract="$2"
  echo "/zpool/olsonlab/active_drive/ranesh/hcp_7t/${subj}/tckmap/${tract}/${tract}.tck"
}

tckstats_six() {
  local f="$1"
  tckstats "$f" 2>/dev/null | awk '
    NR==2 {
      n=0
      for (i=1; i<=NF; i++) {
        if ($i ~ /^-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?$/) {
          n++
          vals[n]=$i
        }
      }
      if (n>=6) {
        printf("%s,%s,%s,%s,%s,%s\n", vals[1], vals[2], vals[3], vals[4], vals[5], vals[6])
      } else {
        print "NA,NA,NA,NA,NA,NA"
      }
    }'
}

for tract in "${tracts[@]}"; do
  output_csv="${output_dir}/${tract}_tckstats.csv"

  echo "Subject,Mean,Median,StdDev,Min,Max,Count" > "$output_csv"

  for s in "${subjects[@]}"; do
    echo "Processing $s -> $tract"

    f="$(tck_path_for "$s" "$tract")"

    if [[ -f "$f" ]]; then
      vals=$(tckstats_six "$f" || true)
      [[ -z "${vals:-}" ]] && vals="NA,NA,NA,NA,NA,NA"
      echo "${s},${vals}" >> "$output_csv"
    else
      echo "${s},NA,NA,NA,NA,NA,NA" >> "$output_csv"
    fi
  done

  echo "Wrote: $output_csv"
done
