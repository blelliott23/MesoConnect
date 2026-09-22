#!/usr/bin/env python3

import os
import re
import csv
import subprocess
import numpy as np
import nibabel as nib
import pandas as pd

BASE = "/zpool/olsonlab/active_drive/ranesh/hcp_7t"
OUT_DIR = os.path.join(BASE, "accumbens_endpoint_com_mni")
os.makedirs(OUT_DIR, exist_ok=True)

TRACTS = [
    "inferior_l_vta_l_accumbens",
    "superior_l_vta_l_accumbens",
    "inferior_r_vta_r_accumbens",
    "superior_r_vta_r_accumbens"
]

FINAL_CSV = os.path.join(OUT_DIR, "accumbens_endpoint_COM_MNI_coordinates.csv")


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


def weighted_median_1d(values, weights):
    values = np.asarray(values, dtype=float)
    weights = np.asarray(weights, dtype=float)

    order = np.argsort(values)
    values_sorted = values[order]
    weights_sorted = weights[order]

    cum_weights = np.cumsum(weights_sorted)
    cutoff = 0.5 * np.sum(weights_sorted)

    idx = np.searchsorted(cum_weights, cutoff, side="left")
    return values_sorted[idx]


def weighted_median_coords_ras(img_path):
    img = nib.load(img_path)
    data = img.get_fdata()

    vox = np.argwhere(data > 0)

    if vox.shape[0] == 0:
        return np.array([np.nan, np.nan, np.nan])

    weights = data[vox[:, 0], vox[:, 1], vox[:, 2]]
    xyz = nib.affines.apply_affine(img.affine, vox)

    median_x = weighted_median_1d(xyz[:, 0], weights)
    median_y = weighted_median_1d(xyz[:, 1], weights)
    median_z = weighted_median_1d(xyz[:, 2], weights)

    return np.array([median_x, median_y, median_z])


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
            accumbens = os.path.join(BASE, s, "roi", "left_accumbens_bin.nii.gz")
        else:
            hemi = "right"
            accumbens = os.path.join(BASE, s, "roi", "right_accumbens_bin.nii.gz")

        tract_out = os.path.join(OUT_DIR, s, tract)
        os.makedirs(tract_out, exist_ok=True)

        endpoint_map = os.path.join(tract_out, f"{tract}_endpoints.nii.gz")
        accumbens_endpoint_map = os.path.join(tract_out, f"{tract}_accumbens_endpoints.nii.gz")

        native_points_csv = os.path.join(tract_out, f"{tract}_COM_native_LPS.csv")
        mni_points_csv = os.path.join(tract_out, f"{tract}_COM_MNI_LPS.csv")

        if not os.path.exists(tck):
            print(f"    missing tck: {tck}")
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
            accumbens,
            "-mult",
            accumbens_endpoint_map,
            "-force"
        ])

        com_native_ras = weighted_com_ras(accumbens_endpoint_map)
        median_native_ras = weighted_median_coords_ras(accumbens_endpoint_map)

        if np.any(np.isnan(com_native_ras)):
            rows.append({
                "Subject": s,
                "tract": tract,
                "hemi": hemi,
                "MNI_X": np.nan,
                "MNI_Y": np.nan,
                "MNI_Z": np.nan,
                "median_MNI_X": np.nan,
                "median_MNI_Y": np.nan,
                "median_MNI_Z": np.nan
            })
            continue

        com_native_lps = ras_to_lps(com_native_ras)
        median_native_lps = ras_to_lps(median_native_ras)

        with open(native_points_csv, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["x", "y", "z", "t"])
            writer.writerow([com_native_lps[0], com_native_lps[1], com_native_lps[2], 0])
            writer.writerow([median_native_lps[0], median_native_lps[1], median_native_lps[2], 0])

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

        median_mni_lps = np.array([
            mni_lps_df.loc[1, "x"],
            mni_lps_df.loc[1, "y"],
            mni_lps_df.loc[1, "z"]
        ])

        com_mni_ras = lps_to_ras(com_mni_lps)
        median_mni_ras = lps_to_ras(median_mni_lps)

        rows.append({
            "Subject": s,
            "tract": tract,
            "hemi": hemi,
            "MNI_X": com_mni_ras[0],
            "MNI_Y": com_mni_ras[1],
            "MNI_Z": com_mni_ras[2],
            "median_MNI_X": median_mni_ras[0],
            "median_MNI_Y": median_mni_ras[1],
            "median_MNI_Z": median_mni_ras[2]
        })


out_df = pd.DataFrame(rows)
out_df.to_csv(FINAL_CSV, index=False)

print("\nSaved:")
print(FINAL_CSV)
