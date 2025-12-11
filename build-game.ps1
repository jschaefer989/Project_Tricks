Write-Host "Compiling TypeScript..." -ForegroundColor Cyan
$output = cmd /c "npx tstl 2>&1"
Write-Output $output
if ($LASTEXITCODE -ne 0) {
    Write-Error "TypeScript compilation failed"
    exit 1
}

Write-Host "Building .love file..." -ForegroundColor Cyan
& "$PSScriptRoot\build.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed"
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green
