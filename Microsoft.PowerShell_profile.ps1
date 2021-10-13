# Search engine
function ddg {
    param(
        [Parameter(ValueFromRemainingArguments)]
        [object[]] $_args
    ) ff https://duckduckgo.com/?q="$_args"
}

function Get-WslPath {
    # WSL Path translate
    param($1)
    $path_parts=($1 -split "\\")
    If ($path_parts[0] -match '.*:'){cmd /c set FORWSL=$1 "&" SET WSLENV=%WSLENV%:FORWSL/up "&" ubuntu run echo '$FORWSL'}
    Else {$path_parts -join "/"}
}

# Functions to call WSL programs
function emacs {param($1) ubuntu run zsh -l ~/.oh-my-zsh/plugins/emacs/emacsclient.sh $(Get-WslPath $1)}
function vi { param($1) ubuntu run vi $(Get-WslPath $1)}
function howdoi {param([Parameter(ValueFromRemainingArguments)]
        [object[]] $_args) wsl zsh -lc "~/.local/bin/howdoi -ac $_args"}
function git {param([Parameter(ValueFromRemainingArguments)]
        [object[]] $_args) wsl zsh -lc "git $_args"}

# Prepare functions to set aliases
function Winget-Search { param( $1, $f ) w search $1 $f }
function Choco-Search { param( $1, $f ) c search $1 --pre $f }
function Scoop-Search { param( $1, $f ) s search $1 $f }
function Winget-Install { param( $1, $f ) w install $1 $f }
function Scoop-Install { param( $1, $f ) s install $1 $f }
function Winget-Uninstall { param( $1, $f ) w uninstall $1 $f }
function Scoop-Uninstall { param( $1, $f ) s uninstall $1 $f }
function Winget-Upgrade { param( $1, $f ) w upgrade $1 $f }
function Scoop-Upgrade { param( $1, $f ) s update $1 $f }
function Winget-UpgradeAll { param($f) w upgrade --all $f }
function Choco-UpgradeAll { param($f) sudo choco upgrade all --pre -y $f }
function Scoop-UpgradeAll { param($f) s update * $f }
function Scoop-Status {s status}
function Get-UserVariables {reg query HKCU\environment}
function Get-SystemVariables {reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"}
function PowerShell-Config {e $PROFILE}
function Notepad-Clip {np $env:USERPROFILE\clip}

function Set-WallPaper($Image) {
    # Script to set Windows background
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Params
    {
        [DllImport("User32.dll",CharSet=CharSet.Unicode)]
        public static extern int SystemParametersInfo (Int32 uAction,
                                                       Int32 uParam,
                                                       String lpvParam,
                                                       Int32 fuWinIni);
    }
"@

    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02

    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

Set-Alias -Name np -Value C:\Windows\notepad.exe
Set-Alias -Name ff -Value firefox-nightly.exe
Set-Alias -Name mse -Value msedge.exe
Set-Alias w winget
Set-Alias c choco
Set-Alias s scoop
Set-Alias ws Winget-Search
Set-Alias cs Choco-Search
Set-Alias ss Scoop-Search
Set-Alias winst Winget-Install
Set-Alias wuninst Winget-Uninstall
Set-Alias Choco-Install cinst
Set-Alias sinst Scoop-Install
Set-Alias suninst Scoop-Uninstall
Set-Alias wup Winget-Upgrade
Set-Alias Choco-Upgrade cup
Set-Alias sup Scoop-Upgrade
Set-Alias wupa Winget-UpgradeAll
Set-Alias cupa Choco-UpgradeAll
Set-Alias supa Scoop-UpgradeAll
Set-Alias .. cd..
Set-Alias l ls
Set-Alias sa Set-Alias          # Short form
sa wpwsh powershell
sa ga Get-Alias
sa sst Scoop-Status
sa e emacs
sa how howdoi
sa psc PowerShell-Config
sa npc Notepad-Clip
sa ssv Set-Service
sa stsv Start-Service
sa _ sudo

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
    . $env:ChocolateyInstall\helpers\functions\Get-EnvironmentVariable.ps1
    Set-Alias genv Get-EnvironmentVariable
}

# Style prompt
Import-Module oh-my-posh
$themesPath = Get-WslPath "$(genv psmodulepath user)/oh-my-posh/3.168.3/themes"
$randTheme = "'(print (#(subs % 0 (-> (count %) (- (count \"".omp.json\""))))
                        (rand-nth *input*)))'"
Set-PoshPrompt $(bash -c "ls $themesPath | bb -i $randTheme")
