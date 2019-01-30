# Silent install Adobe Reader DC
# https://get.adobe.com/nl/reader/enterprise/
# Bryan Valarezo

# Path for the workdir
$tempdir = ($env:TEMP)
# Get the lastest version of the installer
$FTPFolderUrl = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/"

#connect to ftp, and get directory listing
$FTPRequest = [System.Net.FtpWebRequest]::Create("$FTPFolderUrl") 
$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
$FTPResponse = $FTPRequest.GetResponse()
$ResponseStream = $FTPResponse.GetResponseStream()
$FTPReader = New-Object System.IO.Streamreader -ArgumentList $ResponseStream
$DirList = $FTPReader.ReadToEnd()

#from Directory Listing get last entry in list, but skip one to avoid the 'misc' dir
$LatestUpdate = $DirList -split '[\r\n]' | Where {$_} | Select -Last 1 -Skip 1

#build file name
$LatestFile = "AcroRdrDC" + $LatestUpdate + "_en_US.exe"

#build download url for latest file
$DownloadURL = "$FTPFolderUrl$LatestUpdate/$LatestFile"
$destination = "$tempdir\adobeDC.exe"
# Download the installer
Write-Host "Beginning Download..." -ForegroundColor Yellow
Invoke-WebRequest $DownloadURL -OutFile $destination 
Write-Host "Download Complete!" -ForegroundColor Green
# Start the installation
Write-Host "Beginning Installation..." -ForegroundColor Yellow
Start-Process -FilePath "$tempdir\adobeDC.exe" -ArgumentList "/sPB /rs"
Write-Host "Please refer to the GUI installation..." -ForegroundColor Yellow
#Done
Write-Host "End of Script" -ForegroundColor Red