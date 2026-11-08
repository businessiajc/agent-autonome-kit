# Installe les tâches planifiées Windows de l'agent. NE CRÉE RIEN sans ta confirmation écrite à l'écran.
# Usage (PowerShell) : .\_outils\installer_taches.ps1
# Pour retirer les tâches : .\_outils\installer_taches.ps1 -Retirer
# Prérequis : uv installé (Get-Command uv), kit déjà personnalisé (CLAUDE.md sans marqueurs {{...}}).
param([switch]$Retirer)

$ErrorActionPreference = 'Stop'
$Prefixe = 'AgentAutonome'                       # préfixe des noms de tâches, modifiable
$Dossier = Split-Path -Parent $PSScriptRoot      # dossier du kit (aucun chemin écrit en dur)
$Script  = Join-Path $PSScriptRoot 'run_agent.py'

if ($Retirer) {
    $taches = Get-ScheduledTask | Where-Object { $_.TaskName -like "$Prefixe-*" }
    if (-not $taches) { Write-Host 'Aucune tâche à retirer.'; exit 0 }
    $taches | ForEach-Object { Write-Host ' -' $_.TaskName }
    $rep = Read-Host 'Tape SUPPRIMER pour retirer ces tâches (autre chose = annuler)'
    if ($rep -ceq 'SUPPRIMER') { $taches | Unregister-ScheduledTask -Confirm:$false; Write-Host 'Tâches retirées.' } else { Write-Host 'Annulé.' }
    exit 0
}

$uv = (Get-Command uv -ErrorAction SilentlyContinue).Source
if (-not $uv) { Write-Host 'uv est introuvable. Installe-le d''abord (voir README.md).'; exit 1 }

function Demander-Heures($mode, $defaut) {
    $saisie = Read-Host "Heures pour le mode '$mode' (format HH:MM séparées par des virgules, vide = aucune) [ex. $defaut]"
    if ([string]::IsNullOrWhiteSpace($saisie)) { return @() }
    $heures = $saisie.Split(',') | ForEach-Object { $_.Trim() }
    foreach ($h in $heures) { if ($h -notmatch '^([01]\d|2[0-3]):[0-5]\d$') { throw "Heure invalide : $h" } }
    return $heures
}

$plan = @()
foreach ($m in @(@('cycle','09:30'), @('travail','11:30,16:30'), @('veille','14:00'))) {
    foreach ($h in (Demander-Heures $m[0] $m[1])) { $plan += [pscustomobject]@{ Mode = $m[0]; Heure = $h } }
}
if (-not $plan) { Write-Host 'Aucune heure saisie, rien à faire.'; exit 0 }

Write-Host "`nTâches qui SERAIENT créées (tous les jours) :"
$arguments = { param($mode) "run --with claude-agent-sdk python -I `"$Script`" $mode" }
foreach ($p in $plan) { Write-Host (" - {0}-{1}-{2} : {3} {4}" -f $Prefixe, $p.Mode, ($p.Heure -replace ':',''), $uv, (& $arguments $p.Mode)) }
Write-Host "Dossier de travail : $Dossier"
Write-Host 'Chaque lancement consomme TON abonnement ou TA clé API (voir README.md et GUIDE_SECURITE.md).'

$rep = Read-Host "`nTape CONFIRMER pour créer ces tâches (autre chose = annuler)"
if ($rep -cne 'CONFIRMER') { Write-Host 'Annulé : rien n''a été créé.'; exit 0 }

foreach ($p in $plan) {
    $nom = "{0}-{1}-{2}" -f $Prefixe, $p.Mode, ($p.Heure -replace ':','')
    $action  = New-ScheduledTaskAction -Execute $uv -Argument (& $arguments $p.Mode) -WorkingDirectory $Dossier
    $declen  = New-ScheduledTaskTrigger -Daily -At $p.Heure
    $reglage = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 3) -MultipleInstances IgnoreNew
    Register-ScheduledTask -TaskName $nom -Action $action -Trigger $declen -Settings $reglage -Description 'Session planifiée de l''agent autonome' | Out-Null
    Write-Host "Créée : $nom"
}
Write-Host "`nTerminé. Pour tout arrêter d'urgence : crée un fichier nommé STOP dans $Dossier."
