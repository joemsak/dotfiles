let mapleader=","
let g:CommandTMaxFiles=80085
call pathogen#infect()
set directory=/tmp

filetype plugin on

" Add all directories under $DOTFILES/vim/vendor as runtime paths, so plugins,
" docs, colors, and other runtime files are loaded.
let vendorpaths = globpath("$DOTFILES/vim", "vendor/*")

let vendorruntimepaths = substitute(vendorpaths, "\n", ",", "g")
execute "set runtimepath^=$DOTFILES/vim,".vendorruntimepaths

let vendorpathslist = split(vendorpaths, "\n")
for vendorpath in vendorpathslist
  if isdirectory(vendorpath."/doc")
    execute "helptags ".vendorpath."/doc"
  endif
endfor

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50    " keep 50 lines of command line history
set ruler          " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch      " do incremental searching
set vb            " turn on visual bell
set nu            " show line numbers
set sw=2          " set shiftwidth to 2
set ts=2          " set number of spaces for a tab to 2
set et            " expand tabs to spaces

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " For all ruby files, set 'shiftwidth' and 'tabspace' to 2 and expand tabs
  " to spaces.
  autocmd FileType ruby,eruby set sw=2 ts=2 et
  autocmd FileType python set sw=4 ts=4 et

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Save on focus lost
  :au FocusLost * :wa

  augroup END

else

  set autoindent    " always set autoindenting on

endif " has("autocmd")

" Easily open and reload vimrc
"<Leader>v brings up my .vimrc
"<Leader>V reloads it -- making all changes active (have to save first)
map <Leader>v :sp $DOTFILES/vimrc<CR>
map <silent> <Leader>V :source $HOME/.vimrc<CR>:if has("gui")<CR>:source $HOME/.vimrc<CR>:endif<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" ctrl+x -- clear whitespace in a file, commit
map <C-x> :%s/\s\+$//g<cr>:w<cr>:!git ci % -m "Elminate trailing whitespace"<cr>

map <Leader>p :set paste<cr>o
map <Leader>P :set nopaste<cr>

" <Leader>h -- add _no_rails_ to require spec_helper
map <Leader>h gg^f_ano_rails_<esc>j:w<cr>

" Key sequence mappings
" In command-mode, typing %/ will replace those chars with the directory of
" the file in the current buffer
cmap %/ <C-r>=expand('%:p:h')<CR>/
" execute current line as shell command, and open output in new window
map <Leader>x :silent . w ! sh > ~/.vim_cmd.out<CR>:new ~/.vim_cmd.out<CR>
map <Leader>cw ggiEliminate trailing whitespace<CR><ESC>:x<CR>

noremap <C-t> :CommandTFlush<CR>:CommandT<CR>
set wildignore+=tmp/**
set wildignore+=log/**

" Character mapping
cnoremap <C-a> <Home>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>pl :PromoteToLet<cr>

" Run Tests ******************************************************************
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
          if match(a:filename, '_test') != -1
            exec ":!bundle exec rake test " . a:filename
          else
            exec ":!bundle exec rspec --color " . a:filename
          end
        elseif match(a:filename, '_test') != -1
            exec ":!rake test " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    let in_test_file = match(expand("%"), '\(.feature\|_test.rb\)$') != -1
    if in_test_file || in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

" Sessions ********************************************************************
set sessionoptions=blank,buffers,curdir,folds,help,options,resize,tabpages,winpos,winsize,globals

function! AutosaveSessionOn(session_file_path)
  augroup AutosaveSession
    au!
    exec "au VimLeave * mks! " . a:session_file_path
  augroup end
  let g:AutosaveSessionFilePath = a:session_file_path

  echo "Auto-saving sessions to \"" . a:session_file_path . "\""
endfunction
function! AutosaveSessionOff()
  if exists("g:AutosaveSessionFilePath")
    unlet g:AutosaveSessionFilePath
  endif

  augroup AutosaveSession
    au!
  augroup end
  augroup! AutosaveSession

  echo "Auto-saving sessions is off"
endfunction
command! -complete=file -nargs=1 AutosaveSessionOn call AutosaveSessionOn(<f-args>)
command! AutosaveSessionOff call AutosaveSessionOff()
augroup AutosaveSession
  au!
  au SessionLoadPost * if exists("g:AutosaveSessionFilePath") != 0|call AutosaveSessionOn(g:AutosaveSessionFilePath)|endif
augroup end

" Disable all blinking:
:set guicursor+=a:blinkon0

" Text formatting ********************************************************************
function! WordWrap(state)
  if a:state == "on"
    set lbr
  else
    set nolbr
  end
endfunction
com! WW call WordWrap("on")
com! Ww call WordWrap("off")

" White space ****************************************************************
let hiExtraWhiteSpace = "hi ExtraWhitespace ctermbg=red guibg=red"
exec hiExtraWhiteSpace
au ColorScheme * exec hiExtraWhiteSpace
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
set list
" set listchars=tab:▸\ ,eol:¬

" Markdown *******************************************************************
function! PreviewMKD()
  let tmpfile = tempname()
  exe "write! " tmpfile
  exe "!preview_mkd " tmpfile
endfunction
autocmd BufRead *.markdown map <Leader>p :call PreviewMKD()<CR>
autocmd BufRead *.markdown call WordWrap("on")
autocmd BufRead *.markdown set spell

" Folding *********************************************************************
function! EnableFolding()
  set foldcolumn=2
  set foldenable
endfunction
function! DisableFolding()
  set foldcolumn=0
  set nofoldenable
endfunction
set foldmethod=syntax
call DisableFolding()

" Netrw
let g:netrw_liststyle=3
let g:netrw_browse_split=0
let g:netrw_list_hide='^\..*\.swp$'
let g:netrw_altv=1

" Colors *********************************************************************
:set t_Co=256 " 256 colors
:set background=dark
:color grb256

au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile Guardfile set filetype=ruby
autocmd BufNewFile,BufRead *.json set ft=javascript

" Projects *******************************************************************
function! ConfigureForMMH()
  set tags=./tags,$MMH_HOME/tags,$MMH_ROOT/stable/tags,$MMH_ROOT/indexer/tags,$MMH_ROOT/jdk_tags,$HOME/tags,tags
endfunction
com! Mmh call ConfigureForMMH()

set shell=/bin/sh
