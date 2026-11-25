" ============================================================================
" 1. COMPATIBILITY & CORE VI-SAFE SETTINGS
" ============================================================================
if &compatible
    set nocompatible
endif

" --- Your Active Customizations (from your original vimrc) ---
set visualbell              " Flash screen instead of beep (default: novisualbell)
set shiftwidth=4            " Indent width for >> and << (default: 8)
set tabstop=4               " Width of a <Tab> character (default: 8)
set wrap                    " Wrap long lines visually (default: wrap)
set ignorecase              " Case-insensitive search (default: noignorecase)
set showmode                " Display current mode on bottom line (default: showmode in Vim, noshowmode in vi)
set showmatch               " Briefly jump to matching bracket (default: noshowmatch)
set number                  " Display line numbers (default: nonumber)
set nobackup                " Do not keep backup files after saving (default: nobackup)
set history=1000            " Command history size (default: 20 in vi / 50 in Vim)

" --- Remaining Valid POSIX vi + Vim Shared Options (True Defaults) ---
set noautoindent            " Do not auto-indent new lines (default: noautoindent)
set noautowrite             " Do not auto-save before :next or :! (default: noautowrite)
set noedcompatible          " Do not reuse flags from previous :s command (default: noedcompatible)
set noerrorbells            " Do not ring bell on errors (default: noerrorbells)
set noexrc                  " Do not read local .exrc/.vimrc in current directory (default: noexrc)
set nolisp                  " Disable Lisp indenting (default: nolisp)
set nolist                  " Do not show invisible chars like ^I and $ (default: nolist)
set magic                   " Enable regex metacharacters in search (default: magic)
set nomodeline              " Ignore modelines embedded in files (default: nomodeline when root / vi)
set paragraphs=IPLPPPQPP\ LIpplpipbp  " Section boundaries for { and }
set prompt                  " Show ':' prompt in Ex mode (default: prompt)
set noreadonly              " Allow editing and saving files (default: noreadonly)
set remap                   " Allow recursive key mappings (default: remap)
set report=5                " Report changes when >= N lines affected (default: 5)
set sections=NHSHH\ HUnhsh  " Section boundaries for [[ and ]]
set taglength=0             " Significant chars in tags, 0 = unlimited (default: 0)
set tags=tags               " Tag file names for :tag (default: tags)
set noterse                 " Show full error messages (default: noterse)
set timeout                 " Time out on partial multi-key mappings (default: timeout)
set warn                    " Warn before running :! shell command with unsaved changes (default: warn)
set wrapscan                " Search wraps around end of file (default: wrapscan)
set wrapmargin=0            " Right margin for auto-wrapping text, 0 = off (default: 0)
set nowriteany              " Require :w! to overwrite existing files (default: nowriteany)

" --- Legacy BSD vi / POSIX ex Options (Skipped by Vim/vim.tiny via 'if 0') ---
if 0 " Removed and will be marked as error (E518)
    set noautoprint # Obsolete Ex line-printing flag
    set nobeautify # Obsolete control-character filter for paper teletypes.
    set hardtabs=8 # Replaced by tabstop and softtabstop.
    set mesg # Controlled write/wall terminal permissions on multi-user UNIX mainframes.
    set redraw # Simulated smart terminals on 300-baud dumb terminals.
    set noslowopen # Postponed screen redraws during insert mode on slow serial lines.
endif

" Stop parsing here ONLY when running in minimal vim.tiny (which lacks +eval)
if 0 | finish | endif

" ============================================================================
" 2. FULL VIM FEATURES (Skipped cleanly by vim.tiny / non-eval builds)
" ============================================================================
" Jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" --- Character Encoding ---
if has('multi_byte')
    set encoding=utf-8          " Internal character encoding used by Vim in memory
    scriptencoding utf-8        " Encoding of this vimrc file itself (for multi-byte symbols)
endif

