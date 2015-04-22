$webVmNames = @("ilgonetest", "ilgtwotest")
$webPaths = @("E:\PRJ\API", "E:\PRJ\Web")

$userName = "eugene"
$pwd = "Super Secure Password1"
 
$securePassword = ConvertTo-SecureString $pwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $securePassword)
$i = 0

foreach($vm in $webVmNames)
{
	$uri = Get-AzureWinRMUri -ServiceName $vm -Name $vm
	$sessionOption = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

	$session = New-PSSession -ConnectionUri $uri -Credential $credential -SessionOption $sessionOption
	Invoke-Command -Session $session -ScriptBlock {
		param($path, $user, $password)
		Set-ExecutionPolicy RemoteSigned
		Import-Module WebAdministration
		
		if (!(Test-Path $path))
		{
			$path = $path.Replace("E:", "F:")
		}
		
		Remove-Item IIS:\AppPools\AdminAppPool -Force -Recurse
		
		$appPool = New-WebAppPool -Name "AdminAppPool"
		$appPool.processModel.userName = $user
		$appPool.processModel.password = $password
		$appPool.processModel.identityType = "SpecificUser"
		$appPool | Set-Item
		
		Remove-Item IIS:\Sites\"Default Web Site" -Force -Recurse
		Remove-Item IIS:\Sites\AzureProvisioning -Force -Recurse
		New-Item IIS:\Sites\AzureProvisioning -physicalPath $path -bindings @{protocol="http";bindingInformation=":80:"}
		
		Set-ItemProperty IIS:\Sites\AzureProvisioning -name applicationPool -value AdminAppPool
	} -Args $webPaths[$i], $userName, $pwd
	$session | Remove-PSSession
	$i++
}