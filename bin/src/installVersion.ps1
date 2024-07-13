$version = $args[0]

if ($version) {
    $url = C:\multiphp\bin\src\readVersion.ps1 $version
    if ($url) {
        Write-Host "Starting download..."

        # Download do arquivo ZIP como temp.zip
        Invoke-WebRequest -Uri $url -OutFile "C:\multiphp\bin\src\temp.zip"

        Write-Host "Unzipping now..."

        # Extrai o arquivo ZIP e copia o arquivo ini de desenvolvimento
        Expand-Archive -Path "C:\multiphp\bin\src\temp.zip" -DestinationPath "C:\multiphp\versions\$version" -Force

        if (Test-Path -Path "C:\multiphp\versions\$version\php.ini-development") {
            Copy-Item "C:\multiphp\versions\$version\php.ini-development" "C:\multiphp\versions\$version\php.ini"
        }
        if(Test-Path -Path "C:\multiphp\versions\$version\php.ini-dist" ) {
            Copy-Item "C:\multiphp\versions\$version\php.ini-dist" "C:\multiphp\versions\$version\php.ini"
        }   

        # Exclusão do arquivo temp.zip
        Remove-Item "C:\multiphp\bin\src\temp.zip" -Force

        Write-Host "Installation complete!"
    }
    else {
        Write-Host "Try another version, see in the list using 'phpvm list'"
    }
}
else {
    Write-Host "Type a version, like 'phpvm install 82'"
}