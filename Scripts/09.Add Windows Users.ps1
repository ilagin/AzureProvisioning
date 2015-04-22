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
			param($vmName, $userToCreate, $userPassword)
			$Computer = [ADSI]("WinNT://" + $vmName)
			$LocalAdmin = $Computer.Create("User", $userToCreate)
			$LocalAdmin.SetPassword($userPassword) 
			$LocalAdmin.SetInfo() 
			$LocalAdmin.FullName = "Azure Provisioning Demo" 
			$LocalAdmin.SetInfo() 
			$LocalAdmin.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD 
			$LocalAdmin.SetInfo() 
			$objOU = [ADSI]("WinNT://" + $vmName + "/Administrators,group")
			$objOU.add("WinNT://" + $vmName +"/" + $userToCreate)
	} -Args $vm, $newUserName, $pwd
	$session | Remove-PSSession
}