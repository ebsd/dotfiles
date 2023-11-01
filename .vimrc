set hlsearch
set incsearch
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
set nocompatible
filetype plugin on
syntax on

set spell
set spelllang+=fr
autocmd TextChanged,TextChangedI <buffer> silent write
autocmd FileType text setlocal textwidth=80
inoremap jj <Esc>
