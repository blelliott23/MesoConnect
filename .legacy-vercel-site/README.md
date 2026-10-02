# Legacy MesoConnect static website

This hidden directory preserves the source for the former static MesoConnect website. It is an archive only and is not used by the current Vercel deployment.

The primary tutorial is the Docusaurus site at https://mesoconnect.vercel.app/.

Do not treat this directory as the current tutorial source. Current Docusaurus source is mirrored under [`../website/`](../website/) and maintained upstream in [DiffusionTensorImaging-Repos/MesoConnect-Tutorial](https://github.com/DiffusionTensorImaging-Repos/MesoConnect-Tutorial).

## Local maintenance

The legacy build reads the canonical `analysis-code/`, `data/`, `downloads/`, `examples/`, `LICENSE`, and `ROI_RESOURCES.md` files from the parent repository and assembles a deployable copy under this directory's ignored `dist/` folder.

```bash
cd .legacy-vercel-site
npm run check
```

The active Vercel project builds [`../website/`](../website/) from the main MesoConnect GitHub repository. Running the commands in this archived directory only creates a local legacy build.
