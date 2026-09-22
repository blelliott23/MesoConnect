#!/usr/bin/env python3
# Node-wise NODDI profiles (NDI, ODI, FWF)
# Loops over tracts and writes one CSV per tract to nodewise/csvs

from pathlib import Path
import csv
import numpy as np
import matplotlib.pyplot as plt

import dipy.stats.analysis as dsa
import dipy.tracking.streamline as dts
from dipy.io.streamline import load_tractogram
from dipy.io.image import load_nifti
from dipy.segment.clustering import QuickBundles
from dipy.segment.metricspeed import AveragePointwiseEuclideanMetric
from dipy.segment.featurespeed import ResampleFeature

tracts = [
    "l_vta_l_posterior_hipp",
    "r_vta_r_posterior_hipp",
    "l_vta_l_anterior_hipp",
    "r_vta_r_anterior_hipp",
    "l_vta_l_amygdala",
    "r_vta_r_amygdala",
    "l_hipp_l_accumbens",
    "r_hipp_r_accumbens",
    "l_hipp_l_vp",
    "r_hipp_r_vp",
    "l_vp_l_vta",
    "r_vp_r_vta",
    "inferior_l_vta_l_accumbens",
    "inferior_r_vta_r_accumbens",
    "superior_l_vta_l_accumbens",
    "superior_r_vta_r_accumbens",
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

tract_root = Path("/zpool/olsonlab/active_drive/ranesh/hcp_7t")
noddi_root = tract_root / "NODDI"
nodewise = tract_root / "nodewise"
nodewise.mkdir(parents=True, exist_ok=True)

csv_dir = nodewise / "csvs"
csv_dir.mkdir(parents=True, exist_ok=True)

num_nodes = 100
min_streamlines = 5

def orient_to_centroid(streamlines, nb_points=num_nodes):
    feat = ResampleFeature(nb_points=nb_points)
    metric = AveragePointwiseEuclideanMetric(feat)
    qb = QuickBundles(threshold=np.inf, metric=metric)
    centroid = qb.cluster(streamlines).centroids[0]
    oriented = dts.orient_by_streamline(streamlines, centroid)
    return dts.Streamlines(oriented)


def profile_metric(img_path, streamlines, nb_points=num_nodes):
    data, aff = load_nifti(str(img_path))
    weights = dsa.gaussian_weights(streamlines)
    prof = dsa.afq_profile(data, streamlines, aff, nb_points=nb_points, weights=weights)
    return np.asarray(prof, dtype=float)


for tract in tracts:
    print(f"\n{'='*80}\nProcessing tract: {tract}\n{'='*80}")

    csv_path = csv_dir / f"{tract}_noddi_nodewise_all_subjects.csv"

    with open(csv_path, "w", newline="") as fcsv:
        w = csv.writer(fcsv)
        w.writerow(["Subject", "Tract", "Node", "NDI", "ODI", "FWF"])

        for s in subjects:
            try:
                # inputs
                tdir = tract_root / s / "tckmap" / tract
                in_tck = tdir / f"{tract}.tck"

                noddir = noddi_root / f"sub-{s}"
                f_ndi = noddir / "fit_NDI_modulated.nii.gz"
                f_odi = noddir / "fit_ODI_modulated.nii.gz"
                f_fwf = noddir / "fit_FWF.nii.gz"

                if not in_tck.exists():
                    print(f"[{s}] [{tract}] SKIP: missing tract file {in_tck}")
                    continue
                if not f_ndi.exists():
                    print(f"[{s}] [{tract}] SKIP: missing NDI file {f_ndi}")
                    continue
                if not f_odi.exists():
                    print(f"[{s}] [{tract}] SKIP: missing ODI file {f_odi}")
                    continue
                if not f_fwf.exists():
                    print(f"[{s}] [{tract}] SKIP: missing FWF file {f_fwf}")
                    continue

                # subject-specific PNG folder under nodewise
                out_png_dir = nodewise / s / tract
                out_png_dir.mkdir(parents=True, exist_ok=True)

                # load → orient → profile
                tg = load_tractogram(str(in_tck), str(f_ndi), bbox_valid_check=False)
                sl = tg.streamlines

                if len(sl) < min_streamlines:
                    print(f"[{s}] [{tract}] SKIP: only {len(sl)} streamlines (< {min_streamlines})")
                    continue

                sl_oriented = orient_to_centroid(sl, nb_points=num_nodes)

                ndi = profile_metric(f_ndi, sl_oriented, nb_points=num_nodes)
                odi = profile_metric(f_odi, sl_oriented, nb_points=num_nodes)
                fwf = profile_metric(f_fwf, sl_oriented, nb_points=num_nodes)

                # write rows for this subject
                for node in range(num_nodes):
                    w.writerow([s, tract, node, float(ndi[node]), float(odi[node]), float(fwf[node])])

                # PNGs per subject/tract
                for metric_name, prof in (("NDI", ndi), ("ODI", odi), ("FWF", fwf)):
                    plt.figure()
                    plt.plot(prof)
                    plt.ylabel(metric_name)
                    plt.xlabel(f"Node along {tract}")
                    plt.title(f"{s} • {tract} • {metric_name}")
                    plt.tight_layout()
                    plt.savefig(out_png_dir / f"{tract}_{metric_name}_profile.png", dpi=300)
                    plt.close()

                print(f"[{s}] [{tract}] wrote rows to {csv_path} and PNGs to {out_png_dir}")

            except Exception as e:
                print(f"[{s}] [{tract}] SKIP due to error: {e}")

print(f"\nALL DONE.\nCSV directory: {csv_dir}")
