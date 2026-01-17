-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    -- colorscheme = "astrodark",
    colorscheme = "vscode",
    -- colorscheme = "tokyonight-night",
    -- colorscheme = "overtones",
    -- colorscheme = "darcula",
    -- colorscheme = "nofrils-dark",
    -- colorscheme = "nofrils-light",
    -- colorscheme = "lackluster-night",
    -- colorscheme = "sepi-material-2",
    -- colorscheme = "kanagawabones",
    -- colorscheme = "default",
    -- colorscheme = "neosolarized",
    -- colorscheme = "solarized-osaka",
    -- color
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        Normal = { bg = "#000000" },
      },
      default = { -- a table of overrides/changes when applying the astrotheme theme
        StatusLine = { fg = "#ffffff", bg = "#262626" },
        NonText = { fg = "#262626" },
      },
      kanagawabones = {
        Normal = { bg = "#000000" },
        StatusLine = { fg = "#ff00ff", bg = "#262626" },
      },
      ["nofrils-dark"] = {
        StatusLine = { fg = "#ff00ff", bg = "#262626" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
