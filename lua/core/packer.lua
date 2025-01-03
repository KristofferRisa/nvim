-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
	    use 'wbthomason/packer.nvim'
	    use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = {{'nvim-lua/plenary.nvim'}}
	    }
	    use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
		    vim.cmd('colorscheme rose-pine')
		end
	    })
	    use('nvim-treesitter/nvim-treesitter', {
		run = ':TSUpdate'
	    })
	    use('theprimeagen/harpoon')
	    use('mbbill/undotree')
	    use('tpope/vim-fugitive')
	   use {
		"GustavEikaas/easy-dotnet.nvim",
		requires = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
		config = function()
		    require("easy-dotnet").setup()
		end
	   }
	    use({
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x'
	    })
	    use({'neovim/nvim-lspconfig'})
	    use({'hrsh7th/nvim-cmp'})
	    use({'hrsh7th/cmp-nvim-lsp'})
	    use {
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
		    require("nvim-autopairs").setup {}
		end
	    }
	    use "lukas-reineke/indent-blankline.nvim"
	    use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim" -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	}
	use 'mfussenegger/nvim-dap'
	use {
	  'doctorfree/cheatsheet.nvim',
	  requires = {
	    {'nvim-telescope/telescope.nvim'},
	    {'nvim-lua/popup.nvim'},
	    {'nvim-lua/plenary.nvim'},
	  }
	}
end)


