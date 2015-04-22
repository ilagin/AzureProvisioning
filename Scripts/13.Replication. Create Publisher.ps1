$distributorVm = "ilgthreetest"

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

$uri = Get-AzureWinRMUri -ServiceName $distributorVm -Name $distributorVm
$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
Invoke-Command -Session $session -ScriptBlock { 
	Set-ExecutionPolicy RemoteSigned
	Import-Module SQLPS -DisableNameChecking
	
	$publicationFilePath = "E:\PRJ\publication.sql"
	
	if (!(Test-Path $publicationFilePath))
	{
		$publicationFilePath = "F:\PRJ\publication.sql"
	}
	
	Invoke-SqlCmd -InputFile $publicationFilePath -ServerInstance "(local)"
} 

$session | Remove-PSSession