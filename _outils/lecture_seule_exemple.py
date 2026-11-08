"""Modèle de lecteur en LECTURE SEULE d'un service externe (exemple à adapter).
Principes : une seule méthode HTTP (GET), HTTPS obligatoire, la clé est lue dans _secrets/ et n'est jamais affichée,
aucune écriture chez le service. Avant de l'adapter, lis la documentation officielle du service pour confirmer
ce que la clé permet (portée, quotas) et comment la révoquer.

Usage : uv run python -I _outils/lecture_seule_exemple.py
Réglages ci-dessous. Le fichier de clé doit être créé par TOI, pas par l'agent."""
import sys, json, urllib.request, urllib.parse, pathlib

CLE = pathlib.Path(__file__).resolve().parent.parent / "_secrets" / "service.txt"   # une ligne : la clé
URL_DE_BASE = "{{URL_HTTPS_DU_SERVICE}}"      # ex. l'adresse https de l'API en lecture
EN_TETE_AUTH = "Authorization"                 # selon la doc du service
PREFIXE_AUTH = ""                              # selon la doc du service (certains services exigent un préfixe avant la clé)


def lire(chemin, params=None, delai=20):
    """GET uniquement. Refuse tout autre schéma que https. N'affiche jamais la clé."""
    if not URL_DE_BASE.lower().startswith("https://"):
        raise ValueError("URL_DE_BASE doit être une adresse https (réglage non fait ou non sûr).")
    url = URL_DE_BASE.rstrip("/") + "/" + chemin.lstrip("/")
    if params:
        url += "?" + urllib.parse.urlencode(params)
    cle = CLE.read_text(encoding="utf-8").strip()
    req = urllib.request.Request(url, method="GET", headers={EN_TETE_AUTH: PREFIXE_AUTH + cle, "Accept": "application/json"})
    with urllib.request.urlopen(req, timeout=delai) as r:
        return json.loads(r.read().decode("utf-8"))


if __name__ == "__main__":
    try:
        print(json.dumps(lire(sys.argv[1] if len(sys.argv) > 1 else "/"), ensure_ascii=False, indent=2)[:4000])
    except Exception as e:
        print("Erreur :", type(e).__name__, str(e)[:200])   # jamais la clé
        sys.exit(1)
