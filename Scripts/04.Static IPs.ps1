$vmNames = @("ilgonetest", "ilgtwotest", "ilgthreetest", "ilgfourtest")
$staticIPs = @("10.0.0.4", "10.0.0.5", "10.0.0.6", "10.0.0.7")

for($i=0; $i -le 3; $i++)
{
	Get-AzureVM -ServiceName $vmNames[$i] -Name $vmNames[$i] | Set-AzureStaticVNetIP -IPAddress $staticIPs[$i] | Update-AzureVM
}