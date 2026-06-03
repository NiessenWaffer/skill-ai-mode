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
$planningKernel = Join-Path $SkillsDir 'Planning mode/Planning.md'
if (-not (Test-Path $gemini)) { throw "Missing skills file: $gemini" }
if (-not (Test-Path $planningKernel)) { throw "Missing skills file: $planningKernel" }

# Prepare temp files
$guid = [Guid]::NewGuid().ToString('N')
$systemPath = Join-Path $env:TEMP ("planning-system-" + $guid + ".txt")
$userPath   = Join-Path $env:TEMP ("planning-user-" + $guid + ".txt")

# Build system prompt (skills)
@(
  "# SYSTEM: Global Skills (Read-Only)",
  "# Files: gemini.md + Planning mode/Planning.md",
  "",
  (Get-Content -Raw $gemini),
  "",
  (Get-Content -Raw $planningKernel)
) | Set-Content -NoNewline:$false -Encoding UTF8 $systemPath

# Build user message (command + environment)
$envBlock = @(
  "skills_dir=$SkillsDir",
  "project_root=$ProjectRoot",
  "plan_unit=$PlanUnit"
) -join '; '

@(
  "/planning",
  "ENV: $envBlock",
  "EXPECTATION: progressive phase-by-phase reading; no all-at-once; artifacts project-local only (List plan/*)"
) | Set-Content -NoNewline:$false -Encoding UTF8 $userPath

Write-Host "SYSTEM_FILE=$systemPath"
Write-Host "USER_FILE=$userPath"
Write-Host "Next: Use your AI CLI to send a system message from SYSTEM_FILE and a user message from USER_FILE."
Write-Host "Tip: Set AI_PROVIDER for formatting hints; set AI_SKILLS_DIR to override skills location."
