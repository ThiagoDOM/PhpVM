$version = $args[0]
$path = $args[1]

if (-not ($path)) {
    $path = ${global:basePath};
}

if($version) {
    if(Test-Path -Path "${path}versions\$version") {
        
    if(Test-Path -Path "C:\php") {
        Remove-Item -Recurse -Force "C:\php"
    }
    
    Write-Host "Using now version $version"
    
    # Verifique se o script está sendo executado como administrador
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $version $path" -Verb RunAs; exit }
    New-Item -Path "C:\php" -ItemType SymbolicLink -Value "${path}versions\$version"
    
    } else {
        Write-Host "Version not found"
    }
} else {
    Write-Host "type a version, like 'phpvm set 82'"
}