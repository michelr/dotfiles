#Set home dir
(get-psprovider 'FileSystem').Home = 'C:\Users\mradosavljevic'
Remove-Variable -Force HOME
$global:home = (resolve-path ~)

# A couple of directory variables for convenience
$dotfiles = resolve-path ~/Documents/WindowsPowerShell/dotfiles/
$scripts = join-path $dotfiles "powershell"
$env:PSModulePath += ";" + (join-path $scripts modules)

# Path tweaks
add-pathVariable $scripts

#Modules
Import-Module "Pscx" -Arg (join-path $scripts Pscx.UserPreferences.ps1)
. '~/Documents/WindowsPowerShell/dotfiles/powershell/modules/Jump.Location-0.4.1/Load.ps1'
. '~/Documents/WindowsPowerShell/dotfiles/powershell/modules/posh-git/profile.example.ps1'

#Aliases
Set-Alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
Set-Alias gs "git status" 



$global:promptTheme = @{
	prefixColor = [ConsoleColor]::Cyan
	pathColor = [ConsoleColor]::Cyan
	pathBracesColor = [ConsoleColor]::DarkCyan
	hostNameColor = [ConsoleColor]::Red
}

function get-vimShortPath([string] $path) {
   $loc = $path.Replace($HOME, '~')
	 $loc = $loc.Replace($env:WINDIR, '[Windows]')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function prompt {
	$prefix = ""
	$hostName = [net.dns]::GetHostName().ToLower()
	$shortPath = get-vimShortPath(get-location)

	write-host $prefix -noNewLine -foregroundColor $promptTheme.prefixColor
	write-host $hostName -noNewLine -foregroundColor $promptTheme.hostNameColor
	write-host ' {' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	write-host $shortPath -noNewLine -foregroundColor $promptTheme.pathColor
	write-host '}' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	write-vcsStatus # from posh-git, posh-hg and posh-svn
	return ' '
}

New-CommandWrapper Out-Default -Process {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)


    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)

    if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
    {
        if(-not ($notfirst)) 
        {
           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $(pwd)`n" -foregroundcolor "Magenta"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $notfirst=$true
        }

        if ($_ -is [System.IO.DirectoryInfo]) 
        {
            Write-Color-LS "Magenta" $_                
        }
        elseif ($compressed.IsMatch($_.Name))
        {
            Write-Color-LS "DarkGreen" $_
        }
        elseif ($executable.IsMatch($_.Name))
        {
            Write-Color-LS "Red" $_
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            Write-Color-LS "Yellow" $_
        }
        else
        {
            Write-Color-LS "White" $_
        }

    $_ = $null
    }
} -end {
    write-host ""
}

function Write-Color-LS {
	param ([string]$color = "white", $file)
	Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $file.length, $file.name) -foregroundcolor $color 
}

function Get-Hosts{
	start-process -verb RunAs notepad++ C:\Windows\System32\Drivers\etc\hosts
}

cd ~
cls




