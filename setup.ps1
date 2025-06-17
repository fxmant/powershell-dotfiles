Set-StrictMode -Version Latest

# Constants
$dotfilesPath = $PSScriptRoot
$dotfilesProfile = "$dotfilesPath\profile.ps1"
$userProfile = $PROFILE

function Install-Scoop {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    } else {
        Write-Host "Scoop already installed."
    }
}

function Install-NerdFont {
    Write-Host "Installing FiraCode Nerd Font..."
    scoop bucket add nerd-fonts
    scoop install Cascadia-Code
    Write-Host "⚠️  Set your terminal font to 'Cascadia-Code Nerd Font' manually." -ForegroundColor Yellow
}


function Install-Tools {
    Write-Host "Installing other tools..."
    scoop bucket add extras
    scoop install oh-my-posh
    Install-Module -Name Terminal-Icons -Scope CurrentUser
    Install-Module -Name PSReadLine -Scope CurrentUser
}


function Build-Profile {
    $dotfilesProfile = Join-Path $PSScriptRoot 'profile.ps1'

    # Ensure user profile file exists
    if (-not (Test-Path $userProfile)) {
        New-Item -ItemType File -Path $userProfile -Force | Out-Null
    }

    $dotSourceLine = ". `"$dotfilesProfile`""
    # Read all lines (as an array to avoid Raw issues with empty files)
    $currentLines = Get-Content $userProfile -ErrorAction SilentlyContinue

    if (-not ($currentLines | Where-Object { $_ -eq $dotSourceLine })) {
        Write-Host "Linking PowerShell profile to: $dotfilesProfile"
        Add-Content $userProfile "`n$dotSourceLine"
    } else {
        Write-Host "PowerShell profile is already linked to dotfiles."
    }
}

# Run all steps
Install-Scoop
Install-NerdFont
Install-Tools
Build-Profile

Write-Host "Successfully set up your PowerShell environment." -ForegroundColor Green
Write-Host "Restart your terminal to see changes take effect." -ForegroundColor Cyan
