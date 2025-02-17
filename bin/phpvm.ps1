$action1 = $args[0]
$action2 = $args[1]

# Write-Host "$action1 $action2"

if($action1 -eq "install") { # This will be deleted
    C:\PhpVM\src\installVersion.ps1 $action2
}

if($action1 -eq "update") { # This will be deleted
    C:\PhpVM\src\updateVersion.ps1 $action2
}

if($action1 -eq "new") { # This will be changed
    C:\PhpVM\src\installRelease.ps1 $action2
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

if($action1 -eq "ini") {
    C:\PhpVM\src\openIni.ps1
}


if($action1 -eq "help" -or !$action1) {
    Write-Host ""
    Write-Host "List of commands:"
    Write-Host " phpvm list" -ForegroundColor Green
    Write-Host "  -show list of versions avaliable for download"
    Write-Host " phpvm install <version> | e.g. phpvm install 82" -ForegroundColor Green
    Write-Host "  -install specific version of PHP in your windows"
    Write-Host " phpvm update <version> | e.g. phpvm update 82" -ForegroundColor Green
    Write-Host "  -install/update specific version of PHP in your windows"
    Write-Host " phpvm set <version> | e.g. phpvm set 82" -ForegroundColor Green
    Write-Host "  -define specific version of PHP"
    Write-Host " phpvm remove <version> | e.g. phpvm remove 82" -ForegroundColor Green
    Write-Host "  -remove specific version of PHP from your windows"
    Write-Host " phpvm path" -ForegroundColor Green
    Write-Host "  -add paths to Enviroment Variable PATH "
    Write-Host " phpvm ini" -ForegroundColor Green
    Write-Host "  -open php.ini from current version in VS Code "
    Write-Host ""
}
    
# basePath
$global:basePath = "C:\PhpVM\"
