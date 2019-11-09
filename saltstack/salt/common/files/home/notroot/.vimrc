"Start of Vundle configurations
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

"UltiSnips plugin: snippet plugin with python interpolation
Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

"vim-snippets plugin: default snippets
Plugin 'honza/vim-snippets'

"vim-airline plugin: statusbar/tabline
Plugin 'bling/vim-airline'

"vim-gutter plugin: git diff in column
Plugin 'airblade/vim-gitgutter'

"vim-fugitive: git wrapper
Plugin 'tpope/vim-fugitive'

" Slime
Plugin 'jpalardy/vim-slime'

"L9"
Plugin 'L9'

"vim-fuzzyfinder: quickly find buffer/file/command/bookmark/tag
Plugin 'FuzzyFinder'

"vim-taskwarrior plugin: interface for taskwarrior
Plugin 'farseer90718/vim-taskwarrior'

"End of Vundle configurations
call vundle#end()

filetype plugin indent on

"Zenburn colorscheme
colorscheme zenburn
set t_Co=256

"bindings for navigating windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

syntax enable
autocmd BufRead,BufNewFile *.scm,*.c,*.py,*.sh,*.cpp,*.php,*.html,*.css,*.js,*.json,*.*rc syntax on
autocmd BufRead,BufNewFile *.md,*.txt setlocal spell
autocmd BufRead,BufNewFile *.md,*.txt set textwidth=74
autocmd BufRead,BufNewFile *.md,*.txt set formatoptions=t1
autocmd BufRead,BufNewFile *.md,*.txt noremap Q gqap
autocmd BufRead,BufNewFile *.md,*.txt syntax off
autocmd BufRead,BufNewFile *.scm set tabstop=2
autocmd BufRead,BufNewFile *.scm set shiftwidth=2
autocmd BufRead,BufNewFile *.c set tabstop=4
autocmd BufRead,BufNewFile *.c set shiftwidth=4
autocmd BufRead,BufNewFile *.scm,*.c set expandtab
autocmd BufRead,BufNewFile *.rkt inoremap lambda λ

"Map f9 to lambda replace
map #9 :%s/lambda/λ/g<CR>

"Fuzzyfinder keybinds
nmap ,b :FufLine<CR>
nmap ,t :FufFile<CR>
nmap ,f :FufTag<CR>
