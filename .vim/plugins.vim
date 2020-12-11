call plug#begin('~/.vim/plugged')

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Themes
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'

" IDE
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'yggdroot/indentline'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'

" JS & TS
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" Theme
Plug 'haishanh/night-owl.vim'

" Linter
Plug 'dense-analysis/ale'

" Web Development
Plug 'mattn/emmet-vim'
Plug 'robertbasic/vim-hugo-helper'

call plug#end()