" --- Search & Command-Line UI ---
set incsearch                   " Highlight matches incrementally while typing a search pattern
set hlsearch                    " Keep all matches highlighted after pressing Enter on a search
set showcmd                     " Display partial normal-mode commands in the bottom-right corner
set smarttab                    " Insert 'shiftwidth' spaces at start of line, 'tabstop' elsewhere
set path+=**                    " Search recursively down all subdirectories for :find and gf

" --- Line Numbers & Cursor Guides ---
if exists('+relativenumber')
    set relativenumber          " Show line distance relative to cursor (hybrid mode with 'number')
endif

if exists('+cursorline')
    set cursorline              " Highlight the horizontal screen line under the cursor
    set cursorcolumn            " Highlight the vertical screen column under the cursor
endif

" --- Mouse Support ---
if has('mouse')
    set mouse=a                 " Enable mouse clicking, scrolling, and resizing in all modes
endif

" --- Command-Line Wildcard Completion ---
if has('wildmenu')
    set wildmenu                " Show an interactive completion menu bar above the command line
    set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx  " Exclude binary/media files from wildcard expansion
endif

" --- Window Splitting ---
if has('vertsplit')
    set splitbelow              " Open new horizontal splits (:split) below the current window
    set splitright              " Open new vertical splits (:vsplit) to the right of the current window
endif

" --- Spell Checking ---
if has('spell')
    set spell                   " Enable built-in spell checking by default
endif

" --- Filetype Detection, Plugins & Auto-Indentation ---
if has('autocmd')
    filetype plugin indent on   " Enable filetype detection, filetype plugins, and smart indenting
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " Stop auto-inserting comment leaders on new lines
    autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab  " Use 2 spaces instead of tabs for HTML files
endif

" --- Syntax Highlighting & Colorscheme ---
if has('syntax')
    syntax on                   " Enable syntax highlighting for recognized file types
    silent! colorscheme slate   " Apply the 'slate' colorscheme (fails silently if missing)
    autocmd ColorScheme,Syntax vim hi! link vimOptionError vimOption  " Prevent red error background on legacy vi options in vimrc
endif

" --- Persistent Undo (Survives Closing Vim) ---
if has('persistent_undo')
    set undodir=~/.vim/backup   " Directory where persistent undo history files are stored
    set undofile                " Save undo history to disk so changes can be undone after reopening
    set undoreload=10000        " Maximum lines saved for undo when reloading a whole buffer
endif

" --- Netrw Built-In File Explorer Settings ---
let g:netrw_banner = 0          " Hide the top help banner in Netrw file browser
let g:netrw_liststyle = 3       " Display files in an expandable tree view
let g:netrw_showhide = 1        " Show hidden dotfiles in Netrw
let g:netrw_winsize = 20        " Set Netrw split width to 20% of the window

" --- Insert-Mode Auto-Completion ---
if has('insert_expand')
    if exists('+omnifunc')
        set omnifunc=syntaxcomplete#Complete  " Use syntax-based omni-completion (<C-x><C-o>)
    endif
    set complete+=k             " Include dictionary/spell words in keyword auto-completion
    set completeopt=menu,menuone,noinsert  " Show popup menu even for 1 match, without auto-inserting text

    " Minimalist Tab Complete (triggers completion if preceded by a word character)
    inoremap <expr> <Tab> TabComplete()
    function! TabComplete()
        if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
            return "\<C-N>"     " Cycle to next completion match
        else
            return "\<Tab>"     " Insert a literal Tab
        endif
    endfunction

    " Minimalist Autocomplete (auto-opens popup after typing 3 word characters)
    inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"  " Confirm selected match with Enter if popup is open
    if has('autocmd')
        autocmd InsertCharPre * call AutoComplete()
    endif
    function! AutoComplete()
        if v:char =~ '\K'
            \ && getline('.')[col('.') - 4] !~ '\K'
            \ && getline('.')[col('.') - 3] =~ '\K'
            \ && getline('.')[col('.') - 2] =~ '\K'
            \ && getline('.')[col('.') - 1] !~ '\K'
            call feedkeys("\<C-N>", 'n')
        endif
    endfunction
endif

