function Switch-Website {
    <#
    .SYNOPSIS
    Switches to a specific website in IIS.
    .DESCRIPTION
    Closes running sites and starts the specified one.
    .LINK
    https://github.com/michelr/dotfiles
    .LINK
    Get-Website
    Start-Website
    Stop-Website
    #>
    param(
        [ValidateSet("Friends","SthlmStad.Intranet")]
        [Parameter(ValueFromPipeline=$true)]
        [string]$Name
    )
    Get-Website | where State -eq Started | Stop-Website
    Start-Website $Name
    Get-Website $Name
}