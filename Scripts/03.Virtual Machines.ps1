$commonLocation = "North Europe"
$webServerImageName = "bd507d3a70934695bc2128e3e5a255ba__RightImage-Windows-2012-x64-iis8-v14.2"
$dbServerImageName = "fb83b3509582419d99629ce476bcb5c8__SQL-Server-2012-SP2-11.0.5569.0-Ent-ENU-Win2012-cy15su02"
$virtualNetworkName = "MyVirtualNetwork"
$subnetName = "Subnet1"

$vmNames = @("ilgonetest", "ilgtwotest", "ilgthreetest", "ilgfourtest")

$pwd = "Super Secure Password1"
$instanceSize = "Large"
$userName = "eugene"

$vm0 = New-AzureVMConfig -Name $vmNames[0] -InstanceSize $instanceSize -Image $webServerImageName
$vm0 | Add-AzureProvisioningConfig -DisableAutomaticUpdates -Windows -AdminUserName $userName -Password $pwd | Set-AzureSubnet $subnetName
$vm0 | New-AzureVM -ServiceName $vmNames[0]  -VNetName $virtualNetworkName –Location $commonLocation 

$vm1 = New-AzureVMConfig -Name $vmNames[1] -InstanceSize $instanceSize -Image $webServerImageName
$vm1 | Add-AzureProvisioningConfig -DisableAutomaticUpdates -Windows -AdminUserName $userName -Password $pwd | Set-AzureSubnet $subnetName
$vm1 | New-AzureVM -ServiceName $vmNames[1]  -VNetName $virtualNetworkName –Location $commonLocation 

$vm2 = New-AzureVMConfig -Name $vmNames[2] -InstanceSize $instanceSize -Image $dbServerImageName
$vm2 | Add-AzureProvisioningConfig -DisableAutomaticUpdates -Windows -AdminUserName $userName -Password $pwd | Set-AzureSubnet $subnetName
$vm2 | New-AzureVM -ServiceName $vmNames[2]  -VNetName $virtualNetworkName –Location $commonLocation

$vm3 = New-AzureVMConfig -Name $vmNames[3] -InstanceSize $instanceSize -Image $dbServerImageName
$vm3 | Add-AzureProvisioningConfig -DisableAutomaticUpdates -Windows -AdminUserName $userName -Password $pwd | Set-AzureSubnet $subnetName
$vm3 | New-AzureVM -ServiceName $vmNames[3]  -VNetName $virtualNetworkName –Location $commonLocation