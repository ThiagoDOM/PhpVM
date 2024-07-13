$version = $args[0]
if(Test-Path -Path "C:\multiphp\versions\$version") {

    Remove-Item -Recurse -Force "C:\multiphp\versions\$version"

    Write-Host "Version $action2 removed"
} else {
    Write-Host "Version not found"
}