set hlsearch
set incsearch
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
set nocompatible
filetype plugin on
syntax on

" spellcheck pour ces types de fichiers
autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell
set spelllang+=fr
hi clear SpellBad
"" souligner les erreurs
hi SpellBad cterm=underline

" enregistrement auto
"autocmd TextChanged,TextChangedI <buffer> silent write
" maxi 72 colonnes pour les types de fichier text
autocmd FileType text setlocal textwidth=72

" jj en remplacement / complément de Esc, c'est plus rapide  
inoremap jj <Esc>

" plugins
call plug#begin()
Plug 'junegunn/goyo.vim'
call plug#end()

" Plugin Goyo pour ces extensions de fichiers
autocmd vimenter *.md Goyo
autocmd vimenter *.txt Goyo

" Plaintext journaling
"" insert fancy signifiers with abbrevs
autocmd vimenter */journal/* abbrev todo ·
autocmd vimenter */journal/* abbrev done ×

"" select the task list and hit `gq` to sort and group by status
autocmd vimenter */journal/* set formatprg=sort\ -V

"" syntax highlighting
augroup JournalSyntax
    autocmd!
    autocmd BufReadPost */journal/* set filetype=journal

    autocmd BufReadPost */journal/* syntax match JournalAll /.*/                 " captures the entire buffer
    autocmd BufReadPost */journal/* syntax match JournalDone /^×.*/              " lines containing 'done' items:  ×
    autocmd BufReadPost */journal/* syntax match JournalTodo /^·.*/              " lines containing 'todo' items:  ·
    autocmd BufReadPost */journal/* syntax match JournalEvent /^o.*/             " lines containing 'event' items: o
    autocmd BufReadPost */journal/* syntax match JournalNote /^- .*/             " lines containing 'note' items:  -
    autocmd BufReadPost */journal/* syntax match JournalMoved /^>.*/             " lines containing 'moved' items: >
    autocmd BufReadPost */journal/* syntax match JournalHeader /^\<\u\+\>.*/     " lines starting with caps

    autocmd BufReadPost */journal/* highlight JournalAll    ctermfg=103
    autocmd BufReadPost */journal/* highlight JournalHeader ctermfg=250
    autocmd BufReadPost */journal/* highlight JournalDone   ctermfg=8
    autocmd BufReadPost */journal/* highlight JournalEvent  ctermfg=6               " cyan
    autocmd BufReadPost */journal/* highlight JournalMoved  ctermfg=5               " pink
    autocmd BufReadPost */journal/* highlight JournalNote   ctermfg=3               " yellow
    autocmd BufReadPost */journal/* highlight VertSplit     ctermfg=0  ctermbg=0    " hide vert splits
augroup END

augroup JournalHideUIElements
    autocmd!
    " hide junk
    autocmd vimEnter */journal/* set laststatus=0
    autocmd vimEnter */journal/* set noruler nonumber nocursorline nocursorcolumn norelativenumber

    " pin scrolling
"    autocmd vimEnter */journal/* set scrollbind

augroup END
" /Plaintext journaling
