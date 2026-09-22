#!/usr/bin/env python3

import os
import re
import csv
import subprocess
import numpy as np
import nibabel as nib
import pandas as pd

BASE = "/zpool/olsonlab/active_drive/ranesh/hcp_7t"
OUT_DIR = os.path.join(BASE, "vta_hipp_loop_endpoint_com_mni")
os.makedirs(OUT_DIR, exist_ok=True)

TRACTS = [
    "l_vp_l_vta",
    "anterior_l_vta_l_hipp",
    "l_vta_l_hipp",
    "r_vp_r_vta",
    "anterior_r_vta_r_hipp",
    "r_vta_r_hipp"
]

TRACT_LABELS = {
    "l_vp_l_vta": "left vp vta",
    "anterior_l_vta_l_hipp": "left anterior vta hipp",
    "l_vta_l_hipp": "left posterior vta hipp",
    "r_vp_r_vta": "right vp vta",
    "anterior_r_vta_r_hipp": "right anterior vta hipp",
    "r_vta_r_hipp": "right posterior vta hipp"
}

FINAL_CSV = os.path.join(OUT_DIR, "vta_endpoint_COM_MNI_coordinates_vp_hipp.csv")


def ras_to_lps(xyz):
    return np.array([-xyz[0], -xyz[1], xyz[2]])


def lps_to_ras(xyz):
    return np.array([-xyz[0], -xyz[1], xyz[2]])


def run_cmd(cmd):
    subprocess.run(cmd, check=True)


def weighted_com_ras(img_path):
    img = nib.load(img_path)
    data = img.get_fdata()

    vox = np.argwhere(data > 0)

    if vox.shape[0] == 0:
        return np.array([np.nan, np.nan, np.nan])

    weights = data[vox[:, 0], vox[:, 1], vox[:, 2]]
    xyz = nib.affines.apply_affine(img.affine, vox)

    com = np.average(xyz, axis=0, weights=weights)
    return com


def get_subjects():
    subs = []
    for x in os.listdir(BASE):
        if re.fullmatch(r"\d{6}", x):
            if os.path.isdir(os.path.join(BASE, x)):
                subs.append(x)
    return sorted(subs)


rows = []

subjects = get_subjects()

for s in subjects:

    print(f"\nSubject: {s}")

    ref = os.path.join(BASE, s, "anat", "T1w_acpc_dc_restore_1.05_brain.nii.gz")

    affine = os.path.join(BASE, s, "transforms", f"{s}_MNI1mm_to_T1w_0GenericAffine.mat")
    warp = os.path.join(BASE, s, "transforms", f"{s}_MNI1mm_to_T1w_1Warp.nii.gz")

    for tract in TRACTS:

        print(f"  {tract}")

        tck = os.path.join(BASE, s, "tckmap", tract, f"{tract}.tck")

        if tract.startswith("l_") or "_l_" in tract:
            hemi = "left"
            vta = os.path.join(BASE, s, "roi", "left_VTA_0.25_bin.nii.gz")
        else:
            hemi = "right"
            vta = os.path.join(BASE, s, "roi", "right_VTA_0.25_bin.nii.gz")

        tract_out = os.path.join(OUT_DIR, s, tract)
        os.makedirs(tract_out, exist_ok=True)

        endpoint_map = os.path.join(tract_out, f"{tract}_endpoints.nii.gz")
        vta_endpoint_map = os.path.join(tract_out, f"{tract}_VTA_endpoints.nii.gz")

        native_points_csv = os.path.join(tract_out, f"{tract}_COM_native_LPS.csv")
        mni_points_csv = os.path.join(tract_out, f"{tract}_COM_MNI_LPS.csv")

        if not os.path.exists(tck):
            print(f"    missing tck: {tck}")
            rows.append({
                "Subject": s,
                "tract": tract,
                "tract_label": TRACT_LABELS.get(tract, tract),
                "hemi": hemi,
                "MNI_X": np.nan,
                "MNI_Y": np.nan,
                "MNI_Z": np.nan
            })
            continue

        run_cmd([
            "tckmap",
            "-template", ref,
            "-ends_only",
            tck,
            endpoint_map,
            "-force"
        ])

        run_cmd([
            "mrcalc",
            endpoint_map,
            vta,
            "-mult",
            vta_endpoint_map,
            "-force"
        ])

        com_native_ras = weighted_com_ras(vta_endpoint_map)

        if np.any(np.isnan(com_native_ras)):
            rows.append({
                "Subject": s,
                "tract": tract,
                "tract_label": TRACT_LABELS.get(tract, tract),
                "hemi": hemi,
                "MNI_X": np.nan,
                "MNI_Y": np.nan,
                "MNI_Z": np.nan
            })
            continue

        com_native_lps = ras_to_lps(com_native_ras)

        with open(native_points_csv, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["x", "y", "z", "t"])
            writer.writerow([com_native_lps[0], com_native_lps[1], com_native_lps[2], 0])

        run_cmd([
            "antsApplyTransformsToPoints",
            "-d", "3",
            "-i", native_points_csv,
            "-o", mni_points_csv,
            "-t", warp,
            "-t", affine
        ])

        mni_lps_df = pd.read_csv(mni_points_csv)
        com_mni_lps = np.array([
            mni_lps_df.loc[0, "x"],
            mni_lps_df.loc[0, "y"],
            mni_lps_df.loc[0, "z"]
        ])

        com_mni_ras = lps_to_ras(com_mni_lps)

        rows.append({
            "Subject": s,
            "tract": tract,
            "tract_label": TRACT_LABELS.get(tract, tract),
            "hemi": hemi,
            "MNI_X": com_mni_ras[0],
            "MNI_Y": com_mni_ras[1],
            "MNI_Z": com_mni_ras[2]
        })


out_df = pd.DataFrame(rows)
out_df.to_csv(FINAL_CSV, index=False)

print("\nSaved:")
print(FINAL_CSV)
