vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', '<leader>e', function()
  require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
end, { noremap = true, silent = true, desc = "Toggle NeoTree" })
