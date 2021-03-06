" General Settings
" ----------------

let &t_Co=256
syntax on " colored syntax for code
syntax enable

set ai " auto indent code to current indentation level on newline
set backspace=indent,eol,start
set clipboard=unnamedplus " The unnamed register is synchronized with the system clipboard
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set hlsearch " highlight search results
set ic " This will cause vim to ignore the case of letters while searching
set incsearch " Incremental search: vim will move the highlighted word as
        " characters are typed
set lazyredraw " When this option is set, the screen will not be redrawn while
        " executing macros, registers and other commands that have not been
        " typed.
set mouse=a " Enable the use of the mouse.  Only works for certain terminals
        " (xterm, MS-DOS, Win32 win32-mouse, QNX pterm, *BSD console with
        " sysmouse and Linux console with gpm). "a" allows it to be used in
        " Normal mode and Terminal modes, Visual mode, Insert mode,
        " Command-line mode
set number " Print the line number in front of each line
set relativenumber " Changes the displayed number to be relative to the cursor
set selection=exclusive
set shiftwidth=4
set showcmd
set si " smart indenting, adds a level of indent when only "needed" by the
       " code
set sidescroll=1
set smartcase " Ignore case while searching only when input is all lowercase,
              " otherwise, case-sensitive searching
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set virtualedit=all
set wildmenu

set nobackup
set nocompatible
set noshowmode
set noswapfile
set nowrap
set nowritebackup

" Conditional Settings
" --------------------

" A few different settings in neovim vs. vim
if has('nvim')
    set inccommand=nosplit
else
    set ttymouse=xterm2
endif

" Easy switch between light and dark colorscheme
if $BACKGROUND == 'light'
    set background=light
else
    set background=dark
endif

" Use ag for faster searching
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
endif

" Use rg for faster searching (preferred over ag)
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l,%m
endif

if $OS == 'Mac'
    let g:clang_format_file_path="/usr/local/bin/clang-format"
elseif $OS == 'Linux'
    let g:clang_format_file_path="/usr/share/clang/clang-format.py"
endif


" Key Remappings
" --------------

let mapleader="\<SPACE>"

nnoremap Y y$
nnoremap <TAB> gt
nnoremap <S-TAB> gT
nnoremap <LEADER><SPACE> :nohlsearch<CR>
nnoremap <LEADER>s :StripWhitespace<CR>
nmap <BS> <C-^>
nmap <LEADER>c yygccp

inoremap <C-l> <C-o>a

vnoremap < <gv
vnoremap > >gv
:imap jj <Esc>


" Function parameter completion using YouCompleteMe and UltiSnips
function! FunctionParameterHint()
    if !exists('v:completed_item') || empty(v:completed_item)
        return
    endif

    if v:completed_item.word == ''
        return
    endif
    let abbr = v:completed_item.abbr
    let startIdx = match(abbr,"(")
    let endIdx = match(abbr,")")
    let angle = 0
    if startIdx == -1 || endIdx == -1
        let startIdx = match(abbr,"<")
        let endIdx = match(abbr,">")
        let angle = 1
    endif
    if endIdx - startIdx > 1
        let argsStr = strpart(abbr, startIdx + 1, endIdx - startIdx - 1)
        let argsList = split(argsStr, ",")
        let snippet = angle ? "<" : "("
        let c = 1
        for i in argsList
            if c > 1
                let snippet = snippet. ", "
            endif
            " strip space
            let arg = substitute(i, '^\s*\(.\{-}\)\s*$', '\1', '')
            let snippet = snippet . '${'.c.":".arg.'}'
            let c += 1
        endfor
        let snippet = angle ? snippet . ">$0" : snippet . ")$0"
        call UltiSnips#Anon(snippet)
    elseif endIdx - startIdx == 1
        call UltiSnips#Anon("()$0")
    endif
endfunction


" Use <CR> to expand functions or snippets
function! ExpandFunctionOrSnippet()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible() && exists('v:completed_item.kind') && (v:completed_item.kind == 'f' || v:completed_item.kind == 'c')
            return "\<C-y>"
        else
            return "\<CR>"
        endif
    endif
    return ""
endfunction

" Run clang-format on current file
function! ClangFormatCurrentFile()
    let l:lines="all"
    " execute "py3f " . fnameescape(g:clang_format_file_path)
endfunction


" Autocommands
" ------------

" Give function parameter hints after finishing completion
autocmd CompleteDone * call FunctionParameterHint()


" Set filetype to text if not already set
autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif


