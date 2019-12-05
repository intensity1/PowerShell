$SiteServer = "FLMIR-SCCM"
$SiteCode = "BSG"
$SiteDrive = $SiteCode + ":"
Import-Module (Join-Path -Path (($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) -ChildPath "\ConfigurationManager.psd1") -Force
if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue | Measure-Object).Count -ne 1) {
    New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SiteServer
}
Set-Location $SiteDrive