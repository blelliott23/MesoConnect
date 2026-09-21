#!/usr/bin/env node

/*
 * Dependency-free checks for the static MesoConnect website.
 * Run from the repository root with: node scripts/check-site.mjs
 */

import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { extname, join, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const root = resolve(process.cwd());
const problems = [];
let checkedLinks = 0;
let checkedImages = 0;

function walk(directory) {
  return readdirSync(directory).flatMap((name) => {
    if (name === ".git" || name === "node_modules") return [];
    const path = join(directory, name);
    return statSync(path).isDirectory() ? walk(path) : [path];
  });
}

function localTarget(url) {
  const withoutHash = url.split("#", 1)[0].split("?", 1)[0];
  if (!withoutHash || /^(?:[a-z]+:|\/\/)/i.test(withoutHash)) return null;

  const relative = withoutHash.startsWith("/") ? withoutHash.slice(1) : withoutHash;
  let target = resolve(root, relative);

  if (withoutHash === "/" || withoutHash.endsWith("/")) target = join(target, "index.html");
  return target;
}

const files = walk(root);
const htmlFiles = files.filter((path) => extname(path) === ".html");

for (const file of htmlFiles) {
  const html = readFileSync(file, "utf8");
  const relativeFile = file.slice(root.length + 1);

  const ids = [...html.matchAll(/\sid=["']([^"']+)["']/g)].map((match) => match[1]);
  const duplicateIds = [...new Set(ids.filter((id, index) => ids.indexOf(id) !== index))];
  if (duplicateIds.length) problems.push(`${relativeFile}: duplicate IDs: ${duplicateIds.join(", ")}`);

  for (const match of html.matchAll(/<(?:a|link|script|img)\b[^>]*?\s(?:href|src)=["']([^"']+)["'][^>]*>/g)) {
    const url = match[1];
    const target = localTarget(url);
    if (!target) continue;
    checkedLinks += 1;
    if (!existsSync(target)) problems.push(`${relativeFile}: missing local target ${url}`);
  }

  for (const match of html.matchAll(/<img\b[^>]*>/g)) {
    checkedImages += 1;
    if (!/\salt=["'][^"']*["']/.test(match[0])) problems.push(`${relativeFile}: image is missing an alt attribute`);
  }
}

const scriptPath = join(root, "examples", "mesoconnect_inferior_vta_nac_template.sh");
if (!existsSync(scriptPath)) {
  problems.push("Missing annotated shell example.");
} else {
  const shellCheck = spawnSync("bash", ["-n", scriptPath], { encoding: "utf8" });
  if (shellCheck.status !== 0) problems.push(`Shell syntax check failed: ${shellCheck.stderr.trim()}`);
}

if (problems.length) {
  console.error(`Site check failed with ${problems.length} problem(s):`);
  problems.forEach((problem) => console.error(`- ${problem}`));
  process.exit(1);
}

console.log(`Site check passed: ${htmlFiles.length} HTML files, ${checkedLinks} local references, ${checkedImages} images, and shell syntax.`);

