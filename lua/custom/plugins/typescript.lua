return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
  config = function()
    local api = require 'typescript-tools.api'
    vim.keymap.set('n', '<leader>if', api.add_missing_imports)
  end,
}
