Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git
$global:GitPromptSettings.WorkingForegroundColor      = [ConsoleColor]::Red 
$global:GitPromptSettings.UntrackedForegroundColor    = [ConsoleColor]::Red
$global:GitPromptSettings.BranchBehindForegroundColor = [ConsoleColor]::Red
$global:GitPromptSettings.BranchForegroundColor       = [ConsoleColor]::DarkYellow
$global:GitPromptSettings.BranchAheadForegroundColor  = [ConsoleColor]::Green
$global:GitPromptSettings.BeforeIndexForegroundColor  = [ConsoleColor]::Green
$global:GitPromptSettings.IndexForegroundColor        = [ConsoleColor]::Green

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
