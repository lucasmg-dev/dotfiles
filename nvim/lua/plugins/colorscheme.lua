return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "frappe",
    transparent_background = false,
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      telescope = true,
      mason = true,
      which_key = true,
      native_lsp = { enabled = true },
      notify = true,
      mini = { enabled = true },
      lsp_trouble = true,
      indent_blankline = { enabled = true },
      flash = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-frappe")
  end,
}
