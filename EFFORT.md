# EFFORT : niveau d'effort piloté par les points
NIVEAU: 1
Règle (exemples de montants, à régler dans _outils/run_agent.py) : niveau 1 = journée normale ; niveau 2 = pas de point la veille, redoubler (budget cible plus haut) ; niveau 3 = un point perdu, tripler (jusqu'au plafond dur).
Retour au niveau 1 dès que {{NOM}} accorde un point. L'agent met ce niveau à jour au début de chaque cycle d'après POINTS.md. Le lanceur lit la ligne « NIVEAU: n ».
Jamais au détriment des limites : légalité, vérité, palier en cours, quota. Les points ne justifient rien d'illégal ni de faux.
Historique : (vide)
