#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=${PROJECT_ROOT:-"$(pwd)"}
PLAN_UNIT=${PLAN_UNIT:-"List plan/plan1"}
SKILLS_DIR=${AI_SKILLS_DIR:-"$HOME/.agents/skills"}

GEMINI="$SKILLS_DIR/gemini.md"
DEV_KERNEL="$SKILLS_DIR/Developer mode/developer.md"

if [[ ! -f "$GEMINI" ]]; then echo "Missing skills file: $GEMINI" >&2; exit 1; fi
if [[ ! -f "$DEV_KERNEL" ]]; then echo "Missing skills file: $DEV_KERNEL" >&2; exit 1; fi

GUID=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || date +%s)
SYSTEM_FILE="${TMPDIR:-/tmp}/developer-system-${GUID}.txt"
USER_FILE="${TMPDIR:-/tmp}/developer-user-${GUID}.txt"

{
  echo "# SYSTEM: Global Skills (Read-Only)";
  echo "# Files: gemini.md + Developer mode/developer.md";
  echo;
  cat "$GEMINI";
  echo;
  cat "$DEV_KERNEL";
} > "$SYSTEM_FILE"

ENV_BLOCK="skills_dir=$SKILLS_DIR; project_root=$PROJECT_ROOT; plan_unit=$PLAN_UNIT"
{
  echo "/developer";
  echo "ENV: $ENV_BLOCK";
  echo "EXPECTATION: staged pipeline; task.md generation gate; do not edit plan.md|workflow.md";
} > "$USER_FILE"

printf "SYSTEM_FILE=%s\n" "$SYSTEM_FILE"
printf "USER_FILE=%s\n" "$USER_FILE"
echo "Next: Use your AI CLI to send a system message from SYSTEM_FILE and a user message from USER_FILE."
echo "Tip: export AI_PROVIDER to hint formatting; export AI_SKILLS_DIR to override skills location."

# If a provider-agnostic CLI template is provided, print a ready-to-run command
if [[ -n "${AI_CLI_TEMPLATE:-}" ]]; then
  model="${MODEL:-}"
  if [[ -z "$model" ]]; then
    case "${AI_PROVIDER:-}" in
      anthropic|claude) model="${ANTHROPIC_MODEL:-claude-3-opus-20240229}" ;;
      openai|gpt)      model="${OPENAI_MODEL:-gpt-4o}" ;;
      gemini|google)   model="${GEMINI_MODEL:-gemini-1.5-pro}" ;;
      *)               model="generic" ;;
    esac
  fi
  cmd="$AI_CLI_TEMPLATE"
  cmd="${cmd//\{SYSTEM_FILE\}/$SYSTEM_FILE}"
  cmd="${cmd//\{USER_FILE\}/$USER_FILE}"
  cmd="${cmd//\{MODEL\}/$model}"
  echo "COMMAND=$cmd"
fi
