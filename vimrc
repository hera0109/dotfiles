" Vundle
if has("gui_running") || has("unix")
	filet off " filetype
	se rtp+=~/.vim/bundle/vundle " set runtimepath
	cal vundle#rc() " call
	" Let vundle manage Vundle
	" Vundle
	Bundle 'vundle'
	" Colorscheme
	Bundle 'wombat256.vim'
	Bundle 'peaksea'
	" 256 colors
	Bundle 'Lokaltog/vim-powerline'
	" ConqueTerm
	Bundle 'rson/vim-conque'
	" Autocomplete if end
	Bundle 'tpope/vim-endwise'
	" Extended % matching
	Bundle 'matchit.zip'
	" XML % jump, XML > autocomplete
	Bundle 'sukima/xmledit'
	" Faster HTML code writing
	Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
	" Easily delete, change and add surroundings in pairs
	Bundle 'tpope/vim-surround'
	" Much simpler way to use some motions
	Bundle 'Lokaltog/vim-easymotion'
	" Switch between source files and header files
	Bundle 'a.vim'
	" Compile errors
	" Bundle 'scrooloose/syntastic'
	Bundle 'Syntastic'
	" Git wrapper
	Bundle 'tpope/vim-fugitive'
	" Rails
	Bundle 'tpope/vim-rails'
	" Coffee script
	Bundle 'kchmck/vim-coffee-script'
	" Explore filesystem
	Bundle 'scrooloose/nerdtree'
	" Full path finder
	Bundle 'kien/ctrlp.vim'
	" LaTeX
	Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
en " endif
filet plugin indent on

" General
if has("gui_running")
	colo wombat256mod " colorscheme
	se enc=utf-8 " encoding
	se go-=m " guioptions Menu bar
	se go-=T " Toolbar
	se go-=r " Right-hand scrollbar
	se go-=L " Left-hand scrollbar when there is a vertically split window
	se mouse=
	so $VIMRUNTIME/delmenu.vim " source
	se lm=ko.UTF-8 " langmenu
	so $VIMRUNTIME/menu.vim
elsei has("unix") " elseif
	colo peaksea
en
if has("win32")
	au InsertEnter * se noimd " autocmd noimdisable
	au InsertLeave * se imd " imdisable
	au FocusGained * se imd
	au FocusLost * se noimd
	lan mes en " language messages en
	se dir=.,$TEMP " directory
	se ssl " shellslash
en
se bs=2 " backspace indent,eol,start
se cb=unnamed " clipboard
se fencs=ucs-bom,utf-8,cp949,latin1 " fileencodings
se ic " ignorecase # for smartcase
se nobk " nobackup
se nocp " nocompatible
se noet " noexpandtab
se scs " smartcase
se wmnu " wildmenu
syntax on

