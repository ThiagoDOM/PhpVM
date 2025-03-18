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
    
            # Download do arquivo ZIP como temp.zip
            Invoke-WebRequest -Uri $url -OutFile "${global:basePath}src\temp.zip"
    
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

function InstallVersion {
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
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $version $path" -Verb RunAs; exit }
            New-Item -Path "C:\php" -ItemType SymbolicLink -Value "${path}versions\$version"
    
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
    
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $version $path" -Verb RunAs; exit }
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";${path}bin;C:\php", "User")
}

# InstallVersion -version 52
# ShowVersions
# SetVersion -version 83
# RemoveVersion -version 52
OpenIni