$version = $args[0]
if($version) {
    if(Test-Path -Path "C:\PhpVM\versions\$version") {
        
    if(Test-Path -Path "C:\php") {
        Remove-Item -Recurse -Force "C:\php"
    }
    
    Write-Host "Using now version $version"
    
    # Verifique se o script está sendo executado como administrador
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $version" -Verb RunAs; exit }
    New-Item -Path "C:\php" -ItemType SymbolicLink -Value "C:\PhpVM\versions\$version"
    
    } else {
        Write-Host "Version not found"
    }
} else {
    Write-Host "type a version, like 'phpvm set 82'"
}