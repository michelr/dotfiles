New-CommandWrapper Out-Default `
    -Process {
        if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
        {if(-not ($notfirst)) {
           Write-Host "    Directory: $(pwd)`n"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $notfirst=$true
           }
           if ($_ -is [System.IO.DirectoryInfo]) {
           Write-host ("{0,-7} {1,25} {2,10} {3}" -f $_.mode, ([String]::Format("{0,10}  {1,8}", $_.LastWriteTime.ToString("d"), $_.LastWriteTime.ToString("t"))), $_.length, $_.name) -foregroundcolor "yellow" }
           else {
           Write-host ("{0,-7} {1,25} {2,10} {3}" -f $_.mode, ([String]::Format("{0,10}  {1,8}", $_.LastWriteTime.ToString("d"), $_.LastWriteTime.ToString("t"))), $_.length, $_.name) -foregroundcolor "green" }
           $_ = $null
        }
} 