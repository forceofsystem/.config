                                       "_           
 "_ __ ___  _   _ _ __   ___  _____   _(_)_ __ ___  
"| '_ ` _ \| | | | '_ \ / _ \/ _ \ \ / / | '_ ` _ \ 
"| | | | | | |_| | | | |  __/ (_) \ V /| | | | | | |
"|_| |_| |_|\__, |_| |_|\___|\___/ \_/ |_|_| |_| |_|
           "|___/                                   
" @Author: Patrick Zhang

" =============================
" =======editor behavior=======
" =============================
let mapleader=' '
syntax on


set number
set relativenumber
set cursorline "display a line under current line
set wrap
set showcmd
set wildmenu " display a menu when enter vim command
set smartcase
set nocompatible
set encoding=utf-8
set tabstop=8
set shiftwidth=8
set scrolloff=5
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set laststatus=0
set autochdir
set background=dark
set autowrite
set list

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

let &t_ut=''

" search settings
set hlsearch
set incsearch
exec "nohlsearch"
noremap <LEADER><CR> :nohlsearch<CR>

" basic keybinding
noremap j h
noremap k j
noremap l k
noremap ; l
noremap h :

map s <nop>

map sl :set nosplitbelow<CR>:split<CR>
map sk :set splitbelow<CR>:split<CR>
map sj :set nosplitright<CR>:vsplit<CR>
map s; :set splitright<CR>:vsplit<CR>

map <LEADER>u :tabe<CR>
map <LEADER>K :-tabnext<CR>
map <LEADER>L :+tabnext<CR>

""" A trick to convinent change
map <LEADER><LEADER> <ESC>/<CR>:nohlsearch<CR>c4;

""" When I open a file, the mouse will jump to last location where I exited before.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"=============================
"=======My  Settings======
"=============================
call plug#begin()
""" beautify

" A strengthen tool for syntax hight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" vim theme
Plug 'Mofiqul/dracula.nvim'

""" make my programming convinent
" code snippets
Plug 'honza/vim-snippets'

" Simplifying choosing context
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-unimpaired'

" To quickly comment many lines
Plug 'preservim/nerdcommenter'

" Track Changing
Plug 'mbbill/undotree'

" Git
Plug 'lewis6991/gitsigns.nvim'

""" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'

call plug#end()



"================================
"=======LSP Configuration======
"================================

" ==============
" ===coc-nvim===
" ==============
let g:coc_global_extensions = [
      \'coc-json', 
      \'coc-clangd',
	\'coc-vimlsp'
      \]
" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-o> coc#refresh()

"Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Hight the symbol and its references when holding the cursor.将同名称变量高亮
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.重命名变量
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.调整格式
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  "" Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "" Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open' .a:type
  endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" =====================
" === rust.vim 配置 ===
" =====================

" 保存时代码自动格式化
let g:rustfmt_autosave = 1

" 手动调用格式化， Visual 模式下局部格式化，Normal 模式下当前文件内容格式化
" 有时候代码有错误时，rust.vim 不会调用格式化，手动格式化就很方便
vnoremap <leader>ft :RustFmtRange<CR>
nnoremap <leader>ft :RustFmt<CR>
" 设置编译运行 (来自 rust.vim，加命令行参数则使用命令 `:RustRun!`)
nnoremap <LEADER>rr :RustRun<CR>
" 使用 `:verbose nmap <M-t>` 检测 Alt-t是否被占用
" 使用 `:verbose nmap` 则显示所有快捷键绑定信息
nnoremap <LEADER>rt :RustTest<CR>





" ============================
" === Other Plugins Config ===
" ============================

" =====================
" === nerdcommenter ===
" =====================
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1



" =================
" === Undo Tree ===
" =================
map vv :UndotreeToggle<CR>




" ======================
" ===Personal Config====
" ======================

"autocompile on save
noremap <LEADER>r :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        if &filetype == 'markdown'
                exec "MarkdownPreviewToggle"
        elseif &filetype == 'javascript'
                set splitbelow
                :sp
                :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
        elseif &filetype == 'html'
                silent! exec "!open %"
        endif
endfunc



" Generate Database of Compilation's Info 
function! s:generate_compile_commands()
        if empty(glob('CMakeLists.txt'))
                echo "Can't find CMakeLists.txt"
                return
        endif
        if empty(glob('.compile_info'))
                exec 'silent !mkdir .compile_info'
        endif
        execute '!cmake -DCMAKE_BUILD_TYPE=DEBUG
                \ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B .compile_info'
endfunction
command! -nargs=0 Gcmake :call s:generate_compile_commands()





" ====================
" === set with lua ===
" ====================

lua << EOF
-- git sign
require('gitsigns').setup()
-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
EOF

lua << EOF
local dracula = require("dracula")
dracula.setup({
  -- customize dracula color palette
  colors = {
    bg = "#282A36",
    fg = "#F8F8F2",
    selection = "#44475A",
    comment = "#6272A4",
    red = "#FF5555",
    orange = "#FFB86C",
    yellow = "#F1FA8C",
    green = "#50fa7b",
    purple = "#BD93F9",
    cyan = "#8BE9FD",
    pink = "#FF79C6",
    bright_red = "#FF6E6E",
    bright_green = "#69FF94",
    bright_yellow = "#FFFFA5",
    bright_blue = "#D6ACFF",
    bright_magenta = "#FF92DF",
    bright_cyan = "#A4FFFF",
    bright_white = "#FFFFFF",
    menu = "#21222C",
    visual = "#3E4452",
    gutter_fg = "#4B5263",
    nontext = "#3B4048",
  },
  -- show the '~' characters after the end of buffers
  show_end_of_buffer = true, -- default false
  -- use transparent background
  transparent_bg = true, -- default false
  -- set italic comment
  italic_comment = true, -- default false
  -- overrides the default highlights see `:h synIDattr`
  overrides = {
    -- Examples
    -- NonText = { fg = dracula.colors().white }, -- set NonText fg to white
    -- NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
    -- Nothing = {} -- clear highlight of Nothing
  },
})
EOF
colorscheme dracula