" Vim UI
if has("gui_running")
	se gfn=DejaVu\ Sans\ Mono:h10:cANSI " guifont
	se gfw=DotumChe:h10:cDEFAULT " guifontwide
	fu! ScreenFilename() " function
		if has("amiga")
			retu "s:.vimsize" " return
		elsei has("win32")
			retu $HOME.'\_vimsize'
		el " else
			retu $HOME.'/.vimsize'
		en
	endf " endfunction
	fu! ScreenRestore()
		" Restore window size (columns and lines) and position
		" from values stored in vimsize file.
		" Must set font first so columns and lines are based on font size.
		let f = ScreenFilename()
		if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
			let vim_instance = (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
			for line in readfile(f)
				let sizepos = split(line)
				if len(sizepos) == 5 && sizepos[0] == vim_instance
					" silent! execute
					sil! exe 'set columns='.sizepos[1].' lines='.sizepos[2]
					sil! exe 'winpos '.sizepos[3].' '.sizepos[4]
					retu
				en
			endfo " endfor
		en
	endf
	fu! ScreenSave()
		" Save window size and position.
		if has("gui_running") && g:screen_size_restore_pos
			let vim_instance = (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
			let data = vim_instance.' '.&columns.' '.&lines.' '.
						\ (getwinposx() < 0 ? 0: getwinposx()).' '.
						\ (getwinposy() < 0 ? 0: getwinposy())
			let f = ScreenFilename()
			if filereadable(f)
				let lines = readfile(f)
				cal filter(lines, "v:val !~ '^".vim_instance."\\>'")
				cal add(lines, data)
			el
				let lines = [data]
			en
			cal writefile(lines, f)
		en
	endf
	if !exists("g:screen_size_restore_pos")
		let g:screen_size_restore_pos = 1
	en
	if !exists("g:screen_size_by_vim_instance")
		let g:screen_size_by_vim_instance = 1
	en
	au VimEnter * if g:screen_size_restore_pos == 1 | cal ScreenRestore() | en
	au VimLeavePre * if g:screen_size_restore_pos == 1 | cal ScreenSave() | en
en
se bg=dark " background
se dy+=uhex " display # show unprintable characters as a hex number
se hls " hlsearch # search with highlight
se ls=2 " laststatus
se nu " number
se sb " splitbelow
se sc " showcmd
se sm " showmatch
se so=3 " scrolloff
se spr " splitright
se title
se t_Co=256

" Text Formatting
au FileType * setl fo-=c fo-=r fo-=o " setlocal formatoptions # disable automatic comment insertion
ret " retab
se ai " autoindent
se si " smartindent
se sts=2 " softtabstop
se sw=2 " shiftwidth
se ts=2 " tabstop

" Mappings
map j gj
map k gk
map <DOWN> gj
map <UP> gk
inoremap {<CR> {<CR>}<ESC>O

" Center Display After Searching
" nnoremap
nn n nzz
nn N Nzz
nn * *zz
nn # #zz
nn g* g*zz
nn g# g#zz

" Splitted Window
nn wj <C-W>j
nn wk <C-W>k
nn wh <C-W>h
nn wl <C-W>l

" Tab
map <C-T> :tabnew<CR>
if has("win32")
	map <C-TAB> :tabnext<CR>
	map <C-S-TAB> :tabprevious<CR>
elsei has("unix")
	map t :tabnext<CR>
	map T :tabprevious<CR>
en

" C, C++ Compile & Excute
au FileType c,cpp map <F5> :w<CR>:make %<CR>
" autocmd
au FileType c,cpp im <F5> <ESC>:w<CR>:make %<CR>
" imap
au FileType c
			\ if !filereadable("Makefile") && !filereadable("makefile") |
			\		setl mp=gcc\ -o\ %< | " makeprg
			\ en
au FileType cpp
			\ if !filereadable("Makefile") && !filereadable("makefile") |
			\		setl mp=g++\ -o\ %< |
			\ en
if has("win32")
	map <F6> :!%<.exe<CR>
	im <F6> <ESC>:!%<.exe<CR>
elsei has("unix")
	map <F6> :!./%<<CR>
	im <F6> <ESC>:!./%<<CR>
en

" Ruby Execute
au FileType ruby map <F5> :w<CR>:!ruby %<CR>
au FileType ruby im <F5> <ESC>:w<CR>:!ruby %<CR>

" man Page Settings
au FileType c,cpp se keywordprg=man
au FileType ruby se keywordprg=ri

" Gemfile View
if has("unix")
	au BufNewFile,BufRead Gemfile se filetype=ruby
	au BufNewFile,BufRead *.feature se filetype=gherkin
	au! Syntax gherkin source ~/.vim/syntax/cucumber.vim
en

" Json View
au BufNewFile,BufRead *.json se filetype=json

" Markdown View
au BufNewFile,BufRead *.md se filetype=markdown

" mobile.erb View
aug rails_subtypes " augroup
	au!
	au BufNewFile,BufRead *.mobile.erb let b:eruby_subtype='html'
	au BufNewFile,BufRead *.mobile.erb se filetype=eruby
aug END

" ConqueTerm
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_ReadUnfocused = 1
" command
com -nargs=* Sh ConqueTerm <args>
com -nargs=* Shsp ConqueTermSplit <args>
com -nargs=* Shtab ConqueTermTab <args>
com -nargs=* Shvs ConqueTermVSplit <args>

" LaTeX-Suite-aka-Vim-LaTeX
let g:tex_flavor='latex'
if has("win32")
	se gp=findstr\ /n\ /s " grepprg
elsei has("unix")
	se gp=grep\ -nH\ $*
en
se isk+=: " iskeyword
" Change default mappings for IMAP_Jumpfunc
if exists('g:Imap_StickyPlaceHolders') && g:Imap_StickyPlaceHolders
	" vmap
	vm <C-Space> <Plug>IMAP_JumpForward
el
	vm <C-Space> <Plug>IMAP_DeleteAndJumpForward
en
im <C-Space> <Plug>IMAP_JumpForward
nm <C-Space> <Plug>IMAP_JumpForward
