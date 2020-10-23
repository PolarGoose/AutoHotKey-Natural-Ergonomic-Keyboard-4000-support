Function Info($msg) {
    Write-Host -ForegroundColor DarkGreen "`nINFO: $msg`n"
}

Function CopyItemsToFolder($folderWithItems, $dstFolder) {
    Info "Copy items `n from '$folderWithItems' `n to '$dstFolder'"
    Remove-Item $dstFolder -Recurse -Force -ErrorAction SilentlyContinue 2> $null
    Copy-Item $folderWithItems $dstFolder -Recurse -Force
}

Function CreateZipArchive($dir) {
    Info "Create zip archive `n ${dir}.zip"
    Compress-Archive -Force -Path "$dir/*" -DestinationPath "${dir}.zip"
}

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$root = Resolve-Path "$PSScriptRoot/../.."
$projectName = "AutoHotKey-Natural-Ergonomic-Keyboard-4000-support"
$publishDir = "$root/Build/$projectName"

CopyItemsToFolder $root/src $publishDir
CreateZipArchive $publishDir
