#Set home dir
(get-psprovider 'FileSystem').Home = 'C:\Users\mradosavljevic'
Remove-Variable -Force HOME
$global:home = (resolve-path ~)

# A couple of directory variables for convenience
$dotfiles = resolve-path ~/Documents/WindowsPowerShell/dotfiles/
$scripts = join-path $dotfiles "powershell"
$env:PSModulePath += ";" + (join-path $scripts modules)
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"
# Path tweaks
add-pathVariable $scripts

#Modules
Import-Module "Pscx" -Arg (join-path $scripts Pscx.UserPreferences.ps1)
. '~/Documents/WindowsPowerShell/dotfiles/powershell/modules/Jump-Location-0.5.1/Load.ps1'
. '~/Documents/WindowsPowerShell/dotfiles/powershell/modules/posh-git/profile.example.ps1'

#Aliases
Set-Alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
Set-Alias mdp "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"
Set-Alias vim "C:\Program Files (x86)\vim\vim74\vim.exe"
Set-Alias vi "C:\Program Files (x86)\vim\vim74\vim.exe"

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
	$userName = [Environment]::UserName
	$shortPath = get-vimShortPath(get-location)

	write-host $prefix -noNewLine -foregroundColor $promptTheme.prefixColor
	write-host $userName -noNewLine -foregroundColor $promptTheme.hostNameColor
	write-host ' {' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	write-host $shortPath -noNewLine -foregroundColor $promptTheme.pathColor
	write-host '}' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	write-vcsStatus # from posh-git, posh-hg and posh-svn	
	write-host ''
	return '>'
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
    if ($file.mode.Contains("h")){
        $color = "DarkGray"
    }
    $length = $file.length
    if ($file -is [System.IO.DirectoryInfo]) {
        $length = "<DIR>"
    }

	Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $length, $file.name) -foregroundcolor $color 
}

function Get-Hosts{
	start-process -verb RunAs notepad++ C:\Windows\System32\Drivers\etc\hosts
}

function lsf { dir -force }
function invoke-terminalLock { RunDll32.exe User32.dll,LockWorkStation }
function invoke-systemSleep { RunDll32.exe PowrProf.dll,SetSuspendState }
function get-GitStatus { git status }
function vim-Config { vim ~/_vimrc }

set-alias lock invoke-terminalLock
set-alias syssleep invoke-systemSleep
set-alias gs get-GitStatus

set-alias ss Switch-Website
set-alias vimc vim-Config
#cd ~
#cls





# Load Jump-Location profile
#Import-Module 'C:\Users\mradosavljevic\Documents\WindowsPowerShell\dotfiles\powershell\Modules\Jump-Location-0.5.1\Jump.Location.psd1'

