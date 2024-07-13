if([Environment]::Is64BitOperatingSystem) {
    $jsonContent = Get-Content 'C:\PhpVM\src\list_x64.json' | ConvertFrom-Json
    $os = "x64"
} else {
    $jsonContent = Get-Content 'C:\PhpVM\src\list_x86.json' | ConvertFrom-Json
    $os = "x86"
}

$versions = $jsonContent.versions

# Exiba cada versão

Write-Host "All versions is Thread Safe"
Write-Host "System: $os"

foreach ($version in $versions) {
    $name = $version.name
    $ver = $version.version
    if(Test-Path -Path "C:\PhpVM\versions\$name") {
        Write-Host " $name ($ver)" -ForegroundColor Green
    } else {
        Write-Host " $name ($ver)"
    }
}