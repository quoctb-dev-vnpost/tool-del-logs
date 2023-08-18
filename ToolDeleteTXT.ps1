$sourceFolderPath = "C:\logs\hangfire"
$backupFolderPath = "C:\logs\hangfire_BAK"

$currentDate = Get-Date
$daysToKeep = 7
$cutOffDate = $currentDate.AddDays(-$daysToKeep)

# Tạo tên tệp nén dựa trên ngày và giờ hiện tại
$zipFileName = "Backup_$($currentDate.ToString("yyyyMMdd_HHmmss")).zip"
$zipFilePath = Join-Path -Path $backupFolderPath -ChildPath $zipFileName

# Lấy danh sách các tệp cần nén
$filesToZip = Get-ChildItem -Path $sourceFolderPath | Where-Object { $_.LastWriteTime -lt $cutOffDate }

# Nén các tệp và thư mục vào tệp nén
Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory($sourceFolderPath, $zipFilePath)

# Di chuyển tệp nén từ thư mục nguồn vào thư mục đích
Move-Item $zipFilePath $backupFolderPath

# Xóa các tệp đã nén từ thư mục nguồn
$filesToZip | ForEach-Object {
    Remove-Item $_.FullName -Force
}

Write-Host "Đã nén, di chuyển và xóa các tệp thành công!"
