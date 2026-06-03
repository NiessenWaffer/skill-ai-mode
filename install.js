#!/usr/bin/env node

const inquirer = require('inquirer');
const fs = require('fs-extra');
const path = require('path');
const os = require('os');
const fetch = require('node-fetch');
const AdmZip = require('adm-zip');

const DEFAULT_DEST = path.join(os.homedir(), '.agents', 'skills');
const REPO_URL = 'https://github.com/NiessenWaffer/skill-ai-mode/archive/refs/heads/main.zip';

async function main() {
  console.log('AI Skill Installer for skill-ai-mode');
  const dest = DEFAULT_DEST;
console.log(`Install destination is locked to: ${dest}`);

  const tmpZip = path.join(os.tmpdir(), `skill-ai-mode-${Date.now()}.zip`);
  console.log('Downloading latest skill-ai-mode...');
  const res = await fetch(REPO_URL);
  const fileStream = fs.createWriteStream(tmpZip);
  await new Promise((resolve, reject) => {
    res.body.pipe(fileStream);
    res.body.on('error', reject);
    fileStream.on('finish', resolve);
  });

  const zip = new AdmZip(tmpZip);
  zip.extractAllTo(os.tmpdir(), true);

  // Find extracted folder
  const extracted = fs.readdirSync(os.tmpdir())
    .find(f => f.startsWith('skill-ai-mode') && fs.existsSync(path.join(os.tmpdir(), f, 'gemini.md')));
  if (!extracted) throw new Error('Extracted folder not found!');

  // Copy core files/folders
  for (const rel of ['gemini.md', 'Planning mode', 'Developer mode']) {
    const src = path.join(os.tmpdir(), extracted, rel);
    if (!fs.existsSync(src)) throw new Error(`Missing source: ${src}`);
    fs.copySync(src, path.join(dest, rel));
  }
  fs.removeSync(tmpZip);

  console.log(`Installed skill-ai-mode to ${dest}`);
  console.log('Configure your AI CLI/editor to read this folder.');
}

main().catch(err => {
  console.error('Install failed:', err);
  process.exit(1);
});
