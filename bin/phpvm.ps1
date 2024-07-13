$action1 = $args[0]
$action2 = $args[1]

# Write-Host "$action1 $action2"

if($action1 -eq "install") {
    C:\PhpVM\src\installVersion.ps1 $action2
}

if($action1 -eq "list") {
    C:\PhpVM\src\showVersions.ps1
}

if($action1 -eq "set") {
    C:\PhpVM\src\setVersion.ps1 $action2
}

if($action1 -eq "remove") {
    C:\PhpVM\src\removeVersion.ps1 $action2
}

if($action1 -eq "path") {
    C:\PhpVM\src\setPaths.ps1
}

if($action1 -eq "help" -or !$action1) {
    Write-Host ""
    Write-Host "List of commands:"
    Write-Host " phpvm list" -ForegroundColor Green
    Write-Host "  -show list of versions avaliable for download"
    Write-Host " phpvm install <version> | phpvm install 82" -ForegroundColor Green
    Write-Host "  -install specific version of PHP in your windows"
    Write-Host " phpvm set <version> | phpvm set 82" -ForegroundColor Green
    Write-Host "  -define specific version of PHP"
    Write-Host " phpvm remove <version> | phpvm remove 82" -ForegroundColor Green
    Write-Host "  -remove specific version of PHP from your windows"
    Write-Host " phpvm path" -ForegroundColor Green
    Write-Host "  -add paths to Enviroment Variable PATH "
    Write-Host ""
}
    
