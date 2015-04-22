$vmNames = @("ilgonetest", "ilgtwotest", "ilgthreetest", "ilgfourtest")
$storageAccountName = "ilagin"
 
foreach($vm in $vmNames)
{
	Remove-AzureDeployment -ServiceName $vm -Slot Production -DeleteVHD -Force 
	Remove-AzureService -ServiceName $vm -Force
}
 
Remove-AzureVNetConfig
 
Start-Sleep -s 30
 
Remove-AzureStorageAccount -StorageAccountName $storageAccountName