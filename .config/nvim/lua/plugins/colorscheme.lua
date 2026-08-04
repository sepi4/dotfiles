-- Third-party colorschemes. Set a value to false to disable one.
-- `lazy = false` keeps every variant available to :colorscheme completion.

-- Neovim's built-in schemes are always available and are not managed here.

-- Change this to select the colorscheme loaded at startup.
local active_theme = "vscode"

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = active_theme,
    },
  },
  {
    "Mofiqul/vscode.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      italic_comments = true,
      terminal_colors = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    lazy = false,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    lazy = false,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = true,
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
  },
  {
    "sainnhe/everforest",
    enabled = true,
    lazy = false,
  },
  {
    "navarasu/onedark.nvim",
    enabled = true,
    lazy = false,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    enabled = true,
    lazy = false,
  },
  {
    "xiantang/darcula-dark.nvim",
    enabled = true,
    lazy = false,
  }
}
