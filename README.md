# Kit d'agent autonome avec garde-fous

Un point de départ pour créer un agent IA qui travaille seul, par sessions planifiées, avec des règles strictes : il cherche des activités rentables, les teste, mesure, puis décide. Il ne touche jamais à ton argent, à tes mots de passe ni à tes comptes.

Ce kit est une base de travail, pas une promesse de revenus. Il ne garantit aucun gain.

## À quoi ça sert
- Une consigne (CLAUDE.md) qui impose la vérité sourcée, des paliers de dépense, des limites légales et un arrêt d'urgence.
- Un lanceur (`_outils/run_agent.py`) qui démarre des sessions de l'agent à heures fixes, avec budget journalier, verrou anti-doublon et pause.
- Des fichiers d'état (ETAT, JOURNAL, EXPERIENCES, SAVOIR, COMPTES, AUTORISATIONS, RAPPORT) pour que l'agent retrouve son travail après chaque session.
- Un système de points et d'effort (POINTS, EFFORT), une discipline (DISCIPLINE) et un carnet de corrections (CORRECTIONS).

## Prérequis
- Windows (le lanceur fonctionne ailleurs, l'installeur de tâches est écrit pour Windows et PowerShell).
- Python géré par `uv` (https://docs.astral.sh/uv/), et git.
- Un accès à Claude par TES propres identifiants : une clé d'API dans la variable d'environnement `ANTHROPIC_API_KEY` que tu définis toi-même, ou ta propre installation de Claude Code. Le kit ne contient aucune clé.
- Chaque utilisateur utilise ses propres identifiants et sa propre facturation. Une session coûte de l'argent réel ou use ton quota : règle le budget avant tout.

## Installation en 6 étapes
1. Copie le dossier du kit où tu veux travailler (ce sera le dossier de travail de l'agent). Ouvre-le dans un terminal.
2. Lance `git init` dans ce dossier (points de restauration locaux).
3. Personnalise : ouvre chaque fichier `.md` et remplace tous les `{{MARQUEURS}}` (CLAUDE.md surtout : nom, langue, pays, plafonds). Copie `AGENTS.exemple.json` en `AGENTS.json`.
4. Règle `_outils/run_agent.py` (bloc « PARAMÈTRES À RÉGLER » en haut) : budget, plage horaire, permissions. Garde `acceptEdits` au début.
5. Essaie à blanc, sans rien dépenser : `uv run python -I _outils/run_agent.py travail --a-blanc`. Tu vois le budget, les garde-fous et le texte envoyé à l'agent.
6. Quand tout est clair, lance `.\_outils\installer_taches.ps1`. Il te demande les heures, affiche ce qu'il créerait et ne crée rien tant que tu ne tapes pas CONFIRMER. Pour retirer les tâches : `.\_outils\installer_taches.ps1 -Retirer`.

Premier vrai essai conseillé : une seule session manuelle, `uv run --with claude-agent-sdk python -I _outils/run_agent.py veille`, puis relis JOURNAL.md.

## Personnalisation
- Profil, pays, devise, règle de secteur : CLAUDE.md.
- Paliers d'argent : section `paliers_financiers` de CLAUDE.md. Au départ, palier 0 = rien dépensé.
- Heures, budget, modèle léger, outils autorisés : haut de `run_agent.py`.
- Points et niveau d'effort : POINTS.md et EFFORT.md (tu peux les supprimer si tu n'en veux pas).
- Nouvel agent : décris-le dans AGENTS.json.

## Sécurité
Lis GUIDE_SECURITE.md avant la première session. En bref : l'agent ne paie jamais, ne crée pas de compte, ne lit pas `_secrets/`, et un fichier nommé `STOP` dans le dossier de travail l'arrête.

## Limites honnêtes
- Aucune garantie de gain. Beaucoup d'activités testées ne rapporteront rien ; c'est le but de la boucle « mesurer, puis tuer ».
- Les règles du fichier de consigne sont des instructions données à un modèle : elles réduisent les risques mais ne remplacent ni ta relecture ni les permissions du système.
- Le mode `bypassPermissions` supprime les demandes de validation. Il n'est pas le réglage par défaut ; ne l'active qu'en connaissance de cause.
- Le lanceur dérive d'un lanceur utilisé en vrai par l'auteur, mais la version générique de ce kit n'a été vérifiée qu'à blanc (`--a-blanc`) et par contrôle de syntaxe ; l'installeur de tâches n'a pas été exécuté. Rien n'est garanti sur ta configuration.
- Les noms et options du SDK d'agent de Claude Code peuvent changer : vérifie la documentation officielle si le lanceur échoue.

## Ce qui n'est pas vérifié
- Les passages juridiques (statut d'entrepreneur, prospection, protection des données, fiscalité) sont des exemples à remplacer par les règles de TON pays, lues à la source officielle. Aucun n'est présenté ici comme vérifié.
- Les conditions d'usage du SDK : proposer à d'autres personnes une connexion claude.ai (comptes d'abonnement) dans un produit tiers semble exiger l'approbation d'Anthropic. À vérifier dans la documentation officielle (https://code.claude.com/docs/en/legal-and-compliance). Si tu partages ou revends un produit construit avec ce kit, chaque utilisateur doit avoir sa clé d'API et sa propre facturation, et tu dois relire ces conditions toi-même.
- Les coûts : le budget du lanceur s'appuie sur le coût renvoyé par le SDK, non recoupé avec ta facture.
- Licence : gratuit à l'usage, redistribution et revente interdites sans accord écrit (voir LICENCE.txt, texte provisoire non relu par un juriste).
