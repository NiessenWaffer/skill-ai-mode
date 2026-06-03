#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=${PROJECT_ROOT:-"$(pwd)"}
PLAN_UNIT=${PLAN_UNIT:-"List plan/plan1"}
SKILLS_DIR=${AI_SKILLS_DIR:-"$HOME/.agents/skills"}

GEMINI="$SKILLS_DIR/gemini.md"
PLANNING_KERNEL="$SKILLS_DIR/Planning mode/Planning.md"

if [[ ! -f "$GEMINI" ]]; then echo "Missing skills file: $GEMINI" >&2; exit 1; fi
if [[ ! -f "$PLANNING_KERNEL" ]]; then echo "Missing skills file: $PLANNING_KERNEL" >&2; exit 1; fi

GUID=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || date +%s)
SYSTEM_FILE="${TMPDIR:-/tmp}/planning-system-${GUID}.txt"
USER_FILE="${TMPDIR:-/tmp}/planning-user-${GUID}.txt"

{
  echo "# SYSTEM: Global Skills (Read-Only)";
  echo "# Files: gemini.md + Planning mode/Planning.md";
  echo;
  cat "$GEMINI";
  echo;
  cat "$PLANNING_KERNEL";
} > "$SYSTEM_FILE"

ENV_BLOCK="skills_dir=$SKILLS_DIR; project_root=$PROJECT_ROOT; plan_unit=$PLAN_UNIT"
{
  echo "/planning";
  echo "ENV: $ENV_BLOCK";
  echo "EXPECTATION: progressive phase-by-phase reading; no all-at-once; artifacts project-local only (List plan/*)";
} > "$USER_FILE"

printf "SYSTEM_FILE=%s\n" "$SYSTEM_FILE"
printf "USER_FILE=%s\n" "$USER_FILE"
echo "Next: Use your AI CLI to send a system message from SYSTEM_FILE and a user message from USER_FILE."
echo "Tip: export AI_PROVIDER to hint formatting; export AI_SKILLS_DIR to override skills location."
