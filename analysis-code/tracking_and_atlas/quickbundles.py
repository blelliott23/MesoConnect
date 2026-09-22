#!/usr/bin/env python3

from pathlib import Path
from dipy.io.streamline import load_tractogram, save_tractogram
from dipy.io.stateful_tractogram import StatefulTractogram, Space
from dipy.segment.clustering import QuickBundles

# ============================================================
# Settings
# ============================================================

data_root = Path("/zpool/olsonlab/data_drive/hcp_7t")
tract_root = Path("/zpool/olsonlab/active_drive/ranesh/hcp_7t")

threshold = 5
min_size = 3

tracts = [
    "l_vta_l_amygdala",
    "r_vta_r_amygdala",
    "l_vta_l_posterior_hipp",
    "r_vta_r_posterior_hipp",
    "l_vta_l_anterior_hipp",
    "r_vta_r_anterior_hipp"
]

subjects = [
    '100610','102311','102816','104416','105923','108323','109123','111312','111514','114823','115017','115825',
    '116726','118225','125525','126426','126931','128935','130114','131722','132118','134627',
    '134829','135124','137128','140117','144226','145834','146129','146432','146735','146937','148133','150423',
    '155938','156334','157336','158035','158136','159239','162935','164131','164636','165436','167036','167440',
    '169040','169343','169444','169747','171633','172130','173334','175237','176542','177140','177645','177746',
    '178142','178243','178647','180533','181232','182436','182739','185442','186949','187345','191033','191336',
    '191841','192439','192641','193845','195041','196144','197348','198653','199655','200210','200311','200614',
    '201515','203418','204521','205220','209228','212419','214019','214524','221319','233326','239136','246133',
    '249947','251833','257845','283543','318637','320826','330324','346137','352738','360030','365343',
    '380036','381038','385046','393247','395756','397760','401422','406836','412528','429040','436845',
    '463040','467351','525541','541943','547046','562345','572045','573249','581450','585256','601127',
    '617748','627549','638049','644246','654552','671855','680957','690152','706040','724446','725751','732243',
    '745555','751550','757764','765864','770352','771354','782561','783462','789373','814649','818859','825048',
    '826353','833249','859671','861456','871762','872764','878776','878877','898176','899885','901139','901442',
    '905147','910241','926862','927359','942658','943862','951457','958976','966975','971160'
]

# ============================================================
# Main loop
# ============================================================

for tract in tracts:
    print(f"\n===== {tract} =====")

    for subj in subjects:
        ref_img = data_root / subj / "dwi" / "data.nii.gz"
        in_tck = tract_root / subj / "tckgen" / tract / f"{tract}.tck"
        out_dir = in_tck.parent

        out_prefix = f"{tract}_qb_thr_5"
        out1_tck = out_dir / f"{out_prefix}_cluster1.tck"
        out2_tck = out_dir / f"{out_prefix}_cluster2.tck"
        out1_trk = out_dir / f"{out_prefix}_cluster1.trk"
        out2_trk = out_dir / f"{out_prefix}_cluster2.trk"

        if not in_tck.exists():
            print(f"[{subj}] missing tract")
            continue

        if not ref_img.exists():
            print(f"[{subj}] missing ref")
            continue

        try:
            sft = load_tractogram(str(in_tck), str(ref_img), bbox_valid_check=False)
            sft.to_rasmm()

            streamlines = sft.streamlines

            if len(streamlines) == 0:
                print(f"[{subj}] empty")
                continue

            clusters = QuickBundles(threshold=threshold).cluster(streamlines).clusters
            clusters = [c for c in clusters if len(c.indices) >= min_size]
            clusters.sort(key=lambda c: len(c.indices), reverse=True)

            if len(clusters) >= 2:
                sl1 = [streamlines[i] for i in clusters[0].indices]
                sl2 = [streamlines[i] for i in clusters[1].indices]

                sft1 = StatefulTractogram(sl1, sft, Space.RASMM)
                sft2 = StatefulTractogram(sl2, sft, Space.RASMM)

                save_tractogram(sft1, str(out1_tck), bbox_valid_check=False)
                save_tractogram(sft2, str(out2_tck), bbox_valid_check=False)
                save_tractogram(sft1, str(out1_trk), bbox_valid_check=False)
                save_tractogram(sft2, str(out2_trk), bbox_valid_check=False)

                print(f"[{subj}] split: {len(sl1)} | {len(sl2)}")

            else:
                sft_all = StatefulTractogram(list(streamlines), sft, Space.RASMM)

                save_tractogram(sft_all, str(out1_tck), bbox_valid_check=False)
                save_tractogram(sft_all, str(out1_trk), bbox_valid_check=False)

                print(f"[{subj}] single: {len(streamlines)}")

        except Exception as e:
            print(f"[{subj}] failed: {e}")

print("\nALL DONE")
