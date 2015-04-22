$webVmNames = @("ilgonetest", "ilgtwotest")

foreach($vm in $webVmNames)
{
	Get-AzureVM -ServiceName $vm -Name $vm | Add-AzureEndpoint -Name "HttpIn" -Protocol "tcp" -PublicPort 80 -LocalPort 80 | Update-AzureVM
}