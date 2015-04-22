$vmNames = @("ilgonetest", "ilgtwotest", "ilgthreetest", "ilgfourtest")

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

foreach($vm in $vmNames)
{
	$uri = Get-AzureWinRMUri -ServiceName $vm -Name $vm 
	$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
 
	$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
	Invoke-Command -Session $session -ScriptBlock {Get-NetFirewallProfile | Set-NetFirewallProfile –Enabled False}
$session | Remove-PSSession
}