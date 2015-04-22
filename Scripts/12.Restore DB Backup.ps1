$sqlVmNames = @("ilgthreetest", "ilgfourtest")

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

foreach($vm in $sqlVmNames)
{
	$uri = Get-AzureWinRMUri -ServiceName $vm -Name $vm
	$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

	$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
	Invoke-Command -Session $session -ScriptBlock { 
		Set-ExecutionPolicy RemoteSigned
		Import-Module SQLPS -DisableNameChecking
		$srv = new-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
		$db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, "AzureProvisioning")
		$db.Create()
		
		$backupFilePath = "E:\PRJ\db.bak"
		
		if (!(Test-Path $backupFilePath))
		{
			$backupFilePath = "F:\PRJ\db.bak"
		}

		Restore-SqlDatabase -ServerInstance "(local)" -Database AzureProvisioning -BackupFile $backupFilePath -ReplaceDatabase
	} 
	
	$session | Remove-PSSession
}