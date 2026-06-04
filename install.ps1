param(
    [string]$Destination = "$env:USERPROFILE\.agents\skills",
    [string]$GeminiCommandsDestination = "$env:USERPROFILE\.gemini\commands",
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repoOwner = 'NiessenWaffer'
$repoName = 'skill-ai-mode'
$branch = 'main'
$archiveUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$branch.zip"

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("skill-ai-mode-" + [Guid]::NewGuid().ToString('N'))
$zipPath = Join-Path $tempRoot 'repo.zip'
$extractPath = Join-Path $tempRoot 'extract'

Write-Host "This will install skill-ai-mode into your global AI skills folder: $Destination"
Write-Host "It will also install Gemini CLI slash commands into: $GeminiCommandsDestination"
Write-Host "It downloads the GitHub repo archive, copies gemini.md plus the full Planning, Developer, and Debugging mode folders recursively, and generates Gemini .toml command files."
if (-not $Yes) {
    $confirmation = Read-Host "Do you want to install? (y/n)"
    if ($confirmation -notin @('y', 'Y', 'yes', 'YES')) {
        Write-Host "Install cancelled."
        exit 0
    }
}

New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
New-Item -ItemType Directory -Path $extractPath -Force | Out-Null

try {
    Invoke-WebRequest -Uri $archiveUrl -OutFile $zipPath

    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    $repoSource = Get-ChildItem -Path $extractPath -Directory | Select-Object -First 1
    if (-not $repoSource) {
        throw 'Unable to locate extracted repository contents.'
    }

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $copyPaths = @(
        'gemini.md',
        'Planning mode',
        'Developer mode',
        'Debugging mode',
        'SKILLS_VERSION'
    )

    foreach ($relativePath in $copyPaths) {
        $source = Join-Path $repoSource.FullName $relativePath
        if (-not (Test-Path $source)) {
            throw "Missing source path: $relativePath"
        }

        Copy-Item -Path $source -Destination $Destination -Recurse -Force
    }

    $generator = Join-Path $repoSource.FullName 'scripts\generate-gemini-commands.js'
    if (-not (Test-Path $generator)) {
        throw "Missing Gemini command generator: $generator"
    }
    New-Item -ItemType Directory -Path $GeminiCommandsDestination -Force | Out-Null
    node $generator $GeminiCommandsDestination

    Write-Host "Installed skill-ai-mode to $Destination"
    Write-Host "Installed Gemini slash commands to $GeminiCommandsDestination"
    if (Test-Path (Join-Path $Destination 'SKILLS_VERSION')) {
        $ver = Get-Content -Raw (Join-Path $Destination 'SKILLS_VERSION')
        Write-Host ("Skills version: {0}" -f ($ver.Trim()))
    }
    Write-Host "Install complete. In Gemini CLI, run /commands reload, then use /planning, /developer, or /debug."
}
finally {
    if (Test-Path $tempRoot) {
        Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
    }
}
