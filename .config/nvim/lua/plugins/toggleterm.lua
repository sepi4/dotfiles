return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      float_opts = {
        border = "none",
        width = function() return vim.o.columns end,
        height = function() return vim.o.lines end,
      },
    },
  },
}
