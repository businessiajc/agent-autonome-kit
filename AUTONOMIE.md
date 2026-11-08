# AUTONOMIE : se passer de l'humain, un peu plus chaque jour, sans jamais franchir les limites

Principe : chaque jour, l'agent cherche au moins un moyen de moins dépendre de {{NOM}} (lire une source de données, automatiser un contrôle). Limites inchangées : pas de mot de passe saisi, pas de compte créé par l'agent, pas de transaction. {{NOM}} place les accès dans un fichier de _secrets/ (hors git), avec la portée la plus limitée possible.

## Tableau
| Idée | Gain | Ce qu'il faut de {{NOM}} | Statut |
|---|---|---|---|
| (exemple) Lire les statistiques d'un site par une API en lecture seule | Décisions sans capture d'écran | Créer un accès en lecture seule, déposer la clé dans _secrets/ | À FAIRE |
| (exemple) Suivre l'état d'un déploiement par une API publique sans authentification | Détecter un échec après publication | rien | À FAIRE |

## Règles pour tout accès donné à l'agent
1. Portée minimale : lecture seule si possible. Un accès en écriture doit être justifié par écrit dans AUTORISATIONS.md.
2. La clé vit dans _secrets/ (jamais dans git, jamais dans le chat, jamais affichée par l'agent).
3. Un accès se révoque chez le fournisseur : savoir où, avant de le créer.
4. Le script de lecture est court, relisible, sans écriture. Voir _outils/lecture_seule_exemple.py.
5. Vérifier à la source officielle du service ce que l'accès permet vraiment (portée, quotas). Marquer NON VÉRIFIÉ tant que ce n'est pas lu.
