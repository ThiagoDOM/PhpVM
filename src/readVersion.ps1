if ([Environment]::Is64BitOperatingSystem) {
    try {
        $web_client = new-object system.net.webclient
        $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x64.json") | ConvertFrom-Json
    }
    catch {
        $jsonContent = Get-Content 'C:\PhpVM\src\list_x64.json' | ConvertFrom-Json
    }
}
else {
    try {
        $web_client = new-object system.net.webclient
        $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x86.json") | ConvertFrom-Json 2>$null
    }
    catch {
        $jsonContent = Get-Content 'C:\PhpVM\src\list_x86.json' | ConvertFrom-Json
    }
}

$selVersion = $args[0]
$url = $null
$versions = $jsonContent.versions

foreach ($version in $versions) {
    $name = $version.name
    if ($name -eq $selVersion) {
        $ver = $version.version
        $url = $version.url
    }
}

if ($url) {
    if ($url -Match "x64") {
        Write-Host "Version: $ver x64"
    }
    else {
        Write-Host "Version: $ver x86"
    }
}
else {
    Write-Host "Version not found"
}

return $url