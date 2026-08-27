return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = { -- Making lazy git wasting less space
        win = {
          width = 0,
          height = 0,
        },
      },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
