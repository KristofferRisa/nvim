vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', '<leader>e', function()
  require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
end, { noremap = true, silent = true, desc = "Toggle NeoTree" })

-- Comment toggle function
vim.api.nvim_set_keymap(
  "n", "<leader>/",
  "gcc", 
  { noremap = false, silent = true, desc = "Toggle Comment" }
)

-- For visual mode
vim.api.nvim_set_keymap(
  "v", "<leader>/",
  "gc", 
  { noremap = false, silent = true, desc = "Toggle Comment" }
)

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
