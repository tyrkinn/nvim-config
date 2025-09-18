return {
  'christoomey/vim-tmux-navigator',
  config = function()
    vim.cmd [[
      noremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
      noremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
      noremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
      noremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
      noremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>
    ]]
  end,
}
