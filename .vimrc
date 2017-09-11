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

" Add autocomplete closing parentheses and such
" Escape using Ctrl-V before typing the mapped character
" ino " ""<left>
" ino ' ''<left>
" ino ( ()<left>
" ino [ []<left>
" ino { {}<left>
" ino {<CR> {<CR>}<ESC>0

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
