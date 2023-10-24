$ErrorActionPreference = 'Stop';
#if( -not ( get-command Install-ChocolateyPackage -erroraction silentlycontinue ) ) {
#    Import-Module C:\ProgramData\chocolatey\helpers\chocolateyInstaller.psm1
#}

$packageName= 'chipmunk'
$version	= '3.9.22'
$zipname	= "chipmunk@$version-win64-portable"
$toolsDir	= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "https://github.com/esrlabs/chipmunk/releases/download/$version/chipmunk@$version-win64-portable.tgz"
$shortcut	= "$env:ChocolateyInstall\bin\chipmunk.exe"
$DesktopPath= [Environment]::GetFolderPath("Desktop")
$exe		= "$DesktopPath\chipmunk.lnk"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  softwareName  = 'chipmunk*'
}

Install-ChocolateyZipPackage @packageArgs
Get-ChocolateyUnzip -FileFullPath "$toolsDir/$zipname.tar" -Destination $toolsDir
Install-ChocolateyShortcut -ShortcutFilePath $exe -TargetPath $shortcut