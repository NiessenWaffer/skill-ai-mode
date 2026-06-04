#!/usr/bin/env node

const inquirer = require('inquirer');
const fs = require('fs-extra');
const path = require('path');
const os = require('os');
const fetch = require('node-fetch');
const AdmZip = require('adm-zip');

const DEFAULT_DEST = path.join(os.homedir(), '.agents', 'skills');
const DEFAULT_GEMINI_COMMANDS_DEST = path.join(os.homedir(), '.gemini', 'commands');
const REPO_URL = 'https://github.com/NiessenWaffer/skill-ai-mode/archive/refs/heads/main.zip';

async function main() {
  console.log('AI Skill Installer for skill-ai-mode');
  const dest = DEFAULT_DEST;
  const geminiCommandsDest = process.env.GEMINI_COMMANDS_DIR || DEFAULT_GEMINI_COMMANDS_DEST;
  console.log(`Install destination is locked to: ${dest}`);
  console.log(`Gemini command destination is: ${geminiCommandsDest}`);

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
  for (const rel of ['gemini.md', 'Planning mode', 'Developer mode', 'Debugging mode', 'SKILLS_VERSION']) {
    const src = path.join(os.tmpdir(), extracted, rel);
    if (!fs.existsSync(src)) throw new Error(`Missing source: ${src}`);
    fs.copySync(src, path.join(dest, rel));
  }

  const generator = path.join(os.tmpdir(), extracted, 'scripts', 'generate-gemini-commands.js');
  if (!fs.existsSync(generator)) throw new Error(`Missing Gemini command generator: ${generator}`);
  const oldArgv = process.argv;
  process.argv = [process.execPath, generator, geminiCommandsDest];
  require(generator);
  process.argv = oldArgv;

  fs.removeSync(tmpZip);

  console.log(`Installed skill-ai-mode to ${dest}`);
  console.log(`Installed Gemini slash commands to ${geminiCommandsDest}`);
  console.log('In Gemini CLI, run /commands reload, then use /planning, /developer, or /debug.');
}

main().catch(err => {
  console.error('Install failed:', err);
  process.exit(1);
});
