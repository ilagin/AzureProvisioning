$sqlVmNames = @("ilgthreetest", "ilgfourtest")

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

$newUserName = "Replication"

foreach($vm in $sqlVmNames)
{
	$uri = Get-AzureWinRMUri -ServiceName $vm -Name $vm
	$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

	$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
	Invoke-Command -Session $session -ScriptBlock { 
			param($vmName)
			Set-ExecutionPolicy RemoteSigned
			Import-Module SQLPS -DisableNameChecking

			$sqlServer = new-object ('Microsoft.SqlServer.Management.Smo.Server') '(local)'
			$sqlServer.Settings.LoginMode = [Microsoft.SqlServer.Management.SMO.ServerLoginMode]::Mixed

			$sqlServer.Alter()
			CD SQLSERVER:\SQL\$vmName
			$Wmi = (get-item .).ManagedComputer

			$sqlInstance = $Wmi.Services['MSSQLSERVER']
			$sqlInstance.Stop()
			Start-Sleep -s 10
			$sqlInstance.Start()
			
			$agent = $Wmi.Services['SQLSERVERAGENT']
			$agent.Start()
	} -Args $vm

	$session | Remove-PSSession
}