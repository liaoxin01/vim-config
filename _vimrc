" basic {{{
    set nocompatible
    set autoindent 
    set sw=4 " shift width, indent width
    set tabstop=4 " ts, tabstop width
    set tw=80
    set cc=120 " colorcolumn=120
    " set et " extendtab by default
    set cursorline " hilight current line
    set cursorcolumn " hilight column
    set display=lastline
    set backspace=indent,eol,start
    set number
    set encoding=utf-8
    set fencs=utf8,gbk,gb2312,cp936,gb18030
    
    set scrolloff=3 " margin of moving to top or bot of current screen
    set sidescroll=1 " horizontal scroll step, continous scroll
    set backspace=indent,eol,start
    
    set foldmethod=marker " marker manual indent
    set foldenable
    set fdl=3 " foldlevel
    
    
    " always display status line, 0 never, 1 more than 2 windows, 2 always
    set laststatus=2
    syntax enable
    syntax on
    if !has('gui_running')
      set t_Co=256
    endif
    colorscheme Monokai
    
    set list " show white spaces
    set listchars=tab:>-,trail:- " set listchars=tab:\|\ ,trail:-
    set ignorecase " noignorecase
    set smartcase " if upper case letters are typed, case sensitive
    
    set nowrapscan
    set hlsearch
    set incsearch "increase search, search when typing a pattern
    
    filetype on
    filetype plugin on
    filetype indent on
    
    set noundofile
    set nobackup
    
    set autochdir
    set updatetime=200
    set showmatch
    " set switchbuf=usetab,newtab
    set clipboard+=unnamed " using system clipboard
    
    set tags=tags,./tags,../tags,../../tags,../../../tags
	set tags+=~/.vim/tags/cpp_tags
    set dir=~/temp/,~/tmp/,/tmp/

" }}}


" vim-plug {
    call plug#begin('~/.vim/plugged')
    Plug 'itchyny/lightline.vim'
    Plug 'preservim/tagbar'
    Plug 'preservim/nerdtree'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'AndrewRadev/splitjoin.vim'
    Plug 'octol/vim-cpp-enhanced-highlight'
    " Track the engine.
    Plug 'SirVer/ultisnips'
    " Snippets are separated from the engine. Add this if you want them:
    Plug 'honza/vim-snippets'
    Plug 'vim-scripts/AutoComplPop'
    Plug 'vim-scripts/OmniCppComplete'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'uiiaoo/java-syntax.vim'
    Plug 'preservim/nerdcommenter'
    call plug#end()
" }

" java-syntax {{{
    " disable highlighting variables
    highlight link javaIdentifier NONE
" }}}

" ultisnips {{{
    " Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
    " - https://github.com/Valloric/YouCompleteMe
    " - https://github.com/nvim-lua/completion-nvim
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}}

" nerdtree {{{
    " nnoremap <leader>n :NERDTreeToggle<CR>
    " Check if NERDTree is open or active
    function! IsNERDTreeOpen()
      return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
    endfunction
    " " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
    " " file, and we're not in vimdiff
    function! SyncTree()
      if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
        NERDTreeFind
        wincmd p
      endif
    endfunction
    " " Highlight currently open buffer in NERDTree
    autocmd BufEnter * call SyncTree()
     
    function! ToggleNerdTree()
      set eventignore=BufEnter
      NERDTreeToggle
      set eventignore=
    endfunction
    nmap <leader>n :call ToggleNerdTree()<CR>
		" Exit Vim if NERDTree is the only window remaining in the only tab.
		autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
		" Close the tab if NERDTree is the only window remaining in it.
		autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
		" Open the existing NERDTree on each new tab.
		autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" }}}

" nerdcommenter {{{
    let g:NERDSpaceDelims=1
" }}}

" OmniCppComplete {{{
    "  C++
    let g:OmniCpp_NamespaceSearch = 1
    let g:OmniCpp_GlobalScopeSearch = 1
    let g:OmniCpp_ShowAccess = 1
    let g:OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
    let g:OmniCpp_MayCompleteDot = 1 " autocomplete after .
    let g:OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
    let g:OmniCpp_MayCompleteScope = 1 " autocomplete after ::
    let g:OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD", "__gnu_std"]
    let g:OmniCpp_SelectFirstItem = 2 " select first popup item (without inserting it to the text)
    " automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    " set completeopt=menuone,menu,longest,preview
    set completeopt=menuone,menu
    au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.h,*.cc set omnifunc=omni#cpp#complete#Main
    
    " java
    " au FileType java set omnifunc=javacomplete#Complete
    au BufNewFile,BufRead,BufEnter *.java set omnifunc=javacomplete#Complete
" }}}

" make tag file {{{
    function! MakeTags()
      if &ft == "cpp"
        "   exe '!ctags -R --langmap=.h.inl.cxx.cc --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
        exe '!ctags -R --exclude=.git --exclude=.svn --langmap=c++:+.inl+.cc+.h+.cxx -h +.inl --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
      elseif &ft == "java"
        exe '!ctags -R --exclude=.git --exclude=.svn --java-kinds=+p --fields=+iaS --extra=+q --languages=java'
      elseif &ft == "php"
        exe '!ctags -R --exclude=.git --exclude=.svn --php-kinds=+cidfvj --fields=+iaSK --fields=-k --extra=+q --languages=php'
      elseif &ft == "javascript"
        exe '!ctags -R --exclude=.git --exclude=.svn --javascript-kinds=+cfv --fields=+iaSK --fields=-k --extra=+q --languages=javascript'
      endif
    endfunction
" }}}

" using * and # search for selected content in visual mode {{{
   vnoremap <silent> * :<C-U>
     \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
     \gvy/<C-R><C-R>=substitute(
       \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
     \gV:call setreg('"', old_reg, old_regtype)<CR>
   vnoremap <silent> # :<C-U>
     \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
     \gvy?<C-R><C-R>=substitute(
       \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
     \gV:call setreg('"', old_reg, old_regtype)<CR>
" }}}

" auto complete key map {{{
    autocmd BufRead,BufEnter * call AutoCompletionKeyMap()
    function! AutoCompletionKeyMap()
        if &ft == "cpp" || &ft == "java"
        imap <C-space> <C-x><C-o><C-p>
        imap <C-l> <C-x><C-o><C-p>
      else
        imap <C-space> <C-n><C-p>
        imap <C-l> <C-n><C-p>
      endif
    endfunc
    imap <C-j> <C-n>
    imap <C-k> <C-p>
" }}}


" vim:tw=80:ts=2:ft=vim:et:foldcolumn=2:foldenable:fdl=3
