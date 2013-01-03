call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

let g:CommandTMaxDepth=50
let g:CommandTMaxFiles=1000000

syn on
filetype plugin indent on
set number
set cursorline
set report=0
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set laststatus=2
set nocompatible
set showmatch
set title
set ttyfast
set nottybuiltin
set nobackup
set noswapfile
set statusline=[%n]\ [%t]\ [%M%R%Y]%=[%l,%c,%p%%]
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set pastetoggle=<F2>
set scrolloff=30
set sidescrolloff=30
map :Q :q
map :W :w
map < :tabnext<cr>
map > :tabprev<cr>
map <C-t> :CommandT<cr>
map <C-b> :CommandTBuffer<cr>
set hlsearch
set incsearch
set nowrap
set backspace=indent,eol,start

let &t_Co=256

color damnith

" Set filetypes for extensions used
augroup filetype
    au  BufRead,BufNewFile *.ddl set filetype=mysql
    au  BufRead,BufNewFile *.tt  set filetype=html
    au  BufRead,BufNewFile *.tpl set filetype=html
augroup END

autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 textwidth=0
autocmd FileType php  setlocal textwidth=80 colorcolumn=+1


" Highlight trailing whitespace in red
highlight TrailingWS ctermbg=red
let m = matchadd("TrailingWS", "[ \t]\\+$")
" Highlight non-normalised leading whitespace in red
" where normalised means all the tabs are at the front
highlight BadLeadingWS ctermbg=red
let m = matchadd("BadLeadingWS", "^[ \t]* \t[ \t]*")

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
