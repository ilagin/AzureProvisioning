$sqlSubscriberVM = "ilgfourtest"

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

$uri = Get-AzureWinRMUri -ServiceName $sqlSubscriberVM -Name $sqlSubscriberVM
$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
Invoke-Command -Session $session -ScriptBlock { 
		$pathToShare = "E:\PRJ"
		
		if (!(Test-Path $pathToShare))
		{
			$pathToShare = $pathToShare.Replace("E:", "F:")
		}
		$netSharePath = "PRJ=" + $pathToShare
		net user guest /active:yes
		net share $netSharePath "/GRANT:Everyone,FULL"
}

$session | Remove-PSSession

$sqlPublisherVM = "ilgthreetest"

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

$uri = Get-AzureWinRMUri -ServiceName $sqlPublisherVM -Name $sqlPublisherVM
$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
Invoke-Command -Session $session -ScriptBlock {
		Set-ExecutionPolicy RemoteSigned
		Import-Module SQLPS -DisableNameChecking
		
		$path = "E:\PRJ\"
		
		if (!(Test-Path $path))
		{
			$path = $path.Replace("E:", "F:")
		}
		
		$backupPath = $path + "new.bak"

		Backup-SqlDatabase -ServerInstance '(local)' -Database "AzureProvisioning" -BackupFile $backupPath
		$pass="Super Secure Password1"|ConvertTo-SecureString -AsPlainText -Force
		$cred = New-Object System.Management.Automation.PsCredential("ILGFOURTEST\eugene",$pass)

		New-PSDrive -Name R -Root "\\10.0.0.7\PRJ" -PSProvider FileSystem -Credential $cred
		
		Copy-Item $backupPath "R:\"
}

$session | Remove-PSSession