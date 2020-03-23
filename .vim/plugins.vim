call plug#begin('~/.vim/plugged')

" syntax
"Plug 'sheerun/vim-polyglot'
"Plug 'ianks/vim-tsx'
"Plug 'mxw/vim-jsx'
"Plug 'flowtype/vim-flow'
"Plug 'pangloss/vim-javascript'

" status bar
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline.vim'

" Themes
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'

" typing
"Plug 'alvan/vim-closetag'
"Plug 'jiangmiao/auto-pairs'
"Plug 'tpope/vim-surround'

" autocomplete
"Plug 'sirver/ultisnips'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }

" IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'yggdroot/indentline'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-syntastic/syntastic'

" Web Development
Plug 'mattn/emmet-vim'
"Plug 'dense-analysis/ale'

call plug#end()
