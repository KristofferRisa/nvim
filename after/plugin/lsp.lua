-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

require'lspconfig'.pyright.setup{}

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers. 
require('lspconfig').gleam.setup({})
require('lspconfig').ocamllsp.setup({})

local cmp = require('cmp')

cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    { name = 'easy-dotnet' },
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
})

-- Easy-dotnet lsp configuration 
--
local function get_secret_path(secret_guid)
  local path = ""
  local home_dir = vim.fn.expand('~')
  if require("easy-dotnet.extensions").isWindows() then
    path = home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. secret_guid .. "\\secrets.json"
  else
    path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
  end
  return path
end

local dotnet = require("easy-dotnet")

dotnet.setup({
  get_sdk_path = get_sdk_path,
  test_runner = {
    viewmode = "float",
    enable_buffer_test_execution = true,
    noBuild = true,
    noRestore = true,
    icons = {
      passed = "",
      skipped = "",
      failed = "",
      success = "",
      reload = "",
      test = "",
      sln = "󰘐",
      project = "󰘐",
      dir = "",
      package = "",
    },
    mappings = {
      run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
      filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
      debug_test = { lhs = "<leader>d", desc = "debug test" },
      go_to_file = { lhs = "g", desc = "go to file" },
      run_all = { lhs = "<leader>R", desc = "run all tests" },
      run = { lhs = "<leader>r", desc = "run test" },
      peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
      expand = { lhs = "o", desc = "expand" },
      expand_all = { lhs = "E", desc = "expand all" },
      collapse_all = { lhs = "W", desc = "collapse all" },
      close = { lhs = "q", desc = "close test runner" },
      refresh_testrunner = { lhs = "<C-r>", desc = "refresh test runner" }
    },
    additional_args = {}
  },
  terminal = function(path, action)
    local commands = {
      run = function()
        return "dotnet run --project " .. path
      end,
      test = function()
        return "dotnet test " .. path
      end,
      restore = function()
        return "dotnet restore " .. path
      end,
      build = function()
        return "dotnet build " .. path
      end
    }
    local command = commands[action]() .. "\r"
    vim.cmd("vsplit")
    vim.cmd("term " .. command)
  end,
  secrets = {
    path = get_secret_path
  },
  csproj_mappings = true,
  fsproj_mappings = true,
  auto_bootstrap_namespace = true
})

-- Additional commands and key mappings
vim.api.nvim_create_user_command('Secrets', function()
  dotnet.secrets()
end, {})

vim.keymap.set("n", "<C-p>", function()
  dotnet.run_project()
end)
