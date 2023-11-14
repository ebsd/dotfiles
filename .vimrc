set hlsearch
set incsearch
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
set nocompatible
filetype plugin on
syntax on

autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell
set spelllang+=fr
autocmd TextChanged,TextChangedI <buffer> silent write
autocmd FileType text setlocal textwidth=80
inoremap jj <Esc>
autocmd vimenter *.md Goyo
autocmd vimenter *.txt Goyo

call plug#begin()
Plug 'junegunn/goyo.vim'
call plug#end()
