# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Markdown Preview

- Plugin: `iamcco/markdown-preview.nvim` (lazy-loaded on archivos Markdown).
- Build command: `cd app && npx --yes yarn install` (se puede forzar con `:Lazy build markdown-preview.nvim`).
- Diagnóstico rápido: ejecutar `:checkhealth markdown-preview` y revisar `:messages`.
- Uso básico: abrir un `.md` y lanzar `:MarkdownPreview` / `:MarkdownPreviewToggle` / `:MarkdownPreviewStop`.
- Si el navegador no abre, seteá `vim.g.mkdp_browser` en `lua/plugins/markdown_preview.lua` con el binario deseado y volvé a probar.
