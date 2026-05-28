#!/usr/bin/env bash
set -euo pipefail

# Instala las skills de Superpowers (obra/superpowers) en Antigravity (agy),
# que no tiene sistema de plugins. Re-correr el script actualiza a la última versión.
#
# Pinnear una versión concreta (tag o branch):
#   SUPERPOWERS_REF=v5.1.0 ./install-superpowers-agy.sh

REPO="https://github.com/obra/superpowers.git"
REF="${SUPERPOWERS_REF:-main}"
DEST="$HOME/.gemini/antigravity-cli/skills"

command -v git >/dev/null 2>&1 || {
    echo "Error: git no está instalado." >&2
    exit 1
}

# Guard: agy necesita una carpeta REAL acá. Si DEST es un symlink (p.ej.
# apuntando al repo), copiar acá contaminaría el repo con las skills. Abortar.
if [ -L "$DEST" ]; then
    echo "Error: $DEST es un symlink -> $(readlink "$DEST")" >&2
    echo "agy necesita una carpeta REAL acá, no un symlink al repo." >&2
    echo "Arreglalo:  rm \"$DEST\" && mkdir -p \"$DEST\"  y re-corré el script." >&2
    exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Clonando obra/superpowers ($REF)..."
git clone --quiet --depth 1 --branch "$REF" "$REPO" "$tmp" 2>/dev/null ||
    git clone --quiet --depth 1 "$REPO" "$tmp"

src="$tmp/skills"
[ -d "$src" ] || {
    echo "Error: no se encontró skills/ en el repo de Superpowers." >&2
    exit 1
}

mkdir -p "$DEST"

count=0
for skill in "$src"/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    # Refresca solo esta skill; nunca borra todo el dir, así las skills
    # custom (handoff, review-comments, etc.) que vivan ahí no se tocan.
    rm -rf "${DEST:?}/$name"
    cp -R "${skill%/}" "$DEST/$name"
    count=$((count + 1))
    echo "  ✓ $name"
done

echo ""
echo "Listo: $count skills de Superpowers instaladas en $DEST"
