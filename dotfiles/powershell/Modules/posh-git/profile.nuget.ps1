Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git
$global:GitPromptSettings.WorkingForegroundColor      = [ConsoleColor]::DarkRed 
$global:GitPromptSettings.UntrackedForegroundColor    = [ConsoleColor]::DarkRed
$global:GitPromptSettings.BranchBehindForegroundColor = [ConsoleColor]::DarkRed
$global:GitPromptSettings.BranchForegroundColor       = [ConsoleColor]::DarkCyan
$global:GitPromptSettings.BranchAheadForegroundColor  = [ConsoleColor]::DarkGreen
$global:GitPromptSettings.BeforeIndexForegroundColor  = [ConsoleColor]::DarkGreen
$global:GitPromptSettings.IndexForegroundColor        = [ConsoleColor]::DarkGreen
# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet