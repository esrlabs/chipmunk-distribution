$ErrorActionPreference = 'Stop';

$packageName= 'chipmunk'
$url_chipmunk = 'https://github.com/esrlabs/chipmunk/releases/latest'
$request = [System.Net.WebRequest]::Create($url_chipmunk)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$version = $realTagUrl.split('/')[-1].Trim('v')

$zipname = "chipmunk@$version-win64-portable"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "https://github.com/esrlabs/chipmunk/releases/download/$version/chipmunk@$version-win64-portable.tgz"
$shortcut = "$env:ChocolateyInstall\bin\chipmunk.exe"
$DesktopPath= [Environment]::GetFolderPath("Desktop")
$exe = "$DesktopPath\chipmunk.lnk"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  softwareName  = 'chipmunk*'
}

Install-ChocolateyZipPackage @packageArgs
Get-ChocolateyUnzip -FileFullPath "$toolsDir/$zipname.tar" -Destination $toolsDir
Install-ChocolateyShortcut -ShortcutFilePath $exe -TargetPath $shortcut