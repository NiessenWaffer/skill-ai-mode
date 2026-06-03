@echo off
setlocal

rem Resolve available PowerShell executable (pwsh preferred, fallback to Windows PowerShell)
where pwsh >nul 2>&1
if %ERRORLEVEL%==0 (
  set "PS=pwsh"
) else (
  where powershell >nul 2>&1
  if %ERRORLEVEL%==0 (
    set "PS=powershell"
  ) else (
    echo Neither pwsh nor powershell found on PATH. Please install PowerShell.
    exit /b 1
  )
)

set "TMPPS=%TEMP%\skill-ai-mode-install-%RANDOM%-%RANDOM%.ps1"

%PS% -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.ps1' -OutFile '%TMPPS%'; } catch { Write-Error $_; exit 1 }"
if errorlevel 1 (
  echo Failed to download installer script from GitHub.
  exit /b 1
)

%PS% -NoProfile -ExecutionPolicy Bypass -File "%TMPPS%" %*
set "ERR=%ERRORLEVEL%"

if exist "%TMPPS%" del /q "%TMPPS%" >nul 2>&1

endlocal & exit /b %ERR%
