Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
. $env:ChocolateyInstall\helpers\functions\Get-EnvironmentVariable.ps1
Import-Module posh-git
Import-Module oh-my-posh
$themesPath = Get-WslPath "$(genv psmodulepath user)/oh-my-posh/3.168.3/themes"
$randTheme = "'(print (rand-nth (map #(let [s (.getName (io/file %))] (subs s 0 (-> (count s) (- (count \"".omp.json\"")))))  *input*)))'"
Set-PoshPrompt $(bash -c "ls $themesPath | bb -i $randTheme")
# Set-PoshPrompt -Theme space+tips
# $Global:PoshSettings.EnableToolTips = $true

function ddg {
    param(
	    [Parameter(ValueFromRemainingArguments)]
        [object[]] $_args
    ) ff https://duckduckgo.com/?q="$_args"
}
function Get-WslPath {
    param($1)
    $path_parts=($1 -split "\\")
    If ($path_parts[0] -match '.*:'){cmd /c set FORWSL=$1 "&" SET WSLENV=%WSLENV%:FORWSL/up "&" ubuntu run echo '$FORWSL'}
    Else {$path_parts -join "/"}
}
function emacs {param($1) ubuntu run emacs $(Get-WslPath $1)}
function vi { param($1) ubuntu run vi $(Get-WslPath $1)}
function howdoi {param([Parameter(ValueFromRemainingArguments)]
        [object[]] $_args) ubuntu run /home/nopan/.local/bin/howdoi -ac $_args}
function Winget-Search { param( $1, $f ) w search $1 $f }
function Choco-Search { param( $1, $f ) c search $1 --pre $f }
function Scoop-Search { param( $1, $f ) s search $1 $f }
function Winget-Install { param( $1, $f ) w install $1 $f }
function Scoop-Install { param( $1, $f ) s install $1 $f }
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
Set-Alias Choco-Install cinst
Set-Alias sinst Scoop-Install
Set-Alias wup Winget-Upgrade
Set-Alias Choco-Upgrade cup
Set-Alias sup Scoop-Upgrade
Set-Alias wupa Winget-UpgradeAll
Set-Alias cupa Choco-UpgradeAll
Set-Alias supa Scoop-UpgradeAll
Set-Alias .. cd..
Set-Alias l ls
Set-Alias genv Get-EnvironmentVariable
Set-Alias sa Set-Alias
sa ga Get-Alias
sa sst Scoop-Status
sa e emacs
sa how howdoi
sa psc PowerShell-Config
sa npc Notepad-Clip
sa ssv Set-Service
sa stsv Start-Service
