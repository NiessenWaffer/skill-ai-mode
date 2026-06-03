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
$debugKernel = Join-Path $SkillsDir 'Debugging mode/debugger.md'
if (-not (Test-Path $gemini)) { throw "Missing skills file: $gemini" }
if (-not (Test-Path $debugKernel)) { throw "Missing skills file: $debugKernel" }

# Prepare temp files
$guid = [Guid]::NewGuid().ToString('N')
$systemPath = Join-Path $env:TEMP ("debug-system-" + $guid + ".txt")
$userPath   = Join-Path $env:TEMP ("debug-user-" + $guid + ".txt")

# Build system prompt (skills)
@(
  "# SYSTEM: Global Skills (Read-Only)",
  "# Files: gemini.md + Debugging mode/debugger.md",
  "",
  (Get-Content -Raw $gemini),
  "",
  (Get-Content -Raw $debugKernel)
) | Set-Content -NoNewline:$false -Encoding UTF8 $systemPath

# Build user message (command + environment)
$envBlock = @(
  "skills_dir=$SkillsDir",
  "project_root=$ProjectRoot",
  "plan_unit=$PlanUnit"
) -join '; '

@(
  "/debug",
  "ENV: $envBlock",
  "EXPECTATION: focused debug lifecycle; read existing plan/workflow; propose revisions in debug.md; escalate to Planning to apply"
) | Set-Content -NoNewline:$false -Encoding UTF8 $userPath

Write-Host "SYSTEM_FILE=$systemPath"
Write-Host "USER_FILE=$userPath"
Write-Host "Next: Use your AI CLI to send a system message from SYSTEM_FILE and a user message from USER_FILE."
Write-Host "Tip: Set AI_PROVIDER for formatting hints; set AI_SKILLS_DIR to override skills location."

# Provider-agnostic ready-to-run command
$template = $env:AI_CLI_TEMPLATE
if ($template -and $template.Trim().Length -gt 0) {
  $provider = $env:AI_PROVIDER
  $model = $env:MODEL
  if (-not $model -or $model.Trim().Length -eq 0) {
    switch -Regex ($provider) {
      'anthropic|claude' { $model = $env:ANTHROPIC_MODEL; if (-not $model) { $model = 'claude-3-opus-20240229' } }
      'openai|gpt' { $model = $env:OPENAI_MODEL; if (-not $model) { $model = 'gpt-4o' } }
      'gemini|google' { $model = $env:GEMINI_MODEL; if (-not $model) { $model = 'gemini-1.5-pro' } }
      default { $model = 'generic' }
    }
  }
  $cmd = $template.Replace('{SYSTEM_FILE}', $systemPath).Replace('{USER_FILE}', $userPath).Replace('{MODEL}', $model)
  Write-Host ("COMMAND=$cmd")
}
