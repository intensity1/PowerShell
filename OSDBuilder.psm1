#===================================================================================================
#   Import Functions
#   https://github.com/RamblingCookieMonster/PSStackExchange/blob/master/PSStackExchange/PSStackExchange.psm1
#===================================================================================================
$OSDPublicFunctions  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$OSDPrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach ($Import in @($OSDPublicFunctions + $OSDPrivateFunctions)) {
    Try {. $Import.FullName}
    Catch {Write-Error -Message "Failed to import function $($Import.FullName): $_"}
}

Export-ModuleMember -Function $OSDPublicFunctions.BaseName
#===================================================================================================
#   Get-OSBuilder
#===================================================================================================
try {New-Alias -Name Get-OSBuilder -Value Get-OSDBuilder -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   New-OSBMediaISO
#===================================================================================================
try {New-Alias -Name New-OSBMediaISO -Value New-OSDBuilderISO -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   New-OSBMediaUSB
#===================================================================================================
try {New-Alias -Name New-OSBMediaUSB -Value New-OSDBuilderUSB -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   Show-OSBMediaInfo
#===================================================================================================
try {New-Alias -Name Show-OSBMediaInfo -Value Show-OSDBuilderInfo -Force -ErrorAction SilentlyContinue}
catch {}

<# #===================================================================================================
#   ImportOSD
#===================================================================================================
try {New-Alias -Name ImportOSD -Value Import-OSMedia -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   UpdateOSD
#===================================================================================================
try {New-Alias -Name UpdateOSD -Value Update-OSMedia -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   BuildOSD
#===================================================================================================
try {New-Alias -Name BuildOSD -Value New-OSBuild -Force -ErrorAction SilentlyContinue}
catch {}

#===================================================================================================
#   OSDISO
#===================================================================================================
try {New-Alias -Name OSDISO -Value New-OSDBuilderISO -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   OSDUSB
#===================================================================================================
try {New-Alias -Name OSDUSB -Value New-OSDBuilderUSB -Force -ErrorAction SilentlyContinue}
catch {}
#===================================================================================================
#   OSDInfo
#===================================================================================================
try {New-Alias -Name OSDInfo -Value Show-OSDBuilderInfo -Force -ErrorAction SilentlyContinue}
catch {} #>

#===================================================================================================
#   Export-ModuleMember
#===================================================================================================
Export-ModuleMember -Function * -Alias *