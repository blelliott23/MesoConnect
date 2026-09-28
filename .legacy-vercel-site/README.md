# Legacy MesoConnect static website

This hidden directory preserves the source for the former static MesoConnect website while its existing Vercel deployment remains temporarily available at:

https://mesoconnect.vercel.app/

The primary tutorial is now the Docusaurus site:

https://diffusiontensorimaging-repos.github.io/MesoConnect-Tutorial/

Do not treat this directory as the current tutorial source. Current Docusaurus source is mirrored under [`../website/`](../website/) and maintained upstream in [DiffusionTensorImaging-Repos/MesoConnect-Tutorial](https://github.com/DiffusionTensorImaging-Repos/MesoConnect-Tutorial).

## Local maintenance

The legacy build reads the canonical `analysis-code/`, `data/`, `downloads/`, `examples/`, `LICENSE`, and `ROI_RESOURCES.md` files from the parent repository and assembles a deployable copy under this directory's ignored `dist/` folder.

```bash
cd .legacy-vercel-site
npm run check
```

The Vercel project is not Git-connected, so pushes to the MesoConnect repository do not automatically redeploy or replace the currently active production deployment.
