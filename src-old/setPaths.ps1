$path = $args[1]

if (-not ($path)) {
    $path = ${global:basePath};
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $version $path" -Verb RunAs; exit }
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";${path}bin;C:\php", "User")
