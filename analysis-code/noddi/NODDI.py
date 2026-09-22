#!/usr/bin/env python3
import os
import amico

# Threading controls. Adjust these values for the available compute node.
nb_threads = 48
os.environ["OPENBLAS_NUM_THREADS"] = str(nb_threads)
os.environ["OMP_NUM_THREADS"] = str(nb_threads)

subnums = ['100610','102311','102816','104416','105923','108323','109123','111312', '111514','114823','115017','115825',
'116726','118225','125525','126426','126931','128935','130114','130518','131217','131722','132118','134627',
'134829','135124','137128','140117','144226','145834','146129','146432','146735','146937','148133','150423',
'155938','156334','157336','158035','158136','159239','162935','164131','164636','165436','167036','167440',
'169040','169343','169444','169747','171633','172130','173334','175237','176542','177140','177645','177746',
'178142','178243','178647','180533','181232','182436','182739','185442','186949','187345','191033','191336',
'191841','192439','192641','193845','195041','196144','197348','198653','199655','200210','200311','200614',
'201515','203418','204521','205220','209228','212419','214019','214524','221319','233326','239136','246133',
'249947','251833','257845','263436','283543','318637','320826','330324','346137','352738','360030','365343',
'380036','381038','385046','389357','393247','395756','397760','401422','406836','412528','429040','436845',
'463040','467351','525541','541943','547046','550439','562345','572045','573249','581450','585256','601127',
'617748','627549','638049','644246','654552','671855','680957','690152','706040','724446','725751','732243',
'745555','751550','757764','765864','770352','771354','782561','783462','789373','814649','818859','825048',
'826353','833249','859671','861456','871762','872764','878776','878877','898176','899885','901139','901442',
'905147','910241','926862','927359','942658','943862','951457','958976','966975','971160']

HCP_ROOT = "/zpool/olsonlab/data_drive/hcp_7t"
AMICO_ROOT = "/zpool/olsonlab/active_drive/ranesh/hcp_7t/NODDI"

# Treat small b-values as b0
B0_THR = 100

# AMICO setup (once)
amico_setup_dir = os.path.join(AMICO_ROOT, "amico")
if not os.path.exists(amico_setup_dir):
    os.makedirs(AMICO_ROOT, exist_ok=True)
    cwd = os.getcwd()
    os.chdir(AMICO_ROOT)
    amico.setup()
    os.chdir(cwd)

for s in subnums:
    subj = str(s)
    noddi_dir = os.path.join(AMICO_ROOT, f"sub-{subj}")
    os.makedirs(noddi_dir, exist_ok=True)

    # input files
    dwi_path   = os.path.join(HCP_ROOT, subj, "dwi", "data.nii.gz")
    bvals_path = os.path.join(HCP_ROOT, subj, "dwi", "bvals")
    bvecs_path = os.path.join(HCP_ROOT, subj, "dwi", "bvecs")
    mask_path  = os.path.join(HCP_ROOT, subj, "dwi", "nodif_brain_mask.nii.gz")

    # scheme file
    scheme_file = os.path.join(noddi_dir, f"sub-{subj}_scheme.scheme")
    amico.util.fsl2scheme(bvals_path, bvecs_path, scheme_file, bStep=200)

    # AMICO evaluation
    ae = amico.Evaluation(AMICO_ROOT, f"sub-{subj}", noddi_dir)
    ae.set_config('nthreads', nb_threads)
    ae.set_config('BLAS_nthreads', 1)

    # Save tissue-fraction-modulated maps for tissue-weighted analyses.
    ae.set_config('doSaveModulatedMaps', True)
    ae.set_config('doComputeRMSE', True)

    ae.load_data(dwi_path, scheme_file, mask_path, b0_thr=B0_THR)

    # fit NODDI
    ae.set_model("NODDI")
    ae.generate_kernels(regenerate=True)
    ae.load_kernels()
    ae.fit()
    ae.save_results(save_dir_avg=True)

    print(f"[OK] NODDI metrics (modulated) generated for sub-{subj}")

print("All done.")
