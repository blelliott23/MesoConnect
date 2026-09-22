#To get MNI to T1 warp fields, need to skullstrip the T1w to obtain a brain mask and then generate warp fields to register

#skullstrip using synthstrip
for s in 100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426 \
126931 128935 130114 130518 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735 \
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343 \
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160
do
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/anat

mri_synthstrip \
  -i /zpool/olsonlab/data_drive/hcp_7t/${s}/T1w/T1w_acpc_dc_restore_1.05.nii.gz \
  -o /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/anat/T1w_acpc_dc_restore_1.05_brain.nii.gz \
  -m /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/anat/T1w_acpc_dc_restore_1.05_brain_mask.nii.gz
done

#ants registration
for s in 100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426 \
126931 128935 130114 130518 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735 \
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343 \
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160
do
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/transforms

antsRegistrationSyNQuick.sh \
  -d 3 \
  -m $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
  -f /zpool/olsonlab/data_drive/hcp_7t/${s}/T1w/T1w_acpc_dc_restore_1.05.nii.gz \
  -x /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/anat/T1w_acpc_dc_restore_1.05_brain_mask.nii.gz,$FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz \
  -o /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/transforms/${s}_MNI1mm_to_T1w_ \
  -t s \
  -n 8
done


#Apply the transforms to all ROIs
for s in 100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426 \
126931 128935 130114 130518 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735 \
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343 \
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160
do
for r in ac_inclusion_bin ac_exclusion_bin amygdala_0.5_bin RN_L_bin RN_R_bin brainstem_exclusion_bin cortex_cerebellum_bin \
striatum_exclusion_bin fornix_bin T1_MNI_Lhemi_bin T1_MNI_Rhemi_bin HPC_L_0.5_bin mammillary_bodies_bin lateral_hypothalamus_bin \
HPC_R_0.5_bin thalamus_bin left_VTA_0.25_bin right_VTA_0.25_bin ventral_pallidum_bin \
left_caudate_bin left_putamen_bin left_accumbens_bin right_caudate_bin right_putamen_bin right_accumbens_bin
do

mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi

antsApplyTransforms -d 3 \
  -i /zpool/olsonlab/active_drive/ranesh/hcp_7t/roi/${r}.nii.gz \
  -r /zpool/olsonlab/data_drive/hcp_7t/${s}/T1w/T1w_acpc_dc_restore_1.05.nii.gz \
  -o /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/${r}.nii.gz \
  -n NearestNeighbor \
  -t /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/transforms/${s}_MNI1mm_to_T1w_1Warp.nii.gz \
  -t /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/transforms/${s}_MNI1mm_to_T1w_0GenericAffine.mat
done
done


#Tidy up the ROIs once in diffusion space (make left and right ROIs, remove overlap)

for s in 100610 102311 102816 104416 105923 108323 109123 111312 111514 114823 115017 115825 116726 118225 125525 126426 \
126931 128935 130114 130518 131217 131722 132118 134627 134829 135124 137128 140117 144226 145834 146129 146432 146735 \
146937 148133 150423 155938 156334 157336 158035 158136 159239 162935 164131 164636 165436 167036 167440 169040 169343 \
169444 169747 171633 172130 173334 175237 176542 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 550439 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160
do

#Subtract the hippocampus from amygdala to get rid of overlap
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz

#get separate left and right amygdala ROIs
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_bin.nii.gz

fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_bin.nii.gz

#Subtract the RN from the VTA to get rid of overlap
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_L_bin.nii.gz \
-add /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_R_bin.nii.gz \
/zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz

fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz

#Subtract the ventral pallidum from the striatum rois
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz

fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz

#make a striatum exclusion roi for the caudate and putamen added together
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_caudate_bin.nii.gz \
-add /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_caudate_bin.nii.gz \
-add /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_putamen_bin.nii.gz \
-add /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_putamen_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz

#Subtract the accumbens and ventral pallidum overlap from the whole striatum exclusion roi
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz

#Get separate right and left ventral pallidum masks
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_ventral_pallidum_bin.nii.gz

fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_ventral_pallidum_bin.nii.gz

#remove any potential overlap of VTA ROI from lateral hypothalamus and mammillary bodies
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/lateral_hypothalamus_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/lateral_hypothalamus_bin.nii.gz

fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/mammillary_bodies_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/mammillary_bodies_bin.nii.gz

#subtract hipp and amygdala from fornix
fslmaths /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-sub /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-bin /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz
done
