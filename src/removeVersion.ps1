$version = $args[0]
if(Test-Path -Path "C:\PhpVM\versions\$version") {

    Remove-Item -Recurse -Force "C:\PhpVM\versions\$version"

    Write-Host "Version $action2 removed"
} else {
    Write-Host "Version not found"
}