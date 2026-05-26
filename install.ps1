param(
    [string]$Destination = "$env:USERPROFILE\.agents\skills"
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetRoot = $Destination

Write-Host "This will install skill-ai-mode into your global AI skills folder: $targetRoot"
Write-Host "It copies the planning and developer skill files into `.agents\skills\planning-mode\SKILL.md` and `.agents\skills\developer-mode\SKILL.md`."
$confirmation = Read-Host "Do you want to install? (y/n)"
if ($confirmation -notin @('y', 'Y', 'yes', 'YES')) {
    Write-Host "Install cancelled."
    exit 0
}

if (-not (Test-Path $targetRoot)) {
    New-Item -ItemType Directory -Path $targetRoot | Out-Null
}


$skillMap = @(
    @{ Source = 'gemini.md'; Destination = 'gemini.md' },
    @{ Source = '.agents\skills\planning-mode\SKILL.md'; Destination = 'planning-mode\SKILL.md' },
    @{ Source = '.agents\skills\developer-mode\SKILL.md'; Destination = 'developer-mode\SKILL.md' }
)

foreach ($item in $skillMap) {
    $source = Join-Path $repoRoot $item.Source
    if (-not (Test-Path $source)) {
        throw "Missing source file: $($item.Source)"
    }

    $destination = Join-Path $targetRoot $item.Destination
    $destinationDir = Split-Path -Parent $destination
    if (-not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir | Out-Null
    }

    Copy-Item -Path $source -Destination $destination -Force
}

Write-Host "Installed skill-ai-mode to $targetRoot"
Write-Host "Install complete. Configure your AI CLI/editor to read `$env:USERPROFILE\.agents\skills`."
