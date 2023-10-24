$ErrorActionPreference = 'Stop';

$DesktopPath= [Environment]::GetFolderPath("Desktop")
$exe		= "$DesktopPath\chipmunk.lnk"

if (Test-Path $exe) {
   Remove-Item $exe
}