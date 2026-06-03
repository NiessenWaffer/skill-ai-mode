param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$PlanUnit = "List plan/plan1",
  [string]$SkillsDir = $env:AI_SKILLS_DIR
)

$ErrorActionPreference = 'Stop'

if (-not $SkillsDir -or $SkillsDir.Trim().Length -eq 0) {
  $SkillsDir = Join-Path $env:USERPROFILE ".agents/skills"
}

# Resolve skills files
$gemini = Join-Path $SkillsDir 'gemini.md'
$devKernel = Join-Path $SkillsDir 'Developer mode/developer.md'
if (-not (Test-Path $gemini)) { throw "Missing skills file: $gemini" }
if (-not (Test-Path $devKernel)) { throw "Missing skills file: $devKernel" }

# Prepare temp files
$guid = [Guid]::NewGuid().ToString('N')
$systemPath = Join-Path $env:TEMP ("developer-system-" + $guid + ".txt")
$userPath   = Join-Path $env:TEMP ("developer-user-" + $guid + ".txt")

# Build system prompt (skills)
@(
  "# SYSTEM: Global Skills (Read-Only)",
  "# Files: gemini.md + Developer mode/developer.md",
  "",
  (Get-Content -Raw $gemini),
  "",
  (Get-Content -Raw $devKernel)
) | Set-Content -NoNewline:$false -Encoding UTF8 $systemPath

# Build user message (command + environment)
$envBlock = @(
  "skills_dir=$SkillsDir",
  "project_root=$ProjectRoot",
  "plan_unit=$PlanUnit"
) -join '; '

@(
  "/developer",
  "ENV: $envBlock",
  "EXPECTATION: staged pipeline; task.md generation gate; do not edit plan.md|workflow.md"
) | Set-Content -NoNewline:$false -Encoding UTF8 $userPath

Write-Host "SYSTEM_FILE=$systemPath"
Write-Host "USER_FILE=$userPath"
Write-Host "Next: Use your AI CLI to send a system message from SYSTEM_FILE and a user message from USER_FILE."
Write-Host "Tip: Set AI_PROVIDER for formatting hints; set AI_SKILLS_DIR to override skills location."
