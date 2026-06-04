#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const outDir = path.resolve(process.argv[2] || path.join(repoRoot, '.gemini', 'commands'));

const commands = [
  {
    name: 'planning',
    description: 'Start skill-ai-mode Planning mode.',
    files: [
      'gemini.md',
      'Planning mode/Planning.md',
      'Planning mode/RULE_INDEX.md',
      'Planning mode/rules/intent-assumption-validator.md',
      'Planning mode/rules/artifact-read-policy.md',
      'Planning mode/rules/section-action-data-state.md',
      'Planning mode/rules/design-page-first.md',
      'Planning mode/rules/dependency-maturity.md',
      'Planning mode/rules/circumstance-branching.md',
      'Planning mode/rules/workflow-precision.md',
      'Planning mode/rules/workflow-logic.md',
      'Planning mode/rules/vertical-slice-workflow.md',
      'Planning mode/rules/planning-quality-policy.md',
      'Planning mode/rules/execution-handoff-policy.md',
      'Planning mode/rules/plan-selection.md'
    ],
    expectation: 'Run the planning lifecycle progressively and create or revise List plan/ artifacts only.'
  },
  {
    name: 'developer',
    description: 'Start skill-ai-mode Developer mode.',
    files: [
      'gemini.md',
      'Developer mode/developer.md',
      'Developer mode/RULE_INDEX.md',
      'Developer mode/implementation rules/runtime-safety.md',
      'Developer mode/implementation rules/alignment-policy.md',
      'Developer mode/implementation rules/checked-item-protection.md',
      'Developer mode/implementation rules/verification-ladder.md',
      'Developer mode/implementation rules/approval-flow-clarity.md',
      'Developer mode/implementation rules/input-task-policy.md',
      'Developer mode/implementation rules/implementation-pipeline-policy.md',
      'Developer mode/implementation rules/task-execution-update-policy.md',
      'Developer mode/implementation rules/report-policy.md',
      'Developer mode/implementation rules/code-diff-discipline.md',
      'Developer mode/implementation rules/frontend.md',
      'Developer mode/implementation rules/backend.md',
      'Developer mode/implementation rules/database.md',
      'Developer mode/implementation rules/controls-routing.md',
      'Developer mode/implementation rules/seeders.md',
      'Developer mode/implementation rules/testing.md'
    ],
    expectation: 'Run the implementation pipeline from an approved plan/workflow; generate or patch task.md before code changes.'
  },
  {
    name: 'debug',
    description: 'Start skill-ai-mode Debugging mode.',
    files: [
      'gemini.md',
      'Debugging mode/debugger.md',
      'Debugging mode/RULE_INDEX.md',
      'Debugging mode/rules/triage-intake.md',
      'Debugging mode/rules/repro-harness.md',
      'Debugging mode/rules/root-cause-hypothesis.md',
      'Debugging mode/rules/instrumentation-logging.md',
      'Debugging mode/rules/minimal-delta-fix.md',
      'Debugging mode/rules/verification-debug.md',
      'Debugging mode/rules/rollback-guard.md'
    ],
    expectation: 'Run the focused debugging lifecycle and record findings in List plan/plan{n}/debug.md.'
  }
];

function readSkillFile(relativePath) {
  const fullPath = path.join(repoRoot, relativePath);
  if (!fs.existsSync(fullPath)) {
    throw new Error(`Missing source file: ${relativePath}`);
  }
  return fs.readFileSync(fullPath, 'utf8').replace(/\r\n/g, '\n');
}

function tomlString(value) {
  if (value.includes('"""')) {
    throw new Error('TOML generator cannot safely emit prompts containing triple double quotes.');
  }
  return `"""${value.replace(/\r\n/g, '\n')}"""`;
}

function buildPrompt(command) {
  const sections = command.files.map((relativePath) => {
    return `## File: ${relativePath}\n\n${readSkillFile(relativePath).trimEnd()}`;
  });

  return [
    `# skill-ai-mode: /${command.name}`,
    '',
    'Treat the following embedded files as read-only source-of-truth instructions for this mode.',
    'Apply them inside the current Gemini workspace. Project artifacts must stay in the user project, not in the Gemini commands folder.',
    '',
    `EXPECTATION: ${command.expectation}`,
    '',
    sections.join('\n\n---\n\n'),
    '',
    '# User arguments',
    '',
    '{{args}}'
  ].join('\n');
}

fs.mkdirSync(outDir, { recursive: true });

for (const command of commands) {
  const body = [
    `description = ${JSON.stringify(command.description)}`,
    '',
    `prompt = ${tomlString(buildPrompt(command))}`,
    ''
  ].join('\n');

  fs.writeFileSync(path.join(outDir, `${command.name}.toml`), body, 'utf8');
}

console.log(`Generated Gemini commands in ${outDir}`);
