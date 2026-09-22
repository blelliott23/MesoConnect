# Anatomical ROI sources used by MesoConnect

The manuscript methods specify three primary anatomical sources: Harvard–Oxford for the hippocampus, amygdala, and nucleus accumbens; Trutti et al. for the ventral tegmental area; and Pauli et al. for the ventral pallidum. These third-party ROI files are not redistributed in this repository. Download them from the original providers, retain their provenance, and review their licenses or terms before reuse.

## Primary manuscript ROI sources

| Region | Source used in the manuscript | Download or access | Citation |
| --- | --- | --- | --- |
| Hippocampus, amygdala, and nucleus accumbens | Harvard–Oxford subcortical structural atlas distributed with FSL | [FSL standard templates and atlases](https://fsl.fmrib.ox.ac.uk/fsl/docs/other/datasets.html) · [Install FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/install/index.html) · after installation, use `atlasq list --extended` to locate the installed atlas | Descriptions and acknowledgements are provided on the [FSL datasets page](https://fsl.fmrib.ox.ac.uk/fsl/docs/other/datasets.html). |
| Ventral tegmental area | Trutti et al. 7T probabilistic human VTA atlas, thresholded at 25% for the manuscript workflow | [Author GitHub repository](https://github.com/ACTrutti/VTA-atlas) · [OSF project](https://osf.io/9pzj3/) | Trutti AC et al. (2021), *Brain Structure and Function*. [doi:10.1007/s00429-021-02231-w](https://doi.org/10.1007/s00429-021-02231-w) |
| Ventral pallidum | Pauli/CIT168 high-resolution probabilistic subcortical atlas | [CIT168 GitHub repository](https://github.com/jmtyszka/CIT168-SubCorticalAtlas) · [OSF data project](https://doi.org/10.17605/OSF.IO/JKZWP) | Pauli WM, Nili AN, Tyszka JM (2018), *Scientific Data*. [doi:10.1038/sdata.2018.63](https://doi.org/10.1038/sdata.2018.63) |

## Related midbrain comparison resource

The Murty et al. probabilistic SN, VTA, and combined dopaminergic-midbrain masks are useful comparison resources but are **not listed as the primary VTA ROI in the MesoConnect manuscript methods**.

- [Murty et al. NeuroVault collection 2485](https://neurovault.org/collections/2485/)
- [Adcock Lab neuroimaging resources](https://www.adcocklab.org/neuroimaging-tools)
- Murty VP et al. (2014), *NeuroImage*. [doi:10.1016/j.neuroimage.2014.06.047](https://doi.org/10.1016/j.neuroimage.2014.06.047)

## Spatial reference

The MesoConnect maps use the FSL MNI152 1 mm grid. A copy of the corresponding reference brain is included in [`data/MesoConnect_Atlas/templates/`](data/MesoConnect_Atlas/templates/) under the applicable FSL terms. See the [FSL standard templates documentation](https://fsl.fmrib.ox.ac.uk/fsl/docs/other/datasets.html) and the local [`templates/README.md`](data/MesoConnect_Atlas/templates/README.md) for provenance.

## Reproducibility checklist

- Record the source, release or download date, filename, probability threshold, and any resampling or morphological operations applied to every ROI.
- Verify that each ROI is on the expected MNI grid before transforming it to participant space.
- Use nearest-neighbor interpolation for binary masks and labels.
- Inspect alignment and left–right orientation in every participant.
- Do not assume atlas labels, thresholds, or licenses are interchangeable across providers.
