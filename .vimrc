set hlsearch
set incsearch
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_list = [{'path': '~/sync/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction
nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>

au BufNewFile ~/sync/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'

set spell
set spelllang+=fr
autocmd TextChanged,TextChangedI <buffer> silent write
autocmd FileType text setlocal textwidth=80
inoremap jj <Esc>
