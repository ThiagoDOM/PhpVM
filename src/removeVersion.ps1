$version = $args[0]
if(Test-Path -Path "${global:basePath}versions\$version") {

    Remove-Item -Recurse -Force "${global:basePath}versions\$version"

    Write-Host "Version $action2 removed" -ForegroundColor Yellow
} else {
    Write-Host "Version not found" -ForegroundColor Red
}