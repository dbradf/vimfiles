" Vimrc
" by David Bradford

let mapleader = ","

" ======= General Options ========

set nocompatible " Don't need vi compatibility
set history=400
set autoread     " automatically read file changed outside of Vim
set visualbell   " Use a visual bell instead of beeping

set scrolloff=3  " Scroll 3 lines form the edge

set hlsearch     " Highlight search terms
set incsearch    " Incremental Search

set showmatch    " show matching backets
set matchtime=3  " how long to blink matching brackets for(1/10 of sec)

set wildmode=list:longest      " Enable tab completion in the minibuffer
set backspace=indent,eol,start " allow backspacing over everything 
set diffopt+=filler

set directory=$HOME/tmp " Use a temporary directory for swp files

" ======= Setup for terminials =======
set t_Co=256

" ======= Setup Pathogen =======
" Note that you need to invoke the pathogen functions before invoking 
" 'filetype plugin indent on' if you want it to load ftdetect files. 
" On Debian (and probably other distros), the system vimrc does this 
" early on, so you actually need to 'filetype off' before 'filetype 
" plugin indent on' to force reloading.
filetype off
call pathogen#runtime_append_all_bundles() 

" ======= Visual Options =======

syntax on         " Turn on syntax highlighting
set guioptions-=T " No Toolbar
set number        " Show Line numbers
set lz            " lazy redraw of macros
if has("gui_running")
    set lines=50  
    set columns=120
endif

" Set a wider display if diffing
if &diff
    set columns=180
endif

" Status Bar
set laststatus=2
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %{fugitive#statusline()}

" Color Scheme
if $VIMCOLORSCHEME != ""
    color $VIMCOLORSCHEME
else
    set background=dark
    color solarized
    "color vividchalk
endif

set guifont=Inconsolata\ Medium\ 11
"set guifont=Anonymous\ Pro\ 9

" Invisible Characters
set listchars=tab:▸\ ,eol:¬
"set list "Show invisible characters

" Highlight cursor position
"set cursorline
"set cursorcolumn


" ======= Indent =======

" Use 4 space tabs
set tabstop=4
set shiftwidth=4
set expandtab

" One a line after an open paren put the cursor right after the open paren
set cino=(0,c1


" ======= Key Mapping =======

" Easier movement around split windows
map <C-j> <C-W>j 
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Accordion style movement
map <s-up> <c-w>k<c-w>_
map <s-down> <c-w>j<c-w>_

" tab shortcuts
nmap <S-t> :tabnew<cr>
nmap <C-tab> :tabnext<cr>
nmap <S-tab> :tabprev<cr>

" Spliting Windows
nmap <Leader>v :vsplit<cr>
nmap <Leader>s :split<cr>

" Formatting shortcuts
vmap <silent> <Leader>i= <ESC>:Tabularize / = <CR>
nmap <silent> <Leader>i= <ESC>:Tabularize / = <CR>

 " Remove all trailing whitespace from file
nmap <silent> <Leader>rws :%s/\s\+$//<CR> 

" git shortcuts
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gc :Gcommit<CR>

" build commands
nmap <Leader>bc :silent !eval $BUILDCMD<CR>
nmap <f5> :silent !eval $BUILDCMD<CR>

" ======= File Type Specific =======
filetype on
filetype plugin on
filetype indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif  |

" Setup templates
autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl

autocmd FileType ruby set ts=2|set sw=2|set expandtab|set sts=2
autocmd FileType eruby set ts=2|set sw=2|set expandtab|set sts=2
autocmd FileType html set ts=2|set sw=2|set expandtab|set sts=2

" Highling lines over 80 charachters
" autocmd BufEnter  * 2match SpellCap /.\%>80v.\+/
set cc=81


" ======= Line Bookmarking =========

sign define bookmark text=@
nmap <silent> <Leader>b :exe ":sign place " . line(".") . " name=bookmark line" . line(".") . " file=" . expand("%:p")<CR>
nmap <silent> <Leader>d :sign unplace<CR>
nmap <silent> <Leader>D :sign unplace *<CR>

" ======= CSCOPE ========

if $CSCOPE_BINARY != ""
    set csprg=$CSCOPE_BINARY
else
    set csprg=/usr/bin/cscope
endif

if $CSCOPEDB != ""
	cs add $CSCOPEDB $CSCOPEFILELIST
endif

nmap <silent> <Leader>csr :cs reset<CR><CR>

" ======= PLUGIN OPTIONS =======

map <leader>n :execute 'NERDTreeToggle ' . getcwd()<CR>

map <leader>ut :GundoToggle<CR>
let g:gundo_right = 1


if $CTAGS_BINARY != ""
    let Tlist_Ctags_Cmd = $CTAGS_BINARY
endif

nmap <silent> <leader>ta :TlistToggle<CR>

" ======= Functions =======

"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %{fugitive#statusline()}

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline .= "%#StatColor#"
    endif

    let statusline .= "\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline .= "%*"
    endif

    let statusline .= "%#Modified#%m"
    if a:mode == 'Leave'
        let statusline .= "%*%r"
    elseif a:mode == 'Enter'
        let statusline .= "%r%*"
    endif

    let statusline .= "\ (%l/%L,%P)\ %=%h%2\ [\%03.3b,0x\%02.2B]%y[%{&fileformat}]%{fugitive#statusline()}\ "
    return statusline
endfunction

au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')

set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
    if a:mode == 'i'
        hi StatColor guibg=orange ctermbg=lightred
    elseif a:mode == 'r'
        hi StatColor guibg="#e454ba ctermbg=magenta
    elseif a:mode == 'v'
        hi StatColor guibg="#e454ba ctermbg=magenta
    else
        hi StatColor guibg=red ctermbg=red
    endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black




