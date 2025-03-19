# basePath
$global:basePath = "C:\PhpVM\"

function ReadVersion {
    param (
        [string]$version
    )

    if ([Environment]::Is64BitOperatingSystem) {
        try {
            $web_client = new-object system.net.webclient
            $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x64.json?12") | ConvertFrom-Json
        }
        catch {
            $jsonContent = Get-Content '${global:basePath}src\list_x64.json' | ConvertFrom-Json
        }
    }
    else {
        try {
            $web_client = new-object system.net.webclient
            $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x86.json?12") | ConvertFrom-Json
        }
        catch {
            $jsonContent = Get-Content '${global:basePath}src\list_x86.json' | ConvertFrom-Json
        }
    }
    
    
    $url = $null
    $versions = $jsonContent.versions
    
    foreach ($sversion in $versions) {
        $name = $sversion.name
        if ($name -eq $version) {
            $ver = $sversion.version
            $url = $sversion.url
        }
    }
    
    if ($url) {
        if ($url -Match "x64") {
            Write-Host "Version $ver x64 found" -ForegroundColor Green
        }
        else {
            Write-Host "Version $ver x86 found" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Version not found: $sversion.name" -ForegroundColor Red
    }
    
    return $url    
}

function UpdateVersion {
    param (
        [string]$version,
        [string]$customUrl
    )

    if ($version) {
        $destinationPath = "${global:basePath}versions\$version"
        $update = Test-Path -Path $destinationPath
        if ($customUrl) {
            $url = $customUrl
        }
        else {
            # $url = iex "${global:basePath}src\readVersion.ps1 $version" 
            $url = ReadVersion -version $version
        }
    
        if ($url) {
            Write-Host "Starting download..." -ForegroundColor Green
        
            # Realiza o download
            try {
                Invoke-WebRequest -Uri $url -OutFile "${global:basePath}src\temp.zip"
                Write-Host "Download completed!" -ForegroundColor Green
            }
            catch {
                Write-Host "Download failed: $($_.Exception.Message)" -ForegroundColor Red
                return ''
            }
    
            Write-Host "Unzipping now..." -ForegroundColor Green
    
            # Extrai o arquivo ZIP e copia o arquivo ini de desenvolvimento
            Expand-Archive -Path "${global:basePath}src\temp.zip" -DestinationPath $destinationPath -Force
    
            # Checl if env not exists...
            if (-not (Test-Path -Path "${global:basePath}versions\$version\php.ini")) {
                if (Test-Path -Path "${global:basePath}versions\$version\php.ini-development") {
                    Copy-Item "${global:basePath}versions\$version\php.ini-development" "${global:basePath}versions\$version\php.ini"
                }
                if (Test-Path -Path "${global:basePath}versions\$version\php.ini-dist" ) {
                    Copy-Item "${global:basePath}versions\$version\php.ini-dist" "${global:basePath}versions\$version\php.ini"
                }   
            }
    
            # Exclusão do arquivo temp.zip
            Remove-Item "${global:basePath}src\temp.zip" -Force
            if ($update) {
                Write-Host "Update complete!" -ForegroundColor Green
            }
            else {
                Write-Host "Installation complete!" -ForegroundColor Green
            }
        }
        else {
            Write-Host "Try another version, see in the list using 'phpvm list'" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Type a version, like 'phpvm install 82'" -ForegroundColor Red
    }
}

function InstallVersionOld {
    param (
        [string]$version
    )
    
    if ($version) {
        # Check version exists
        $destinationPath = "${global:basePath}versions\$version"
        if (Test-Path -Path $destinationPath) {
            Write-Host "The version $version already exists, try using the 'phpvm update $version' command." -ForegroundColor Yellow
            exit
        }

        # $url = iex "${global:basePath}src\readVersion.ps1 $version" 
        $url = ReadVersion -version $version
        if ($url) {
            Write-Host "Starting download..." -ForegroundColor Green

            # Download do arquivo ZIP como temp.zip
            Invoke-WebRequest -Uri $url -OutFile "${global:basePath}src\temp.zip"

            Write-Host "Unzipping now..." -ForegroundColor Green

            # Extrai o arquivo ZIP e copia o arquivo ini de desenvolvimento
            Expand-Archive -Path "${global:basePath}src\temp.zip" -DestinationPath $destinationPath -Force

            if (Test-Path -Path "${global:basePath}versions\$version\php.ini-development") {
                Copy-Item "${global:basePath}versions\$version\php.ini-development" "${global:basePath}versions\$version\php.ini"
            }
            if (Test-Path -Path "${global:basePath}versions\$version\php.ini-dist" ) {
                Copy-Item "${global:basePath}versions\$version\php.ini-dist" "${global:basePath}versions\$version\php.ini"
            }   

            # Exclusão do arquivo temp.zip
            Remove-Item "${global:basePath}src\temp.zip" -Force

            Write-Host "Installation complete!" -ForegroundColor Green
        }
        else {
            Write-Host "Try another version, see in the list using 'phpvm list'" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Type a version, like 'phpvm install 82'" -ForegroundColor Red
    }
}

function ShowVersions {
    if ([Environment]::Is64BitOperatingSystem) {
        try {
            $web_client = new-object system.net.webclient
            $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x64.json") | ConvertFrom-Json
        }
        catch {
            $jsonContent = Get-Content '${global:basePath}src\list_x64.json' | ConvertFrom-Json
        }
        $os = "x64"
    }
    else {
        try {
            $web_client = new-object system.net.webclient
            $jsonContent = $web_client.DownloadString("https://raw.githubusercontent.com/ThiagoDOM/PhpVM/main/src/list_x86.json") | ConvertFrom-Json 2>$null
        }
        catch {
            $jsonContent = Get-Content '${global:basePath}src\list_x86.json' | ConvertFrom-Json
        }
        $os = "x86"
    }
    
    $versions = $jsonContent.versions
    
    # Exiba cada versão
    Write-Host "Your system is $os based."
    
    foreach ($version in $versions) {
        $name = $version.name
        $ver = $version.version
        if (Test-Path -Path "${global:basePath}versions\$name") {
            Write-Host " $name ($ver)" -ForegroundColor Green
        }
        else {
            Write-Host " $name ($ver)"
        }
    }
}

function SetVersion {
    param (
        [string]$version
    )

    $path = ${global:basePath};

    if ($version) {
        if (Test-Path -Path "${path}versions\$version") {
        
            if (Test-Path -Path "C:\php") {
                Remove-Item -Recurse -Force "C:\php"
            }
    
            Write-Host "Using now version $version"
    
            # Verifique se o script está sendo executado como administrador
            # if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" set $version" -Verb RunAs; exit }
            # New-Item -Path "C:\php" -ItemType SymbolicLink -Value "${path}versions\$version"
            # Write-Host -NoNewLine 'Press any key to continue...';
            # $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
            
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process -FilePath powershell.exe -Verb RunAs -Wait -ArgumentList @(
                    '-NoProfile',
                    '-NoLogo',
                    '-Command',
                    "New-Item -Path 'C:\php' -ItemType SymbolicLink -Value '${path}versions\$version'"
                )
            } else {
                New-Item -Path "C:\php" -ItemType SymbolicLink -Value "${path}versions\$version"
            }

        }
        else {
            Write-Host "Version not found"
        }
    }
    else {
        Write-Host "type a version, like 'phpvm set 82'"
    }
}

function RemoveVersion {
    param (
        [string]$version
    )
    if (Test-Path -Path "${global:basePath}versions\$version") {

        Remove-Item -Recurse -Force "${global:basePath}versions\$version"

        Write-Host "Version $version removed" -ForegroundColor Yellow
    }
    else {
        Write-Host "Version not found" -ForegroundColor Red
    }
}

function OpenIni {
    code C:\php\php.ini
}

function SetPaths {
    $path = ${global:basePath};
    
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" path" -Verb RunAs; exit }
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";${path}bin;C:\php", "User")
}

