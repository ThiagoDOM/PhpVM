if ([Environment]::Is64BitOperatingSystem) {
    try {
        $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x64.json") | ConvertFrom-Json
    }
    catch {
        $jsonContent = Get-Content 'C:\PhpVM\src\list_x64.json' | ConvertFrom-Json
    }
    $os = "x64"
}
else {
    try {
        $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x86.json") | ConvertFrom-Json 2>$null
    }
    catch {
        $jsonContent = Get-Content 'C:\PhpVM\src\list_x86.json' | ConvertFrom-Json
    }
    $os = "x86"
}

$versions = $jsonContent.versions

# Exiba cada versão

Write-Host "All versions is Non Thread Safe."
Write-Host "Your system is $os based."

foreach ($version in $versions) {
    $name = $version.name
    $ver = $version.version
    if (Test-Path -Path "C:\PhpVM\versions\$name") {
        Write-Host " $name ($ver)" -ForegroundColor Green
    }
    else {
        Write-Host " $name ($ver)"
    }
}