#Run MSMT CSD pipeline

#Convert dwi files to .mif - get everything in an mrtrix3 compatible format
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd
mrconvert /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/data.nii.gz -fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/dwi.mif 
mrconvert /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/nodif_brain_mask.nii.gz /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/mask.mif 
done

#Generate tissue response functions
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
dwi2response dhollander /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/dwi.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_response.txt /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_response.txt /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_response.txt
done


#Get group averaged response functions - mrtrix3 recommendation

#navigate to parent directory where each subject has their own folder
cd /zpool/olsonlab/active_drive/ranesh/hcp_7t

#Group-average WM response
responsemean */csd/wm_response.txt group_wm_response.txt -info -force

#Group-average GM response
responsemean */csd/gm_response.txt group_gm_response.txt -info -force

#Group-average CSF response
responsemean */csd/csf_response.txt group_csf_response.txt -info -force



#Generate FODs
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
dwi2fod -mask /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/mask.mif msmt_csd /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/dwi.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/group_wm_response.txt /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/group_gm_response.txt /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_fod.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/group_csf_response.txt /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_fod.mif -force
done


#get normalized FODs
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
mtnormalise \
/zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod.mif  /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif \
/zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_fod.mif  /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_fod_norm.mif \
/zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_fod.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_fod_norm.mif \
-mask /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/mask.mif \
-force
done


#Create a concatenated image with all tissue types in a single image - both for normalized and non-normalized FODs (just to have)
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
mrconvert -coord 3 0 /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod.mif - | mrcat /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_fod.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_fod.mif - /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/vf_fod.mif
mrconvert -coord 3 0 /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif - | mrcat /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/csf_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/gm_fod_norm.mif - /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/vf_fod_norm.mif
done

##########################################################################################################################################
#we will try to get 2500 streamlines per subject, note some subjects will not reach this threshold and that is fine
#Streamline counts are arbitrary anyways, and this is to better visualize endpoint terminations and group maps, rather than act as a measure of connectivity
#For all tracking I specify 25 million seeding attempts, by default, it seeds 1000 x select, which might not be enough for some subjects to reach 2500 stremlines
#If it hits 25 million seeding attempts and there are still not 2,500 streamlines, that is okay, that subject will just have a lower streamline count
#This shouldn't be an issue when combining across all subjects in the dataset to visualize group maps
##########################################################################################################################################
#VTA-posterior hippocampus

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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_posterior_hipp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_posterior_hipp/l_vta_l_posterior_hipp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/Body_tail_HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.06 \
-minlength 35 \
-maxlength 65 \
-stop \
-nthreads 24 \
-force
done

#right hemisphere
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_posterior_hipp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_posterior_hipp/r_vta_r_posterior_hipp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/Body_tail_HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.06 \
-minlength 35 \
-maxlength 65 \
-stop \
-nthreads 24 \
-force
done

##########################################################################################################################################
#VTA-anterior hippocampus

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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_anterior_hipp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_anterior_hipp/l_vta_l_anterior_hipp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/head_HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.06 \
-minlength 35 \
-maxlength 65 \
-stop \
-nthreads 24 \
-force
done

#right hemisphere
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_anterior_hipp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_anterior_hipp/r_vta_r_anterior_hipp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/head_HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.06 \
-minlength 35 \
-maxlength 65 \
-stop \
-nthreads 24 \
-force
done

##########################################################################################################################################

#Left VTA-amygdala tractography
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_amygdala

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vta_l_amygdala/l_vta_l_amygdala.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.08 \
-minlength 27 \
-maxlength 40 \
-stop \
-nthreads 24 \
-force
done


#right
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_amygdala

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vta_r_amygdala/r_vta_r_amygdala.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/striatum_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.08 \
-minlength 27 \
-maxlength 40 \
-stop \
-nthreads 24 \
-force
done



##########################################################################################################################################
#Inferior VTA-NAc

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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/inferior_l_vta_l_accumbens

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/inferior_l_vta_l_accumbens/inferior_l_vta_l_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ac_ant_sup_mask_90_128_67.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.03 \
-minlength 8 \
-maxlength 35 \
-step 0.25 \
-angle 7 \
-stop \
-nthreads 24 \
-force
done

