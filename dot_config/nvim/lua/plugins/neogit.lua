return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  opts = {
    integrations = {
      diffview = true,
    },
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit status" }
  }
}
