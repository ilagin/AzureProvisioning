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
			param($vmName, $userName, $userPassword)
			Set-ExecutionPolicy RemoteSigned
			Import-Module SQLPS -DisableNameChecking

			$SQLInstanceName = "(local)"
			$Server  = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $SQLInstanceName

			if ($Server.Logins.Contains($userName))
			{
				$Server.Logins[$userName].Drop()
			}

			$Login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $Server, $userName
			$Login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
			$Login.PasswordExpirationEnabled = $false

			$Login.Create($userPassword)
			$Login.AddToRole("sysadmin")
			$Login.Alter()
			
			$replicationWindowsUser = $vmName + "\Replication"
			
			if ($Server.Logins.Contains($replicationWindowsUser))
			{
				$Server.Logins[$replicationWindowsUser].Drop()
			}

			$Login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $Server, $replicationWindowsUser
			$Login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
			$Login.PasswordExpirationEnabled = $false

			$Login.Create($userPassword)
			$Login.AddToRole("sysadmin")
			$Login.Alter()
			
	} -Args $vm, $newUserName, $pwd
	$session | Remove-PSSession
}