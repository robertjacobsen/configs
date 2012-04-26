syn on
filetype plugin indent on
set number
set cursorline
set report=0
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set softtabstop=4
set laststatus=2
set cursorline
set ttyfast
set nottybuiltin
set statusline=[%n]\ [%t]\ [%M%R%Y]%=[%l,%c,%p%%]
set list listchars=tab:\|\ ,trail:·
map :Q :q
map :W :w
map < :tabnext<cr>
map > :tabprev<cr>
set hlsearch
set incsearch
set nowrap
let &t_Co=256
color damnith 

" Set filetypes for extensions used
au BufNewFile,BufRead *.ddl set filetype=mysql
au BufRead,BufNewFile *.tt  set filetype=html
"set mouse=a
