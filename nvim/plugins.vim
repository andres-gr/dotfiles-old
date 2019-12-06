" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')

" === Editing Plugins === "
" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" auto-close plugin
Plug 'rstacruz/vim-closer'

" Improved motion in Vim
Plug 'easymotion/vim-easymotion'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Denite - Fuzzy finding, buffer management
Plug 'Shougo/denite.nvim'

" Snippet support
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'

" Surround
Plug 'tpope/vim-surround'

" Repeat everything
Plug 'tpope/vim-repeat'

" Sneak
Plug 'justinmk/vim-sneak'

" Commentary
Plug 'tpope/vim-commentary'

" Indent Object
Plug 'michaeljsmith/vim-indent-object'

" CamelCaseMotion
Plug 'bkad/CamelCaseMotion'

" Auto close pairs
Plug 'jiangmiao/auto-pairs'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" === Javascript Plugins === "
" Typescript syntax highlighting
" Plug 'HerringtonDarkholme/yats.vim'

" ReactJS JSX syntax highlighting
" Plug 'mxw/vim-jsx'

" Generate JSDoc commands based on function signature
Plug 'heavenshell/vim-jsdoc'

" === Syntax Highlighting === "

" Syntax highlighting for nginx
" Plug 'chr4/nginx.vim'

" Syntax highlighting for javascript libraries
" Plug 'othree/javascript-libraries-syntax.vim'

" Improved syntax highlighting and indentation
" Plug 'othree/yajs.vim'

" Many syntax highlight
Plug 'sheerun/vim-polyglot'

" Javascript, Typescript, JSX
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" === UI === "
" File explorer
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Colorscheme
" Plug 'mhartington/oceanic-next'
Plug 'dracula/vim', { 'as': 'dracula' }

" Customized vim status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Icons
Plug 'ryanoasis/vim-devicons'

" Minimap
" Plug 'severin-lemaignan/vim-minimap'

" Initialize plugin system
call plug#end()
