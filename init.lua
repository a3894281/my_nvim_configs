-- Install packer if not installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

-- init.lua
require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- VS Code theme
  use 'Mofiqul/vscode.nvim'

  -- File explorer (like VS Code's file browser)
  use "nvim-tree/nvim-tree.lua"

  -- Statusline (like VS Code's bottom bar)
  use "nvim-lualine/lualine.nvim"

  -- Tabline (for a VS Code-like tab experience)
  use "akinsho/bufferline.nvim"

  -- LSP and Autocompletion
  use "neovim/nvim-lspconfig" -- Collection of configurations for built-in LSP client
  use "hrsh7th/nvim-cmp" -- Autocompletion plugin
  use "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp

  -- Icons for nvim-tree and bufferline
  use "kyazdani42/nvim-web-devicons"

  -- Fuzzy Finder (like VS Code's quick open)
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }

  -- Template Toolkit
  use "vim-perl/vim-perl"

  -- Python Linting, Autocompletion, etc.
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- Conda environment management
  use ({
    "kmontocam/nvim-conda",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Git
  use 'lewis6991/gitsigns.nvim'

end)

-- Set theme
-- Lua:
-- For dark theme (neovim's default)
vim.o.background = 'dark'

local c = require('vscode.colors').get_colors()
require('vscode').setup({

   -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
-- require('vscode').load()

-- load the theme without affecting devicon colors.
vim.cmd.colorscheme "vscode"

-- Configure nvim-tree (File Explorer)
require("nvim-tree").setup({
  view = {
    side = "left",
    width = 30,
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
      },
    },
  },
})

-- Configure lualine (Statusline)
require("lualine").setup({
  options = {
    theme = "vscode",
    section_separators = "",
    component_separators = "",
  },
})

-- Configure bufferline (Tabline)
require("bufferline").setup({
  options = {
    separator_style = "slant",
    diagnostics = "nvim_lsp",
    show_close_icon = false,
    show_buffer_close_icons = false,
  },
})

-- Configure Telescope (Fuzzy Finder)
require("telescope").setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "smart" },
  },
})

-- Configure LSP and Autocompletion
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.ts_ls.setup({})
-- Add additional language servers as needed

-- Additional Settings for VS Code-like Experience
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.cursorline = true     -- Highlight the current line

-- Keymaps for easier navigation
vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Template Toolkit
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.tt",
  command = "setfiletype tt2"
})


-- Configure coc.nvim for Python
vim.g.coc_global_extensions = { 'coc-python' }

-- Configure Git
require('gitsigns').setup()