" --- Auto-Closing Brackets & Comments in Insert Mode ---
" Auto-close square brackets and place cursor inside
inoremap [ []<left>
" Auto-close parentheses and place cursor inside
inoremap ( ()<left>
" Auto-close curly braces and place cursor inside
inoremap { {}<left>
" Auto-close block comment and place cursor inside
inoremap /* /**/<left><left>

if !has('gui_running')
    if exists('$TMUX')
        let &t_SI = "\ePtmux;\e\e[6 q\e\\"
        let &t_SR = "\ePtmux;\e\e[4 q\e\\"
        let &t_EI = "\ePtmux;\e\e[2 q\e\\"
    else
        let &t_SI = "\e[6 q"
        let &t_SR = "\e[4 q"
        let &t_EI = "\e[2 q"
    endif
endif

" ============================================================================
" 3. GVIM - GUI VERSION
" ============================================================================
if has('gui_running')
    silent! colorscheme slate           " Re-apply 'slate' colorscheme for GUI window

    " Set OS-appropriate GUI font and size
    if has('macvim')
        set guifont=Menlo\ Regular:h14  " Font for macOS MacVim
    elseif has('win32')
        set guifont=Consolas:h14        " Font for Windows GVim
    else
        set guifont=Consolas\ 18        " Font for Linux/GTK GVim
    endif

    set guioptions-=T                   " Hide the top icon toolbar in GVim
    set guioptions-=r                   " Hide the right-hand vertical scrollbar in GVim

    if has('autocmd')
        autocmd VimEnter * :Lexplore | wincmd p  " Open Netrw sidebar on startup and move cursor back to main window
    endif
endif

" ============================================================================
" 4. CUSTOM FUNCTIONS (Hex Conversion & Hebrew RTL Toggle)
" ============================================================================

" Convert current buffer to a hex dump file (<filename>.hex) using xxd
function! DoHex()
    let current_file = expand('%')                          " Get current buffer filename
    let new_file = current_file . '.hex'                    " Append .hex extension
    execute 'w !xxd > ' . shellescape(new_file)             " Pipe buffer through xxd and write to new file
    echo "Hex file created and saved as " . new_file        " Confirm output filename
endfunction

" Convert a .hex buffer back to binary/original format (<name>M.<ext>)
function! UndoHex()
    let current_file = expand('%')                                                      " Get current buffer filename
    let new_file_stage1 = substitute(current_file, '\.hex$', '', '')                    " Strip trailing .hex extension
    let file_name = substitute(new_file_stage1, '\(.*\)\.\(\w\+\)$', '\1', '')          " Extract base filename
    let file_extension = substitute(new_file_stage1, '\(.*\)\.\(\w\+\)$', '\2', '')     " Extract original extension
    let new_file = file_name . 'M.' . file_extension                                    " Insert 'M' (Modded) before extension
    execute 'w !xxd -r > ' . shellescape(new_file)                                      " Reverse hex dump via xxd -r
    echo "Reversed Hex file created and saved as " . new_file                           " Confirm output filename
endfunction

" Prompt user to choose between creating (0) or reversing (1) a hex dump
function! HexState()
    let operation = input("Choose operation (0 for DoHex, 1 for UndoHex): ")  " Prompt for choice
    if operation ==# '0'
        call DoHex()                    " Run hex dump creation
    elseif operation ==# '1'
        call UndoHex()                  " Run hex dump reversal
    else
        echo "Invalid choice. Aborting."
    endif
endfunction

" Toggle Right-to-Left (RTL) display, Hebrew keymap, and spell-check
if has('rightleft') && has('keymap')
    function! ToggleHebrew()
        if &rl
            set norl                    " Disable Right-to-Left screen orientation
            set keymap=                 " Reset keyboard mapping back to default (Latin)
            if has('spell') | set spell | endif     " Re-enable spell-check for English/Latin text
            echom "Hebrew mode OFF"
        else
            set rl                      " Enable Right-to-Left screen orientation
            set keymap=hebrew           " Switch insert-mode keymap to Hebrew
            if has('spell') | set nospell | endif   " Disable spell-check to avoid false highlights on Hebrew
            echom "Hebrew mode ON"
        endif
    endfunction
endif

" ============================================================================
" 5. CUSTOM STATUS LINE
" ============================================================================
if has('statusline')

    " Translate internal Vim mode() codes into readable labels
    function! StatuslineMode()
        let l:mode = mode()
        if l:mode ==# "n"
            return "NORMAL"
        elseif l:mode ==# "V"
            return "VISUAL LINE"
        elseif l:mode ==? "v"
            return "VISUAL"
        elseif l:mode ==# "i"
            return "INSERT"
        elseif l:mode ==# "\<C-V>"
            return "V-BLOCK"
        elseif l:mode ==# "R"
            return "REPLACE"
        elseif l:mode ==? "s"
            return "SELECT"
        elseif l:mode ==# "t"
            return "TERMINAL"
        elseif l:mode ==# "c"
            return "COMMAND"
        elseif l:mode ==# "!"
            return "SHELL"
        else
            return "VIM"
        endif
    endfunction

    " Show [SPELL] indicator in status line only when spell-check is active
    function! SpellCheckStatus()
        if has('spell') && &spell
            return " [SPELL]"
        else
            return ''
        endif
    endfunction

    set laststatus=2                    " Always display the status line, even with only one window open
    set statusline=                     " Clear any existing status line definition
    set statusline+=%2*                 " Switch to User2 highlight group (mode badge)
    set statusline+=%{StatuslineMode()} " Display current editing mode (NORMAL, INSERT, etc.)
    set statusline+=\                   " Add single space padding
    set statusline+=%{SpellCheckStatus()} " Display [SPELL] if spell-check is enabled
    set statusline+=%1*                 " Switch to User1 highlight group (base bar)
    set statusline+=\                   " Add single space padding
    set statusline+=%3*                 " Switch to User3 highlight group (filename accent)
    set statusline+=<-                  " Decorative left bracket around filename
    set statusline+=\                   " Add single space padding
    set statusline+=%f                  " Relative path/name of current file
    set statusline+=\                   " Add single space padding
    set statusline+=->                  " Decorative right bracket around filename
    set statusline+=\                   " Add single space padding
    set statusline+=%4*                 " Switch to User4 highlight group (flags & metrics)
    set statusline+=%m                  " Modified flag [+] if buffer has unsaved changes
    set statusline+=%=                  " Align everything after this point to the right side
    set statusline+=%h                  " Help buffer flag [Help]
    set statusline+=%r                  " Read-only flag [RO]
    set statusline+=%4*                 " Switch to User4 highlight group
    set statusline+=%c/%l/%L            " Cursor column / current line / total lines
    set statusline+=\                   " Add single space padding
    set statusline+=%1*                 " Switch to User1 highlight group
    set statusline+=|%y                 " Separator and detected filetype (e.g., |vim)
    set statusline+=\                   " Add single space padding
    set statusline+=%4*                 " Switch to User4 highlight group
    set statusline+=%P                  " Percentage scrolled through file (Top/Bot/%)
    set statusline+=\                   " Add single space padding
    set statusline+=%3*                 " Switch to User3 highlight group
    set statusline+=t:%n                " Current buffer number
    set statusline+=\                   " Add trailing space padding

    " Custom status line highlight colors (terminal cterm and GUI gui)
    hi User2 ctermbg=green ctermfg=black guibg=lightgreen guifg=black      " Mode & spell badge
    hi User1 ctermbg=brown ctermfg=white guibg=black guifg=white                " Base status bar
    hi User3 ctermbg=brown ctermfg=lightcyan guibg=black guifg=lightblue        " Filename & buffer number
    hi User4 ctermbg=brown ctermfg=green guibg=black guifg=lightgreen           " Modified flag, line/col, %
endif

" ============================================================================
" 6. KEY BINDINGS
" ============================================================================

" Set comma (,) as the <leader> prefix key
let mapleader = ","

" --- Editing & Formatting ---
if has('spell')
    " Toggle US English spell-check with Ctrl+Z
    map <C-z> :setlocal spell! spelllang=en_us<CR>
endif

" Exit Insert mode quickly by typing 'jj'
inoremap jj <Esc>

" Format/wrap selected paragraph with 'Q' (replaces Ex mode)
map Q gq<CR>

" Select entire buffer with ,a
nnoremap <leader>a ggVG

" --- File Explorer (Netrw) ---
" Toggle Netrw left-sidebar tree explorer with ,e
map <leader>e :Lex<CR>

" Open Netrw full-window explorer with ,o
map <leader>o :Explore<CR>

" --- Integrated Terminal ---
if has('terminal')
    " Open a terminal split with Ctrl+T
    map <c-t> :ter<CR>

    " Close terminal window forcefully with Ctrl+T
    tnoremap <c-t> <C-w>:q!<CR>

    " Switch terminal to Terminal-Normal (scroll/copy) mode with Ctrl+I
    tnoremap <c-i> <c-w><s-n>

    " Switch terminal to Terminal-Normal mode with Esc
    tnoremap <Esc> <C-\><C-n>
endif

" --- Window Splits & Navigation ---
" Prepare horizontal split command (:split ) with ,y
map <leader>y :split<space>

" Prepare vertical split command (:vsplit ) with ,x
map <leader>x :vsplit<space>

" Move cursor to split below with Ctrl+J
nnoremap <c-j> <c-w>j

" Move cursor to split above with Ctrl+K
nnoremap <c-k> <c-w>k

" Move cursor to split on the left with Ctrl+H
nnoremap <c-h> <c-w>h

" Move cursor to split on the right with Ctrl+L
nnoremap <c-l> <c-w>l

" --- Window Resizing ---
" Increase window height with Alt+Up
noremap <a-up> <c-w>+

" Decrease window height with Alt+Down
noremap <a-down> <c-w>-

" Increase window width with Alt+Left
noremap <a-left> <c-w>>

" Decrease window width with Alt+Right
noremap <a-right> <c-w><lt>

" --- Tab Management ---
" Switch to next tab with ,t
map <leader>t gt

" Prepare command to open file in new tab with ,c
nnoremap <leader>c :tabedit<space>

" --- Saving & Quitting ---
" Save current file with Ctrl+S
map <C-S> :w<CR>

" Save and quit current window with Ctrl+Q
map <C-q> :wq<CR>

" --- Text Manipulation & Custom Tools ---
" Surround word under cursor with typed character (,sw)
nnoremap <leader>sw <cmd>echo "Press a character: " \| let c = nr2char(getchar()) \| exec "normal viwo\ei" . c . "\eea" . c . "\e" \| redraw<CR>

" Pre-fill global search-and-replace for word under cursor (,rw)
nnoremap <leader>rw :%s/\<<c-r><c-w>\>//g<left><left>

if exists('*ToggleHebrew')
    " Toggle Hebrew RTL mode and keymap (,ht)
    nnoremap <leader>ht <cmd>call ToggleHebrew()<CR>
endif

" Open Hex dump / reverse menu (,hx)
nnoremap <leader>hx <cmd>call HexState()<CR>

" Enter Visual Block mode with ,v (avoids Ctrl+V paste conflict)
noremap <leader>v <C-v>

" --- System Clipboard & Registers ---
if has('clipboard')
    " Paste from system clipboard before cursor with Ctrl+V
    map <C-V> "+P

    " Copy visual selection to both PRIMARY (*) and CLIPBOARD (+) with Ctrl+C
    vnoremap <C-C> "*y :let @+=@*<CR>
endif

" Display all register contents with ,r
nnoremap <leader>r <cmd>registers<CR>

" --- Visual Line Moving ---
" Move selected lines down one line and re-indent with J
vnoremap J :m '>+1<CR>gv=gv

" Move selected lines up one line and re-indent with K
vnoremap K :m '>-2<CR>gv=gv

" Copy visual selection to local clipboard via OSC 52 using <Leader>y
vnoremap <silent> <Leader>y y:call system('printf "\033]52;c;' . substitute(system('base64', @"), '\n', '', 'g') . '\a" > /dev/tty')<CR>

