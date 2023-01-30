-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd [[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]]

-- import packer safely
local status, packer = pcall(require, 'packer')
if not status then
  return
end

-- add list of plugins to install
return packer.startup(function(use)
  -- packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim' -- lua functions that many plugins use

  -- THEME
  use 'bluz71/vim-nightfly-guicolors' -- preferred colorscheme

  use 'christoomey/vim-tmux-navigator' -- tmux & split window navigation
  use 'szw/vim-maximizer' -- maximizes and restores current window
  use 'tpope/vim-surround' -- add, delete, change surroundings (it's awesome)
  use 'inkarkat/vim-ReplaceWithRegister' -- replace with register contents using motion (gr + motion)
  use 'numToStr/Comment.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- dependency for better sorting performance
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x' } -- fuzzy finder
  -- snippets
  use 'L3MON4D3/LuaSnip' -- snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- for autocompletion
  use 'rafamadriz/friendly-snippets' -- useful snippets
  -- managing & installing lsp servers, linters & formatters
  use 'williamboman/mason.nvim' -- in charge of managing lsp servers, linters & formatters
  use 'williamboman/mason-lspconfig.nvim' -- bridges gap b/w mason & lspconfig
  -- configuring lsp servers
  use 'neovim/nvim-lspconfig' -- easily configure language servers

  use 'simrat39/rust-tools.nvim'

  -- Completion framework:
  use 'hrsh7th/nvim-cmp'

  -- LSP completion source:
  use 'hrsh7th/cmp-nvim-lsp'

  -- Useful completion sources:
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'

  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('lspsaga').setup {}
    end,
    requires = { { 'nvim-tree/nvim-web-devicons' } },
  }

  use 'jose-elias-alvarez/typescript.nvim' -- additional functionality for typescript server (e.g. rename file & update imports)
  use 'onsails/lspkind.nvim' -- vs-code like icons for autocompletion
  -- formatting & linting
  use 'jose-elias-alvarez/null-ls.nvim' -- configure formatters & linters
  use 'jayp0521/mason-null-ls.nvim' -- bridges gap b/w mason & null-ls
  -- treesitter configuration
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update { with_sync = true }
      ts_update()
    end,
  }
  use 'windwp/nvim-autopairs' -- autoclose parens, brackets, quotes, etc...
  use { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' } -- autoclose tags
  use 'lewis6991/gitsigns.nvim' -- show line modifications on left hand side
  use 'lukas-reineke/indent-blankline.nvim'

  -- https://github.com/voldikss/vim-floaterm#installation
  use 'voldikss/vim-floaterm'

  use 'github/copilot.vim'

  -- tabs
  use { 'romgrk/barbar.nvim', wants = 'nvim-web-devicons' }

  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  -- https://github.com/phaazon/mind.nvim#installation
  use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim' },
    config = function()
      require('mind').setup()
    end,
  }

  -- vim be good
  use 'ThePrimeagen/vim-be-good'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
