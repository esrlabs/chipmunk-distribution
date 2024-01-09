param(
  [switch] $publish
)

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$version = '1.0.0'
$homeDir = (Resolve-Path "$PSScriptRoot\.").Path
$chocoCommand = "choco"
$choco_token = $secrets:CHOCO_TOKEN_M1
$choco = @{
  homeDir = "$homeDir\chocolatey_win"
  nuspec = "$homeDir\chocolatey_win\chipmunk.nuspec"
  chocoScript = "$homeDir\chocolatey_win\tools\chocolateyinstall.ps1"
}
    
$chocoNuspec = Get-Content $choco.nuspec -Encoding UTF8 -Raw
$chocoNuspec = [Regex]::Replace($chocoNuspec, '(<version>[\d.]+<\/version>)', "<version>$version</version>")
$chocoNuspec | Set-Content $choco.nuspec -Force -Encoding UTF8

$nupkgName = "chipmunk.$version.nupkg"

if ($publish) {
  # create the nuspec package
  & $chocoCommand pack $choco.nuspec

  # if token is given, we will publish the package to Chocolatey here
  if ($choco_token) {
    & $chocoCommand apiKey --key $choco_token --source https://push.chocolatey.org/
    & $chocoCommand push $nupkgName --source https://push.chocolatey.org/ -dv
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