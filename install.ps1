param(
    [string]$Destination = "$env:USERPROFILE\.skill-ai-mode"
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetRoot = $Destination

if (-not (Test-Path $targetRoot)) {
    New-Item -ItemType Directory -Path $targetRoot | Out-Null
}

$paths = @(
    'README.md',
    'gemini.md',
    'Planning mode\planning-skill.md',
    'Developer mode\developer-skill.md'
)

foreach ($relativePath in $paths) {
    $source = Join-Path $repoRoot $relativePath
    if (-not (Test-Path $source)) {
        throw "Missing source file: $relativePath"
    }

    $destination = Join-Path $targetRoot $relativePath
    $destinationDir = Split-Path -Parent $destination
    if (-not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir | Out-Null
    }

    Copy-Item -Path $source -Destination $destination -Force
}

Write-Host "Installed skill-ai-mode to $targetRoot"
Write-Host "Copy or symlink the files from there into your editor's skill folder if needed."
