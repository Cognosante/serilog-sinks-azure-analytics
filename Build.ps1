Write-Output "build: Build started"

Push-Location $PSScriptRoot

if(Test-Path .\artifacts) {
	Write-Output "build: Cleaning .\artifacts"
	Remove-Item .\artifacts -Force -Recurse
}
& dotnet restore --no-cache

$branch = @{ $true = $env:APPVEYOR_REPO_BRANCH; $false = $(git symbolic-ref --short -q HEAD) }[$env:APPVEYOR_REPO_BRANCH -ne $NULL];
$revision = @{ $true = "{0:00000}" -f [convert]::ToInt32("0" + $env:APPVEYOR_BUILD_NUMBER, 10); $false = "local" }[$env:APPVEYOR_BUILD_NUMBER -ne $NULL];
$suffix = @{ $true = ""; $false = "$($branch.Substring(0, [math]::Min(10,$branch.Length)))-$revision"}[$branch -eq "master" -and $revision -ne "local"]

$suffix = "cognosante-007"
Write-Output "build: Version suffix is $suffix"

& dotnet pack -c Debug -o ..\..\artifacts --version-suffix=$suffix --include-symbols

Pop-Location
