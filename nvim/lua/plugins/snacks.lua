return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = false,
          },
          files = {
            hidden = true,
            ignored = false,
            exclude = { "node_modules", ".git", ".cache" },
          },
        },
      },
    },
  },
}
