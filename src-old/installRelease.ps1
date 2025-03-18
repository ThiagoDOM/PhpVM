$web_client = new-object system.net.webclient
$web_client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3")
$jsonContent = $web_client.DownloadString("https://windows.php.net/downloads/releases/releases.json?1") | ConvertFrom-Json 2>$null

function Show-Menu {
    param (
        [string[]]$options,
        [string[]]$base,
        [int]$selectedIndex = 0
    )

    $optionsCount = $options.Count
    $lastIndex = $selectedIndex

    while ($true) {
        Clear-Host
        if ($base) {
            Write-Host "Choose between Thread Safe(TS) and Non TS(NTS) and x64 or x86"
        } else {
            Write-Host "Choose a PHP version"
        }
        for ($i = 0; $i -lt $optionsCount; $i++) {
            if ($base) {
                if ($i -eq $selectedIndex) {
                    Write-Host "> $base - $($options[$i])" -ForegroundColor Cyan
                } else {
                    Write-Host "  $base - $($options[$i])"
                } 
            } else {
                if ($i -eq $selectedIndex) {
                    Write-Host "> $($options[$i])" -ForegroundColor Cyan
                } else {
                    Write-Host "  $($options[$i])"
                } 
            }
        }

        $key = [console]::ReadKey($true).Key
        switch ($key) {
            "UpArrow" {
                $selectedIndex = if ($selectedIndex -gt 0) { $selectedIndex - 1 } else { $optionsCount - 1 }
            }
            "DownArrow" {
                $selectedIndex = if ($selectedIndex -lt ($optionsCount - 1)) { $selectedIndex + 1 } else { 0 }
            }
            "Enter" {
                return $selectedIndex
            }
        }
    }
}

$options = $jsonContent.PSObject.Properties.Name
$selectedIndex = Show-Menu -options $options

$version = $($options[$selectedIndex])
$folderName = $version -replace "\.", "" # Important

$selectedVersion = $jsonContent."$version"
$base = $selectedVersion.version
$selectedVersion.PSObject.Properties.Remove("version")
$selectedVersion.PSObject.Properties.Remove("source")
$selectedVersion.PSObject.Properties.Remove("test_pack")

$optionsVariants = $selectedVersion.PSObject.Properties.Name
$selectedVariantIdx = Show-Menu -options $optionsVariants $base
$variant = $($optionsVariants[$selectedVariantIdx])
Write-Host $($optionsVariants[$selectedVariantIdx])

$path = $selectedVersion."$variant"."zip"."path"
$url = "https://windows.php.net/downloads/releases/$path" # Important

if ($path) {
    # Start Install/Update process
    Write-Host "Installing/Updating version $base..." -ForegroundColor Green
    Write-Host "Downloading from $url"

    $url = iex "${global:basePath}src\updateVersion.ps1 $folderName $url" 
} else {
    # Display error
    Write-Host "An error occurred" -ForegroundColor Red
}