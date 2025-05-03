return {
  { -- you can easily change to a different colorscheme.
    -- change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- if you want to see what colorschemes are already installed, you can use `:telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- disable italics in comments
        },
      }

      -- load the colorscheme here.
      -- like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'retrobox'
      vim.cmd.colorscheme 'tokyonight-day'
    end,
  },
}
