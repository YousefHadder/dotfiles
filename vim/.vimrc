
" Basic Settings
set nocompatible              " Disable vi compatibility
filetype plugin indent on     " Enable file type detection and plugins
syntax enable                 " Enable syntax highlighting

" UI Configuration
set number                    " Show line numbers
set relativenumber           " Show relative line numbers
set cursorline               " Highlight current line
set showcmd                  " Show command in bottom bar
set wildmenu                 " Visual autocomplete for command menu
set lazyredraw               " Redraw only when needed
set showmatch                " Highlight matching [{()}]
set ruler                    " Show cursor position
set laststatus=2             " Always show status line
set signcolumn=yes           " Always show sign column
set colorcolumn=120          " Show column at 120 characters
set list                     " Show whitespace characters
set listchars=tab:→\ ,trail:·,nbsp:␣

" Colors and Themes
set background=dark          " Dark background
set termguicolors           " Enable true colors
colorscheme slate          " Default colorscheme (change as needed)

" Spaces and Tabs
set tabstop=2               " Number of visual spaces per TAB
set softtabstop=2           " Number of spaces in tab when editing
set shiftwidth=2            " Number of spaces for indentation
set expandtab               " Use spaces instead of tabs
set autoindent              " Auto-indent new lines
set smartindent             " Smart indentation
set nowrap                  " Disable line wrapping
set linebreak               " Break lines at word boundaries

" Search Settings
set incsearch               " Search as characters are entered
set hlsearch                " Highlight search matches
set ignorecase              " Case-insensitive search
set smartcase               " Case-sensitive if uppercase used
set magic                   " Enable regular expressions

" File Handling
set encoding=utf-8          " UTF-8 encoding
set fileencoding=utf-8      " File encoding
set hidden                  " Allow hidden buffers
set autoread                " Auto-reload files changed outside vim
set nobackup                " Disable backup files
set noswapfile              " Disable swap files
set undofile                " Persistent undo
set undodir=~/.vim/undo//   " Undo directory

" Performance
set updatetime=50           " Faster completion
set timeoutlen=300          " Time to wait for mapped sequence
set ttimeoutlen=10          " Time to wait for key codes

" Splits
set splitbelow              " Horizontal splits below
set splitright              " Vertical splits to the right

" Scrolling
set scrolloff=8             " Keep 8 lines above/below cursor
set sidescrolloff=8         " Keep 8 columns left/right of cursor

" Folding
set foldmethod=indent       " Fold based on indent
set foldlevelstart=99       " Start with all folds open
set foldenable              " Enable folding

" Key Mappings
let mapleader=" "           " Set leader key to space

" Disable spacebar's default behavior
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Normal mode mappings
nnoremap <leader>wa :w<CR>   " Quick save
nnoremap <leader>q :q<CR>    " Quick quit
nnoremap <leader>Q :qall<CR> " Quit all
nnoremap <C-h> <C-w>h       " Navigate splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Esc> :nohlsearch<CR> " Clear search highlight
nnoremap <Tab> :bnext<CR>      " Next buffer (using Tab)
nnoremap <S-Tab> :bprevious<CR> " Previous buffer (using Shift+Tab)
nnoremap <leader>bd :bdelete!<CR> " Delete buffer
nnoremap <leader>bn :enew<CR>     " New buffer

" Better up/down movement
nnoremap j gj
nnoremap k gk

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep cursor centered when searching
nnoremap n nzzzv
nnoremap N Nzzzv

" Global find and replace
nnoremap <leader>rw :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Window resizing
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Split creation
nnoremap <leader>| :vsplit<CR>
nnoremap <leader>- :split<CR>

" Move splits
nnoremap <leader>ml <C-w>H
nnoremap <leader>md <C-w>J
nnoremap <leader>mu <C-w>K
nnoremap <leader>mr <C-w>L

" Tab navigation
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>

" Terminal mappings
nnoremap <leader>tt :terminal<CR>
nnoremap <leader>ts :split \| terminal<CR>
nnoremap <leader>tv :vsplit \| terminal<CR>

" Select all
nnoremap vag ggVG

" Delete single character without copying into register
nnoremap x "_x

" Reload configuration
nnoremap <leader>rf :source %<CR>

" Visual mode mappings
vnoremap < <gv              " Keep selection after indent
vnoremap > >gv
vnoremap j gj               " Better up/down movement
vnoremap k gk
vnoremap <leader>p "_dP     " Better paste (doesn't replace clipboard)
vnoremap p "_dp             " Better paste
" Move selected lines up and down
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-j> :m '>+1<CR>gv=gv

" Insert mode mappings
inoremap jk <ESC>           " Exit insert mode
inoremap <C-s> <ESC>:w<CR>a " Save in insert mode

" Auto Commands
augroup vimrc_autocmds
    autocmd!
    " Remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e
    " Return to last edit position
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# 'commit' |
        \   exe "normal! g'\"" |
        \ endif
    " Highlight yanked text (using built-in vim functionality)
    if exists('##TextYankPost')
        autocmd TextYankPost * silent! call feedkeys("\<Plug>(YankHighlight)")
    endif
    " Auto-reload files when changed externally
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !=# 'c' | checktime | endif
    " Auto create directories before save
    autocmd BufWritePre * call mkdir(fnamemodify(expand('<afile>'), ':p:h'), 'p')
    " Auto-resize splits on window resize
    autocmd VimResized * wincmd =
    " Highlight current line only in active window
    autocmd BufEnter,WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " Terminal settings
    autocmd TerminalOpen * setlocal nonumber norelativenumber | startinsert
    " Load project-specific settings from .vim if present
    autocmd VimEnter * if filereadable('.vim') | source .vim | endif
augroup END

" File Type Specific Settings
augroup filetypes
    autocmd!
    autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType javascript,typescript,json setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType html,css,scss setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType markdown,text,gitcommit setlocal wrap linebreak spell spelllang=en_us
    autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=72
    " Fix file type detection
    autocmd BufNewFile,BufRead *.jsx setfiletype javascriptreact
    autocmd BufNewFile,BufRead *.tsx setfiletype typescriptreact
    autocmd BufNewFile,BufRead .env*,*.env setfiletype sh
augroup END

" Netrw Configuration
let g:netrw_banner=0        " Disable banner
let g:netrw_liststyle=3     " Tree view
let g:netrw_browse_split=4  " Open in previous window
let g:netrw_altv=1          " Open splits to the right
let g:netrw_winsize=25      " Width of explorer

" Create necessary directories
silent !mkdir -p ~/.vim/undo

" Mouse Support
set mouse=a                 " Enable mouse in all modes

" Completion
set completeopt=menu,menuone,noselect
set pumheight=10            " Popup menu height
set shortmess+=c            " Don't show completion messages

" Backspace options
set backspace=start,eol,indent

" Additional vim-specific settings
set isfname+=@-@           " Include @ in filename characters
set history=1000           " Command history
set wildmode=list:longest,full " Command completion

" Large file handling
augroup large_files
    autocmd!
    autocmd BufReadPre * 
        \ let f=getfsize(expand("<afile>")) | 
        \ if f > 10485760 || f == -2 | 
        \   set eventignore+=FileType | 
        \   setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | 
        \ else | 
        \   set eventignore-=FileType | 
        \ endif
augroup END

" Copy file path to clipboard (if clipboard available)
if has('clipboard')
    nnoremap <leader>cp :let @+=expand('%:~')<CR>:echo "Path copied to clipboard: " . expand('%:~')<CR>
endif

" Terminal mode mappings (if terminal available)
if has('terminal')
    tnoremap <Esc><Esc> <C-\><C-n>
endif
