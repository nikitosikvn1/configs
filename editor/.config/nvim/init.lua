-- Disable the default action for the Space key in normal mode
vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
-- Set Space as the leader key for custom mappings
vim.g.mapleader = ' '

-- Disable code folding by default
vim.opt.foldenable = false
-- Set manual folding method, requiring explicit fold commands
vim.opt.foldmethod = 'manual'
-- -- Start with all folds open by setting the initial fold level to a high number
vim.opt.foldlevelstart = 99

-- Set the minimum number of lines to keep above and below the cursor
vim.opt.scrolloff = 2
-- Disable line wrapping. Long lines will not wrap and will scroll horizontally
vim.opt.wrap = false
-- Always display the sign column
vim.opt.signcolumn = 'yes'
-- Enable relative line numbers for easier navigation
vim.opt.relativenumber = true
-- Show the absolute line number for the current line
vim.opt.number = true

-- Open new horizontal splits to the right of the current window
vim.opt.splitright = true
-- Open new vertical splits below the current window
vim.opt.splitbelow = true

-- Enable persistent undo, saving undo history to a file
-- NOTE: Undo files are stored in ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- In completion, when there is more than one match,
-- list all matches, and only complete to the longest common match
vim.opt.wildmode = 'list:longest'
-- When opening a file with a command (like :e),
-- don't suggest files with these patterns
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.vb = true

vim.opt.diffopt:append('iwhite')
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

vim.opt.colorcolumn = '80'
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })

vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- main color scheme
    {
        "wincent/base16-nvim",
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
            vim.o.background = 'dark'

            -- Make comments more prominent -- they are important.
            -- local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
            -- vim.api.nvim_set_hl(0, 'Comment', bools)

            -- Make it clearly visible which argument we're at.
            local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
            vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
        end
    },
    -- nice bar at the bottom
    {
        'itchyny/lightline.vim',
        lazy = false, -- also load at start since it's UI
        config = function()
            -- no need to also show mode in cmd line when we have bar
            vim.o.showmode = false
            vim.g.lightline = {
                active = {
                    left = {
                        { 'mode', 'paste' },
                        { 'readonly', 'filename', 'modified' }
                    },
                    right = {
                        { 'lineinfo' },
                        { 'percent' },
                        { 'fileencoding', 'filetype' }
                    },
                },
                component_function = {
                    filename = 'LightlineFilename'
                },
            }
            function LightlineFilenameInLua(opts)
                if vim.fn.expand('%:t') == '' then
                    return '[No Name]'
                else
                    return vim.fn.getreg('%')
                end
            end
            -- https://github.com/itchyny/lightline.vim/issues/657
            vim.api.nvim_exec(
                [[
                function! g:LightlineFilename()
                    return v:lua.LightlineFilenameInLua()
                endfunction
                ]],
                true
            )
        end
    },
})
