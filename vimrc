set scrolloff=8
set number                  "Line Numbers
set relativenumber          "Use relative line numbers
set laststatus=2            "Always show status 
set ruler                   "Show cursor position always
set cursorline              "Highlight line cursor is one

"Esc-Esc to remove highlights from search
nnoremap <silent> <Esc><Esc> :let @/=""<CR> 
set ignorecase              "Ignore Case of searches
set hlsearch                "Highlight searches
set incsearch               "Highlight dynamically as pattern is typed

set tabstop=4 softtabstop=4 "One tab == four spaces
set shiftwidth=4            "One tab == four spaces
set expandtab               "Use spaces instead of tabs
set smartindent
set showmode                "Show current mode
set title                   "Show filename in window titlebar
set clipboard=unamed        "Use OS clipboard by default

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ayu-theme/ayu-vim'
call plug#end()

"Theme
set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

let mapleader = " "
" <leader> + p + v == :Vex
nnoremap <leader>pv :Vex<CR>
" <leacer> + return == :so ~/.vimrc
nnoremap <leader><CR> :so ~/.vimrc<CR>
" Control + p == :GFiles
nnoremap <C-p> :GFiles<CR>
" <leader> + p + f == :Files
nnoremap <leader>pf :Files<CR>