" Cursorline moves with buffers and hides during insert
augroup CursorLine
    autocmd!
    autocmd BufWinEnter * setl cursorline
    autocmd InsertEnter * setl nocursorline
    autocmd InsertLeave * setl cursorline
    autocmd VimEnter * setl cursorline
    autocmd WinEnter * setl cursorline
    autocmd WinLeave * setl nocursorline
augroup END


" Run clang-format before writing file
if exists("g:clang_format_file_path")
    autocmd BufWritePre *.h,*.cc,*.cpp call ClangFormatCurrentFile()
endif


" Run Neomake automatically on certain filetypes
autocmd! BufEnter,BufWritePost *.py Neomake
autocmd! BufWritePost *.tex Neomake


" Settings for composing mail
autocmd FileType mail setlocal formatoptions+=aw
autocmd FileType mail setlocal spell spelllang=en_us
autocmd FileType mail setlocal wrap
autocmd FileType mail setlocal linebreak
autocmd FileType mail execute "normal /^$/\no"
autocmd FileType mail execute ":startinsert"

" Both vim and neovim can source their plugins from the same directory
call plug#begin('~/.vim/plugins')

if $OS == 'Mac'
    Plug 'https://github.com/junegunn/fzf.git', { 'dir': '~/.fzf', 'do': './install --all' }
elseif $OS == 'Linux'
    Plug 'https://github.com/junegunn/fzf.git'
endif

Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
Plug 'https://github.com/google/yapf.git', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'https://github.com/junegunn/fzf.vim.git'
Plug 'https://github.com/junegunn/vim-easy-align.git'
Plug 'https://github.com/justinmk/vim-sneak.git'
Plug 'https://github.com/mrtazz/DoxygenToolkit.vim.git', { 'on': 'Dox' }
Plug 'https://github.com/neomake/neomake.git'
Plug 'https://github.com/ntpeters/vim-better-whitespace.git'
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-obsession.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/Valloric/ListToggle.git'
Plug 'https://github.com/Valloric/YouCompleteMe.git', { 'do': 'python3 install.py --allr' }
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'https://github.com/wellle/targets.vim.git'
Plug 'https://github.com/easymotion/vim-easymotion.git'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
call plug#end()

" Plugin Configurations
" ---------------------

" Airline
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#ycm#enabled=1
let g:airline#extensions#ycm#error_symbol='E:'
let g:airline#extensions#ycm#warning_symbol='W:'
let g:airline_solarized_bg=&background
set ttimeoutlen=50
set laststatus=2

" Colorscheme
let g:solarized_termtrans=1
let g:solarized_termcolors=256
try
    colorscheme solarized
catch
endtry

" delimitMate
let g:delimitMate_expand_cr=1

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" FZF
nnoremap <LEADER>p :FZFFiles<CR>
let g:fzf_nvim_statusline=0
let g:fzf_command_prefix='FZF'
let g:fzf_layout={ 'left': '~30%' }
let g:fzf_action={
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-h': 'split',
    \ 'ctrl-v': 'vsplit' }

" ListToggle
let g:lt_location_list_toggle_map='<LEADER>l'
let g:lt_quickfix_list_toggle_map='<LEADER>k'

" Neomake
let g:neomake_tex_pdflatex_maker = {
    \ 'args': ['-file-line-error', '-interaction=nonstopmode'] }
let g:neomake_cpp_enabled_makers=[]
let g:neomake_python_enabled_makers=['pylint', 'mypy']
let g:neomake_tex_enabled_makers=['pdflatex']
let g:neomake_error_sign={
    \ 'text': '✕',
    \ 'texthl': 'Error' }
let g:neomake_warning_sign={
    \ 'text': '🤔',
    \ 'texthl': 'Todo' }

" Vim-Better-Whitespace
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
let g:better_whitespace_filetypes_blacklist=['diff', 'mail']

" Sneak
let g:sneak#s_next=1

" UltiSnips
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetsDir='~/.config/ultisnips'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/ultisnips']
let g:UltiSnipsExpandTrigger='<CR>'
let g:UltiSnipsJumpForwardTrigger='<TAB>'
let g:UltiSnipsJumpBackwardTrigger='<S-TAB>'
autocmd BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=ExpandFunctionOrSnippet()<CR>"

" YouCompleteMe
let g:ycm_key_invoke_completion='<C-l>'
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_error_symbol='✕'
let g:ycm_warning_symbol='🤔'
let g:ycm_always_populate_location_list=1
let g:ycm_max_diagnostics_to_display=1000
let g:ycm_server_python_interpreter='python'
let g:ycm_python_binary_path='python'
let g:ycm_filetype_blacklist={}
let g:ycm_add_preview_to_completeopt=0
nnoremap <LEADER>y :YcmCompleter<SPACE>
set completeopt-=preview
