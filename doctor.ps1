param(
  [string]$SkillsDir = $env:AI_SKILLS_DIR,
  [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

if (-not $SkillsDir -or $SkillsDir.Trim().Length -eq 0) {
  $SkillsDir = Join-Path $env:USERPROFILE ".agents/skills"
}

Write-Host "Checking skills directory: $SkillsDir"
if (-not (Test-Path $SkillsDir)) { Write-Error "Skills dir not found: $SkillsDir"; exit 1 }

$required = @(
  'gemini.md',
  'Planning mode/Planning.md',
  'Developer mode/developer.md',
  'Debugging mode/debugger.md'
)

$missing = @()
foreach ($rel in $required) {
  $path = Join-Path $SkillsDir $rel
  if (-not (Test-Path $path)) { $missing += $rel }
}

if ($missing.Count -gt 0) {
  Write-Error ("Missing required skills files/folders: " + ($missing -join ', '))
  exit 1
}

$verPath = Join-Path $SkillsDir 'SKILLS_VERSION'
if (Test-Path $verPath) {
  $ver = (Get-Content -Raw $verPath).Trim()
  Write-Host ("Skills version: {0}" -f $ver)
} else {
  Write-Warning 'SKILLS_VERSION not found (optional)'
}

Write-Host "Scanning project artifacts in: $ProjectRoot"
$artifactRoot = Join-Path $ProjectRoot 'List plan'
if (-not (Test-Path $artifactRoot)) {
  Write-Host "No 'List plan/' found (ok if you haven't run /planning yet)."
  exit 0
}

$plans = Get-ChildItem -Path $artifactRoot -Directory -Filter 'plan*' | Sort-Object Name
if ($plans.Count -eq 0) {
  Write-Host "No plan units (plan{n}) found under 'List plan/'."
  exit 0
}

foreach ($p in $plans) {
  $unit = $p.FullName
  $hasPlan = Test-Path (Join-Path $unit 'plan.md')
  $hasFlow = Test-Path (Join-Path $unit 'workflow.md')
  $hasTask = Test-Path (Join-Path $unit 'task.md')
  $hasDebug = Test-Path (Join-Path $unit 'debug.md')
  Write-Host ("- {0}: plan.md={1} workflow.md={2} task.md={3} debug.md={4}" -f $p.Name, $hasPlan, $hasFlow, $hasTask, $hasDebug)
}

Write-Host 'Doctor checks completed.'
exit 0
