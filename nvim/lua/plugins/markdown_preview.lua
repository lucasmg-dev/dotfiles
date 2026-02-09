return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
    config = function()
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_browser = ""
      vim.g.mkdp_auto_close = 0
    end,
  },
}
