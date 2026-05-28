#!/usr/bin/env bash
set -euo pipefail

# Instala la skill UI/UX Pro Max (nextlevelbuilder/ui-ux-pro-max-skill) en los
# 3 agentes. La skill NO es copy-paste: el CLI oficial (uipro-cli) la ENSAMBLA
# por plataforma (SKILL.md templado + scripts + data CSV). Por eso usamos el CLI
# para ensamblar en un staging temporal y copiamos al dir real de cada agente
# (los paths del CLI no coinciden con nuestro layout). Re-correr = actualizar.
#
# Pinnear versión:  UIPRO_VERSION=2.5.0 ./install-ui-ux-pro-max.sh

UIPRO="uipro-cli@${UIPRO_VERSION:-latest}"
SKILL="ui-ux-pro-max"

command -v npx >/dev/null 2>&1 || {
    echo "Error: npx (Node.js) no está instalado." >&2
    exit 1
}

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

# install_one <plataforma-cli> <carpeta-que-genera-el-cli> <dir-destino-del-agente>
install_one() {
    local platform="$1" folder="$2" dest="$3"
    local work="$stage/$platform"
    mkdir -p "$work"

    if ! (cd "$work" && npx --yes "$UIPRO" init --ai "$platform" --force) >/dev/null 2>&1; then
        echo "  ✗ $platform: falló uipro-cli" >&2
        return 1
    fi

    local src="$work/$folder/skills/$SKILL"
    if [ ! -d "$src" ]; then
        echo "  ✗ $platform: el CLI no generó la skill en $folder/skills/" >&2
        return 1
    fi

    mkdir -p "$dest"
    rm -rf "${dest:?}/$SKILL"
    cp -R "$src" "$dest/$SKILL"
    echo "  ✓ $platform -> $dest/$SKILL"
}

echo "Instalando UI/UX Pro Max en los 3 agentes (vía $UIPRO)..."
fail=0
install_one claude      ".claude"   "$HOME/.claude/skills" || fail=1
install_one opencode    ".opencode" "$HOME/.agents/skills" || fail=1
install_one antigravity ".agent"    "$HOME/.gemini/antigravity-cli/skills" || fail=1

echo ""
if [ "$fail" -eq 0 ]; then
    echo "Listo: UI/UX Pro Max instalada en los 3 agentes."
else
    echo "Terminado con errores (ver arriba)." >&2
fi
exit "$fail"
