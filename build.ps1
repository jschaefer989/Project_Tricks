param(
    [string]$OutDir = "build"
)

$ws = Split-Path -Path $PSScriptRoot -Leaf
$outPath = Join-Path -Path $PSScriptRoot -ChildPath $OutDir
if (-not (Test-Path $outPath)) { New-Item -ItemType Directory -Path $outPath | Out-Null }
$name = "$ws.love"
$zipPath = Join-Path -Path $outPath -ChildPath $name

if (Test-Path $zipPath) { Remove-Item -Force $zipPath }

# Exclude common dev files/folders
$exclude = @('.git', '.vscode', '.luacheckrc')

# Collect items while excluding dev folders/files. Avoid using 'return' inside the Where-Object scriptblock
$items = Get-ChildItem -Path $PSScriptRoot -Recurse -Force | Where-Object {
    $fullname = $_.FullName
    $keep = $true
    foreach ($e in $exclude) {
        if ($fullname -like "*\\$e*") { $keep = $false; break }
    }
    $keep
}

$paths = $items | ForEach-Object { $_.FullName }
if (@($paths).Count -eq 0) {
    Write-Error "Nothing to archive. Check exclusions and workspace contents."
    exit 1
}

try {
    # Use a temp file location to avoid locks by antivirus or other processes scanning the build folder.
    $tmpName = [System.IO.Path]::GetRandomFileName()
    $zipTmp = Join-Path -Path $env:TEMP -ChildPath ($tmpName + '.zip')
    if (Test-Path $zipTmp) { Remove-Item -Force $zipTmp }
    Compress-Archive -Path $paths -DestinationPath $zipTmp -Force -ErrorAction Stop

    # Move temp zip to final .love location with a few retries in case of transient locks
    $maxAttempts = 6
    $attempt = 0
    $moved = $false
    while (-not $moved -and $attempt -lt $maxAttempts) {
        try {
            if (Test-Path $zipPath) { Remove-Item -Force $zipPath -ErrorAction SilentlyContinue }
            Move-Item -Force $zipTmp $zipPath -ErrorAction Stop
            $moved = $true
        } catch {
            $attempt++
            Start-Sleep -Milliseconds (200 * $attempt)
        }
    }

    if ($moved) {
        Write-Host "Created: $zipPath"
    } else {
        Write-Error "Failed to move zip to .love after $maxAttempts attempts. The temp file is: $zipTmp"
        if (Test-Path $zipTmp) { Write-Host "Temp zip remains at: $zipTmp" }
        exit 1
    }

} catch {
    Write-Error "Compression failed: $_"
    exit 1
}