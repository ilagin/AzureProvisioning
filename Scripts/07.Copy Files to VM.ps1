$vmNames = @("ilgonetest", "ilgtwotest", "ilgthreetest", "ilgfourtest")
$volumePath = "D:\FileStorage.vhd"
$folderToCopy = "D:\PRJ"
$azureStoragePaths = ("http://ilagin.blob.core.windows.net/vhdstore/FileStorage0.vhd", "http://ilagin.blob.core.windows.net/vhdstore/FileStorage1.vhd", "http://ilagin.blob.core.windows.net/vhdstore/FileStorage2.vhd", "http://ilagin.blob.core.windows.net/vhdstore/FileStorage3.vhd")

$volume = new-vhd -Path $volumePath -SizeBytes 40MB | `
  Mount-VHD -PassThru | `
  Initialize-Disk -PartitionStyle mbr -Confirm:$false -PassThru | `
  New-Partition -UseMaximumSize -AssignDriveLetter -MbrType IFS | `
  Format-Volume -NewFileSystemLabel "VHD" -Confirm:$false
  
Copy-Item $folderToCopy "$($volume.DriveLetter):\" -Recurse
Dismount-VHD $volumePath 

for($i=0; $i -le 3; $i++)
{
	Add-AzureVhd -Destination $azureStoragePaths[$i] -LocalFilePath $volumePath
	Get-AzureVM $vmNames[$i] $vmNames[$i] |  Add-AzureDataDisk -ImportFrom -MediaLocation $azureStoragePaths[$i] -DiskLabel "EXT" -LUN 0 | Update-AzureVM
}