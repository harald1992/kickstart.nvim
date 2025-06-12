SHOW_PANEL = true
TERMINAL_BUF_ID = 0
vim.keymap.set('n', '<leader>tp', function()
  vim.cmd ':CopilotChatToggle'

  if SHOW_PANEL then
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
      print('win: ' .. win)
      local buf_id = vim.api.nvim_win_get_buf(win)

      local buftype = vim.bo[buf_id].buftype -- Get the 'buftype' of the buffer
      if buftype == 'terminal' then
        print('buf_id=' .. buf_id)
        vim.api.nvim_set_current_win(win) -- switch to buffer
        vim.cmd 'hide'
        TERMINAL_BUF_ID = buf_id
        SHOW_PANEL = false
      end
    end
  else
    vim.cmd 'split' -- splits horizontal so new tab at bottom and adds terminal.
    vim.cmd 'wincmd j' -- move back to the top split
    vim.cmd('buffer ' .. TERMINAL_BUF_ID)
    SHOW_PANEL = true
  end
end, { desc = 'Toggle Panel Copilot+Terminal' })

-- vim.api.nvim_create_autocmd('TermOpen', {
--   callback = function()
--     vim.opt.number = false
--     vim.opt.relativenumber = false
--   end,
-- })

-- Ensure we can still use command inside lazygit.
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    -- only set <Esc> to go to normal mode in normal terminal, not in lazygit.
    local buffername = vim.api.nvim_buf_get_name(0)
    if string.find(buffername, 'lazygit') then
    else
      local buf_id = vim.api.nvim_get_current_buf()
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = buf_id, desc = 'Exit terminal mode' })
    end
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Open right pane with copilot and terminal',
  callback = function()
    require('lazy').load { plugins = { 'CopilotChat.nvim' } }

    vim.cmd "echo 'Welcome Harald!'"
    vim.cmd ':CopilotChat open'
    vim.wo.number = false -- set the copilot window line numbers to false

    vim.cmd 'split | term' -- splits horizontal so new tab at bottom and adds terminal.

    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = vim.api.nvim_get_current_buf(), desc = 'Exit terminal mode' }) -- override the keymap since TermOpen listener seems to emit after VimEnter completes.
    vim.wo.number = false -- set the terminal window line numbers to false

    vim.cmd 'wincmd h' -- move back to the top split
    vim.cmd 'vertical resize +25'
    vim.cmd 'set cmdheight=8'
  end,
})

SHOW_NEOTREE = false
vim.keymap.set('n', '<leader>tn', function()
  if SHOW_NEOTREE == false then
    vim.cmd ':Neotree reveal left'
    SHOW_NEOTREE = true
  else
    vim.cmd ':Neotree close'
    SHOW_NEOTREE = false
  end
end, { desc = '[t]oggle [n]eotree' })

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    if SHOW_NEOTREE and vim.bo.buftype == '' then
      vim.cmd ':Neotree reveal left show' -- reveal open folder and keep focus on the current buffer.
    end
  end,
})
