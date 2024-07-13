if ([Environment]::Is64BitOperatingSystem) {
    $jsonContent = Get-Content 'C:\multiphp\bin\src\list_x64.json' | ConvertFrom-Json
    $os = "x64"
}
else {
    $jsonContent = Get-Content 'C:\multiphp\bin\src\list_x86.json' | ConvertFrom-Json
    $os = "x86"
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
    if($url -Match "x64") {
        Write-Host "Version: $ver x64"
    } else {
        Write-Host "Version: $ver x86"
    }
    # Write-Host "URL: $url"
} else {
    Write-Host "Version not found"
}

return $url