param(
    [string]$Destination = "$env:USERPROFILE\.agents\skills"
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetRoot = $Destination

Write-Host "This will install skill-ai-mode into your global AI skills folder: $targetRoot"
Write-Host "It copies gemini.md plus the existing Planning mode and Developer mode folders so the rules remain the source of truth."
$confirmation = Read-Host "Do you want to install? (y/n)"
if ($confirmation -notin @('y', 'Y', 'yes', 'YES')) {
    Write-Host "Install cancelled."
    exit 0
}

if (-not (Test-Path $targetRoot)) {
    New-Item -ItemType Directory -Path $targetRoot | Out-Null
}


if (-not (Test-Path (Join-Path $repoRoot 'gemini.md'))) {
    throw 'Missing source file: gemini.md'
}

$copyPaths = @(
    'gemini.md',
    'Planning mode',
    'Developer mode'
)

foreach ($relativePath in $copyPaths) {
    $source = Join-Path $repoRoot $relativePath
    if (-not (Test-Path $source)) {
        throw "Missing source path: $relativePath"
    }

    Copy-Item -Path $source -Destination $targetRoot -Recurse -Force
}

Write-Host "Installed skill-ai-mode to $targetRoot"
Write-Host "Install complete. Configure your AI CLI/editor to read `$env:USERPROFILE\.agents\skills`."
