$version = $args[0]
    
if ($version) {
    # Check version exists
    $destinationPath = "${global:basePath}versions\$version"
    if (Test-Path -Path $destinationPath) {
        Write-Host "The version $version already exists, try using the 'phpvm update $version' command." -ForegroundColor Yellow
        exit
    }

    $url = iex "${global:basePath}src\readVersion.ps1 $version" 
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
        if(Test-Path -Path "${global:basePath}versions\$version\php.ini-dist" ) {
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