#right vta-nac inferior
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/inferior_r_vta_r_accumbens
tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/inferior_r_vta_r_accumbens/inferior_r_vta_r_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ac_ant_sup_mask_90_128_67.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.03 \
-minlength 8 \
-maxlength 35 \
-angle 7 \
-step 0.25 \
-stop \
-nthreads 24 \
-force
done

##########################################################################################################################################
#Superior VTA-NAc

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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/superior_l_vta_l_accumbens
tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/superior_l_vta_l_accumbens/superior_l_vta_l_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ac_ant_inf_mask_90_128_67.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.03 \
-minlength 8 \
-maxlength 35 \
-stop \
-nthreads 24 \
-force
done

#right hemi

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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/superior_r_vta_r_accumbens
tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/superior_r_vta_r_accumbens/superior_r_vta_r_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/RN_whole_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/ac_ant_inf_mask_90_128_67.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-cutoff 0.03 \
-minlength 8 \
-maxlength 35 \
-stop \
-nthreads 24 \
-force
done

####################################################################################################################################

#Hippocampus-Ventral Pallidum (accumbens waypoint)

#left hemisphere
for s in 177140 177645 177746 178142 178243 178647 180533 181232 182436 182739 \
185442 186949 187345 191033 191336 191841 192439 192641 193845 195041 196144 197348 198653 199655 200210 200311 200614 \
201515 203418 204521 205220 209228 212419 214019 214524 221319 233326 239136 246133 249947 251833 257845 263436 283543 \
318637 320826 330324 346137 352738 360030 365343 380036 381038 385046 389357 393247 395756 397760 401422 406836 412528 \
429040 436845 463040 467351 525541 541943 547046 550439 562345 572045 573249 581450 585256 601127 617748 627549 638049 \
644246 654552 671855 680957 690152 706040 724446 725751 732243 745555 751550 757764 765864 770352 771354 782561 783462 \
789373 814649 818859 825048 826353 833249 859671 861456 871762 872764 878776 878877 898176 899885 901139 901442 905147 \
910241 926862 927359 942658 943862 951457 958976 966975 971160 
do
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_hipp_l_vp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_hipp_l_vp/l_hipp_l_vp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-seed_unidirectional \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 5 \
-cutoff 0.04 \
-stop \
-nthreads 48 \
-force
done


#right hemisphere
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

mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_hipp_r_vp

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_hipp_r_vp/r_hipp_r_vp.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-seed_unidirectional \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-include_ordered /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 5 \
-cutoff 0.04 \
-stop \
-nthreads 48 \
-force
done

####################################################################################################################################

#Hippocampus-Accumbens (no vp)

#left hemisphere
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_hipp_l_accumbens

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_hipp_l_accumbens/l_hipp_l_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_accumbens_bin.nii.gz \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin_eroded_3.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 5 \
-cutoff 0.08 \
-stop \
-nthreads 24 \
-force
done

#right hemi
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_hipp_r_accumbens

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_hipp_r_accumbens/r_hipp_r_accumbens.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_accumbens_bin.nii.gz \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin_eroded_3.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_ventral_pallidum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 5 \
-cutoff 0.08 \
-stop \
-nthreads 24 \
-force
done

####################################################################################################################################


#left vp-vta
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vp_l_vta

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/l_vp_l_vta/l_vp_l_vta.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_ventral_pallidum_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_VTA_0.25_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_L_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/left_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Rhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 15 \
-maxlength 25 \
-cutoff 0.03 \
-angle 15 \
-stop \
-nthreads 24 \
-force
done

#right VP-VTA
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
mkdir -p /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vp_r_vta

tckgen /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/csd/wm_fod_norm.mif /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/tckgen/r_vp_r_vta/r_vp_r_vta.tck \
-seed_image /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_ventral_pallidum_bin.nii.gz \
-seed_unidirectional \
-include /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_VTA_0.25_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/fornix_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/thalamus_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/cortex_cerebellum_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/brainstem_exclusion_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/HPC_R_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/right_amygdala_0.5_bin.nii.gz \
-exclude /zpool/olsonlab/active_drive/ranesh/hcp_7t/${s}/roi/T1_MNI_Lhemi_bin.nii.gz \
-fslgrad /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvecs /zpool/olsonlab/data_drive/hcp_7t/${s}/dwi/bvals \
-select 2500 \
-seeds 25000000 \
-minlength 15 \
-maxlength 25 \
-cutoff 0.03 \
-angle 15 \
-stop \
-nthreads 24 \
-force
done



