" Vim configuration file
"
" Set line numbers and syntax highlighting on by default
set number
syntax on

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with <> use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Map jk to escape in insert mode
imap jk <Esc>
imap JK <Esc>

" Tell which characters to show for expanded \t
" trailing whitespace and end-of-lines
if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list


" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Use global clipboard
set clipboard=unnamedplus

" Set swapfile directory to /tmp
set swapfile
set dir=/tmp

" Always have status bar
set laststatus=2

" Quick access to vim undo tree
nnoremap <F5> :UndotreeToggle<cr>
" Persistent undo
if has("persistent_undo")
    set undodir=/tmp/undodir/
    set undofile
endif

" Vim Plug
call plug#begin('~/.local/share/nvim/plugged')
" Minimalist mode
Plug 'junegunn/goyo.vim'
" Better quoting and xml tags
Plug 'tpope/vim-surround'
" Visualize undo tree
Plug 'mbbill/undotree'
" Lisp inferred parens
" Requires rust
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
call plug#end()