function Format-String {
    param (
        [string]$inputString
    )

    # Verifica se a string tem exatamente dois dígitos ou já está no formato correto
    if ($inputString -match '^\d\.\d$') {
        return $inputString
    }
    elseif ($inputString -match '^\d{2}$') {
        # Insere o ponto entre os dois dígitos
        return "$($inputString.Substring(0, 1)).$($inputString.Substring(1, 1))"
    }
    else {
        Write-Host "Invalid format. Input must be 'XX' or 'X.X'." -ForegroundColor Red
        return $null
    }
}

function Show-Menu {
    param (
        [string[]]$options,
        [string[]]$base,
        [int]$selectedIndex = 0
    )

    $optionsCount = $options.Count
    # $lastIndex = $selectedIndex

    while ($true) {
        Clear-Host
        if ($base) {
            Write-Host "Choose between Thread Safe(TS) and Non TS(NTS) and x64 or x86"
        }
        else {
            Write-Host "Choose a PHP version"
        }
        for ($i = 0; $i -lt $optionsCount; $i++) {
            if ($base) {
                if ($i -eq $selectedIndex) {
                    Write-Host "> $base - $($options[$i])" -ForegroundColor Cyan
                }
                else {
                    Write-Host "  $base - $($options[$i])"
                } 
            }
            else {
                if ($i -eq $selectedIndex) {
                    Write-Host "> $($options[$i])" -ForegroundColor Cyan
                }
                else {
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

function InstallNewVersion {
    param (
        [string]$sversion
    )
    # Get Data
    $web_client = new-object system.net.webclient
    $web_client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3")
    $jsonContent = $web_client.DownloadString("https://windows.php.net/downloads/releases/releases.json?1") | ConvertFrom-Json 2>$null
    # Format
    $options = $jsonContent.PSObject.Properties.Name
    # Display menu or skip this step
    if ( -not $sversion) {
        $selectedIndex = Show-Menu -options $options
        
        $version = $($options[$selectedIndex])
    }
    else {
        $version = Format-String -inputString $sversion
        # Check version exists
        $check = $false
        foreach ($option in $options) {
            if ($option -eq $version) {
                $check = $true
            }
        }
        if (-not $check) {

            Write-Host "Version not found" -ForegroundColor Red
            return $null
        }
    }

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

        UpdateVersion -version $folderName -customUrl $url
    }
    else {
        # Display error
        Write-Host "An error occurred" -ForegroundColor Red
    }
}

$action1 = $args[0]
$action2 = $args[1]

function Main {
    # Write-Host "$action1 $action2"

    if ($action1 -eq "install-old") {
        UpdateVersion -version $action2
    }

    # if ($action1 -eq "update") {
    #     # This will be deleted
    #     UpdateVersion -version $action2
    # }

    if ($action1 -eq "install") {
        InstallNewVersion $action2
    }

    if ($action1 -eq "list") {
        ShowVersions
    }

    if ($action1 -eq "set" -or $action1 -eq "use") {
        SetVersion -version $action2
    }

    if ($action1 -eq "remove") {
        RemoveVersion -version $action2
    }

    if ($action1 -eq "path") {
        SetPaths
    }

    if ($action1 -eq "ini") {
        OpenIni
    }


    if ($action1 -eq "help" -or !$action1) {
        Write-Host ""
        Write-Host "List of commands:"
        Write-Host " phpvm list" -ForegroundColor Green
        Write-Host "  -show list of versions avaliable for download"
        Write-Host " phpvm install <?version> | e.g. phpvm install or phpvm install 84" -ForegroundColor Green
        Write-Host "  -install a version of PHP in your windows"
        Write-Host " phpvm install-old <version> | e.g. phpvm install-old 84" -ForegroundColor Green
        Write-Host "  -install/update specific version of PHP in your windows"
        Write-Host " phpvm set <version> | e.g. phpvm set 84" -ForegroundColor Green
        Write-Host "  -define specific version of PHP"
        Write-Host " phpvm remove <version> | e.g. phpvm remove 84" -ForegroundColor Green
        Write-Host "  -remove specific version of PHP from your windows"
        Write-Host " phpvm path" -ForegroundColor Green
        Write-Host "  -add paths to Enviroment Variable PATH "
        Write-Host " phpvm ini" -ForegroundColor Green
        Write-Host "  -open php.ini from current version in VS Code "
        Write-Host ""
    }

}

# Call Main Function
Main