#!/usr/bin/env node

/*
 * Assemble the deployable static site in dist/ while keeping website-only
 * source files out of the repository root. Run from the repository root.
 */

import { copyFileSync, cpSync, mkdirSync, readdirSync, rmSync, statSync } from "node:fs";
import { basename, join, resolve } from "node:path";

const projectRoot = resolve(process.cwd());
const websiteRoot = join(projectRoot, "website");
const outputRoot = join(projectRoot, "dist");

rmSync(outputRoot, { recursive: true, force: true });
mkdirSync(outputRoot, { recursive: true });

for (const filename of ["index.html", "404.html"]) {
  copyFileSync(join(websiteRoot, filename), join(outputRoot, filename));
}

cpSync(join(websiteRoot, "assets"), join(outputRoot, "assets"), { recursive: true });

const pagesRoot = join(websiteRoot, "pages");
for (const pageName of readdirSync(pagesRoot)) {
  const source = join(pagesRoot, pageName);
  if (!statSync(source).isDirectory()) continue;
  cpSync(source, join(outputRoot, pageName), { recursive: true });
}

for (const directory of ["analysis-code", "data", "downloads", "examples"]) {
  cpSync(join(projectRoot, directory), join(outputRoot, directory), { recursive: true });
}

for (const filename of ["LICENSE", "ROI_RESOURCES.md"]) {
  copyFileSync(join(projectRoot, filename), join(outputRoot, basename(filename)));
}

console.log(`Built static site in ${outputRoot}`);
