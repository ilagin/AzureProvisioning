$commonLocation = "North Europe"
$storageAccountName = "ilagin"
$subscriptionName = Get-AzureSubscription | Select SubscriptionName

New-AzureStorageAccount -StorageAccountName $storageAccountName -Label "TestStorage" -Location $commonLocation
Select-AzureSubscription $subscriptionName.SubscriptionName.ToString()
Set-AzureSubscription -SubscriptionName $subscriptionName.SubscriptionName.ToString() -CurrentStorageAccount $storageAccountName
