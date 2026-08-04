-- The lazyvim markdown extra (lazyvim.plugins.extras.lang.markdown) installs
-- markdownlint-cli2 and wires it into nvim-lint, which produces noisy
-- MD0xxx warnings/errors in every markdown file. We don't want that linting,
-- so clear it for markdown and markdown.mdx here.
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      -- empty list = no linters run for markdown
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
  {
    -- drop markdownlint-cli2 from the formatter list too, keep prettier
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.markdown = { "prettier" }
      opts.formatters_by_ft["markdown.mdx"] = { "prettier" }
    end,
  },
}
