param(
  [switch] $publish
)

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$homeDir = (Resolve-Path "$PSScriptRoot\.").Path
$version = "3.9.22"
$chocoCommand = "choco"
$choco_token = "a07d53e8-fba5-4b78-906d-cee91e9bcb7e"
$choco = @{
  homeDir = "$homeDir\chocolatey_win"
  nuspec = "$homeDir\chocolatey_win\chipmunk.nuspec"
  chocoScript = "$homeDir\chocolatey_win\tools\chocolateyinstall.ps1"
}

function UpdateChocoConfig {
    param($chocoScriptPath, $chocoNuspecPath, $version)
    $chocoScript = Get-Content $chocoScriptPath -Encoding UTF8 -Raw
    $chocoScript | Set-Content $chocoScriptPath -Force -Encoding UTF8
    
    $chocoNuspec = Get-Content $chocoNuspecPath -Encoding UTF8 -Raw
    $chocoNuspec | Set-Content $chocoNuspecPath -Force -Encoding UTF8
}

$nupkgName = "chipmunk.$version.nupkg"

UpdateChocoConfig $choco.chocoScript $choco.nuspec $version

if ($publish) {
  # create the nuspec package
  & $chocoCommand pack $choco.nuspec

  # if token is given, we will publish the package to Chocolatey here
  if ($choco_token) {
    & $chocoCommand apiKey -k $choco_token -source https://push.chocolatey.org/
    & $chocoCommand push $nupkgName -source https://push.chocolatey.org/ -dv
  } else {
    Write-Warning "Chocolatey token was not set. Publication skipped."
  }
} else {
  # For development/debuggin purposes
  $script = Get-Content $choco.chocoScript -Encoding UTF8 -Raw
  Write-Host "================= Choco Script ====================="
  Write-Host $script
  Write-Host "===================================================="

  $nuspec = Get-Content $choco.nuspec -Encoding UTF8 -Raw
  Write-Host "================== Nuspec ==========================="
  Write-Host $nuspec
  Write-Host "===================================================="

  Write-Host "$chocoCommand pack " $choco.nuspec
  Write-Host "$chocoCommand apiKey -k $choco_token -source https://push.chocolatey.org/"
  Write-Host "$chocoCommand push $nupkgName"
}