Write-Host "Clearing the Teams cache requires the teams clients to be closed."
Write-Host "This script WILL close Teams -- please make sure you will not lose any work before proceeding."
$strClearCacheVerification = Read-Host "Are you sure you want to delete Teams Cache (Y/N)?"
$strClearCacheVerification = $strClearCacheVerification.ToUpper()

if ($strClearCacheVerification -eq "N"){
	Write-Host "Operation cancelled."
	Stop-Process -Id $PID
}
elseif ($strClearCacheVerification -eq "Y"){
	$iTeamsProcess = Get-Process -ProcessName Teams -ErrorAction Ignore
	if($iTeamsProcess){
		try{
			Write-Host "Stopping Teams Process" -ForegroundColor Yellow
			Stop-Process -Force -Id $iTeamsProcess.Id
			Start-Sleep -Seconds 3
			Write-Host "Teams Process Sucessfully Stopped`n" -ForegroundColor Green
		}
		catch{
			echo $_
		}
	}
	Write-Host "Clearing Teams Disk Cache" -ForegroundColor Yellow
	try{
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache\cache" -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp"  -ErrorAction Ignore | Remove-Item -Confirm:$false
		Write-Host "Teams cache has been cleared`n" -ForegroundColor Green
	}
	catch{
		echo $_
	}
	if($iTeamsProcess){
		Write-Host "Re-launching Teams" -ForegroundColor Green
		Start-Process -FilePath $env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe
	}
	Stop-Process -Id $PID
}
else{
	Stop-Process -Id $PID
}