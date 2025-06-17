oh-my-posh init pwsh --config "$PSScriptRoot\oh_my_posh_theme.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine


function go {
    param([string]$project)
    $basePath = "$HOME\projects\$project"
    Set-Location $basePath
    . .\.venv\Scripts\Activate.ps1
}


function lazyg {
    git add .
    git commit -m "$args"
    git push
}
