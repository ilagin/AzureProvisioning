$uri = Get-AzureWinRMUri -ServiceName $sqlSubscriberVM -Name $sqlSubscriberVM
$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
Invoke-Command -Session $session -ScriptBlock { 
	Set-ExecutionPolicy RemoteSigned
	Import-Module SQLPS -DisableNameChecking
	$srv = new-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
	$db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, "AzureProvisioning")
	$db.Create()
	
	$backupPath = "E:\PRJ\new.bak"
		
	if (!(Test-Path $backupPath))
	{
		$backupPath = $backupPath.Replace("E:", "F:")
	}

	Restore-SqlDatabase -ServerInstance "(local)" -Database AzureProvisioning -BackupFile $backupPath -ReplaceDatabase
}