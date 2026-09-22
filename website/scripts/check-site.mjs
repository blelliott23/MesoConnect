#!/usr/bin/env node

/*
 * Dependency-free checks for the static MesoConnect website.
 * Run from the repository root with: npm run check
 */

import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { extname, join, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const projectRoot = resolve(process.cwd());
const siteRoot = join(projectRoot, "dist");
const problems = [];
let checkedLinks = 0;
let checkedImages = 0;

function walk(directory, excludedNames = new Set()) {
  return readdirSync(directory).flatMap((name) => {
    if (excludedNames.has(name)) return [];
    const path = join(directory, name);
    return statSync(path).isDirectory() ? walk(path, excludedNames) : [path];
  });
}

function localTarget(url, sourceFile) {
  const withoutHash = url.split("#", 1)[0].split("?", 1)[0];
  if (!withoutHash || /^(?:[a-z]+:|\/\/)/i.test(withoutHash)) return null;

  let target = withoutHash.startsWith("/")
    ? resolve(siteRoot, withoutHash.slice(1))
    : resolve(sourceFile, "..", withoutHash);

  if (withoutHash === "/" || withoutHash.endsWith("/")) {
    target = join(target, "index.html");
  }
  return target;
}

if (!existsSync(siteRoot)) {
  console.error("Site check failed: dist/ does not exist. Run npm run build first.");
  process.exit(1);
}

const siteFiles = walk(siteRoot);
const htmlFiles = siteFiles.filter((path) => extname(path) === ".html");

for (const file of htmlFiles) {
  const html = readFileSync(file, "utf8");
  const relativeFile = file.slice(siteRoot.length + 1);

  const ids = [...html.matchAll(/\sid=["']([^"']+)["']/g)].map((match) => match[1]);
  const duplicateIds = [...new Set(ids.filter((id, index) => ids.indexOf(id) !== index))];
  if (duplicateIds.length) problems.push(`${relativeFile}: duplicate IDs: ${duplicateIds.join(", ")}`);

  for (const match of html.matchAll(/<(?:a|link|script|img)\b[^>]*?\s(?:href|src)=["']([^"']+)["'][^>]*>/g)) {
    const url = match[1];
    const target = localTarget(url, file);
    if (!target) continue;
    checkedLinks += 1;
    if (!existsSync(target)) problems.push(`${relativeFile}: missing local target ${url}`);
  }

  for (const match of html.matchAll(/<img\b[^>]*>/g)) {
    checkedImages += 1;
    if (!/\salt=["'][^"']*["']/.test(match[0])) problems.push(`${relativeFile}: image is missing an alt attribute`);
  }
}

const sourceFiles = walk(projectRoot, new Set([".git", ".vercel", "dist", "node_modules"]));
const shellFiles = sourceFiles.filter((path) => extname(path) === ".sh");
for (const shellFile of shellFiles) {
  const shellCheck = spawnSync("bash", ["-n", shellFile], { encoding: "utf8" });
  if (shellCheck.status !== 0) {
    problems.push(`${shellFile.slice(projectRoot.length + 1)}: shell syntax failed: ${shellCheck.stderr.trim()}`);
  }
}

const pythonFiles = sourceFiles.filter((path) => extname(path) === ".py");
for (const pythonFile of pythonFiles) {
  const source = readFileSync(pythonFile, "utf8");
  const pythonCheck = spawnSync(
    "python3",
    ["-c", "import sys; compile(sys.stdin.read(), sys.argv[1], 'exec')", pythonFile],
    { encoding: "utf8", input: source },
  );
  if (pythonCheck.status !== 0) {
    problems.push(`${pythonFile.slice(projectRoot.length + 1)}: Python syntax failed: ${pythonCheck.stderr.trim()}`);
  }
}

if (problems.length) {
  console.error(`Site check failed with ${problems.length} problem(s):`);
  problems.forEach((problem) => console.error(`- ${problem}`));
  process.exit(1);
}

console.log(
  `Site check passed: ${htmlFiles.length} HTML files, ${checkedLinks} local references, ${checkedImages} images, ` +
    `${shellFiles.length} shell scripts, and ${pythonFiles.length} Python scripts.`,
);
