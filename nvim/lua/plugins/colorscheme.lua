return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "main", -- variante dark clásica. Otras: "moon" (dark suave), "dawn" (light).
    dark_variant = "main",
    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.o.background = "dark"
    vim.cmd.colorscheme("rose-pine")
  end,
}
