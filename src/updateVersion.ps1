$version = $args[0]
    
if ($version) {
    $destinationPath = "C:\PhpVM\versions\$version"
    $update = Test-Path -Path $destinationPath
    $url = C:\PhpVM\src\readVersion.ps1 $version
    if ($url) {
        Write-Host "Starting download..." -ForegroundColor Green

        # Download do arquivo ZIP como temp.zip
        Invoke-WebRequest -Uri $url -OutFile "C:\PhpVM\src\temp.zip"

        Write-Host "Unzipping now..." -ForegroundColor Green

        # Extrai o arquivo ZIP e copia o arquivo ini de desenvolvimento
        Expand-Archive -Path "C:\PhpVM\src\temp.zip" -DestinationPath $destinationPath -Force

        if (Test-Path -Path "C:\PhpVM\versions\$version\php.ini-development") {
            Copy-Item "C:\PhpVM\versions\$version\php.ini-development" "C:\PhpVM\versions\$version\php.ini"
        }
        if(Test-Path -Path "C:\PhpVM\versions\$version\php.ini-dist" ) {
            Copy-Item "C:\PhpVM\versions\$version\php.ini-dist" "C:\PhpVM\versions\$version\php.ini"
        }   

        # Exclusão do arquivo temp.zip
        Remove-Item "C:\PhpVM\src\temp.zip" -Force
        if ($update) {
            Write-Host "Update complete!" -ForegroundColor Green
        } else {
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