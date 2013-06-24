invoke-elevated {
	Import-Module Pscx
	new-symlink ~\.gitconfig ..\..\.gitconfig
}