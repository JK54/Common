"自定义的按键映射
"F1,nerdtree toggle
"F2,autoformat
"F5,编译并调试。调用ComplieDebug
"F6,编译并运行。调用编译运行单文件的函数CompileRun
"F8,打开markdown预览;F9,关闭markdown预览。

"<leader>就是反斜杠
"\sudo,以sudo模式写入以普通权限打开的文件,因为sudo打开文件会使用root用户的vim配置文件(猜的)
"\jd,ycm跳转定义或者声明处。没有cscope好用，好处就是输入快，简单的情况下使用
"\cc,\cu,\cs，nerdcommenter注册的按键。\cc用每行开头//加注释，\cs用/**/的方式加注释,\cs解注释

"cscope命令在normal下使用，已经默认使用gtags-cscope
"cs help,显示所有命令。也就用cs show,cs find a|b|d|e|f|g..... keyword。

" 关闭 vi 兼容模式
set nocompatible
"搭配关闭兼容模式使用，改变退格键可以删除的空格符
set backspace=2
"自动缩进
set autoindent
"C风格缩进
set cindent
"tab长度为4个空格
set tabstop=4
"下一行缩进
set shiftwidth=4
set fileencodings=utf-8,ucs-bom,cp936,gb2312,ansi,gbk
let &termencoding=&encoding
set encoding=utf-8
" 显示行号
set nu!
" 代码高亮
syntax on
"设置颜色
color desert
"高亮搜索，搜索之后取消高亮使用:noh,即nohighlight
set hlsearch
" 设置当文件被改动时自动载入，防止外部改动造成的不一致,触发需要随便一个动作
set autoread
"折叠显示，有6种模式,常用indent与marker
"indent根据缩进自动折叠,marker设置标志进行折叠
"在normal模式下，不需要<leader>。
"zo打开，zc关闭
"zf创建，zd删除
"zf%,匹配括号;n+zf+上下键，上就是从当前行往上n行，下往下。
set foldmethod=marker
"256色
set t_Co=256
"总是显示状态栏，已经不需要了
" set laststatus=2
"状态行显示的内容"第一个反斜杠之前的正在编辑的文件名，第二个是文件格式（DOS还是UNIX），第三个是文件类型，第四个是位置，第五个是现在的时间
"使用airline插件管理状态栏
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\

" 关闭中文标点
let g:vimim_disable_chinese_punctuation=1

"中英文之间不加空格
let g:vimim_disable_seamless_english_input=1

"不在单词中间断行。设置了这个选项后，如果一行文字非常长无法在一行内显示完的话，它会在单词与单词间的空白处断开，尽量不会把一个单词分成两截放在两个不同的行里。
set lbr

" 使用'\sudo'来保存缺少写入权限的文件编辑内容,%在vim中是当前编辑文件。
map <leader>sudo :w !sudo tee %

"F5编译运行
"基于https://blog.csdn.net/zijin0802034/article/details/77709465进行修改
"函数首字母必须大写
map <F5> :call CompileRun()<CR>
func! CompileRun()
	exec "w"
	if &filetype == 'c'
		"%是vim当前打开的文件名，%<是没有后缀的文件名
		:!gcc % -o %< -O3;./%<;rm %< 
	elseif &filetype == 'cpp' 
		:!g++ % -o %< -O3;./%<;rm %<
	elseif &filetype == 'python'
		"exec与:!作用相同
		exec '!python %'
	elseif &filetype == 'sh'
		:!bash -x %
	endif
endfunc

map <F6> :call CompileDebug()<CR>
func! CompileDebug()
	exec "w"
	if &filetype == 'c'
		:!gcc % -o %< -g;gdb ./%<;rm %<
	elseif &filetype == 'cpp' 
		:!g++ % -o %< -g;gdb ./%<;rm %<
	elseif &filetype == 'python'
		:!python %
	elseif &filetype == 'sh'
		:!bash -x %
	endif
endfunc

"往下都是插件配置
let $PLUG_DIR=expand("$HOME/.vim/bundle")
if empty(glob(expand("$PLUG_DIR/plug.vim")))
	silent !curl -fLo $HOME/.vim/bundle/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif
source $PLUG_DIR/plug.vim

call plug#begin($PLUG_DIR)
"自动补全
Plug 'Valloric/YouCompleteMe'
"显示文件树,快捷键是F1
Plug 'scrooloose/nerdtree'
"注释用
Plug 'scrooloose/nerdcommenter'
"自动补全括号和引号
Plug 'Raimondi/delimitMate'
"格式代码，设置的快捷键是F2。
Plug 'Chiel92/vim-autoformat'
"代码动态检查
Plug 'w0rp/ale'
"C++语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'
"状态栏
Plug 'vim-airline/vim-airline'
"自动生成tags，配合gtags使用
" Plug 'ludovicchabant/vim-gutentags'
"vim插件不能很好地显示markdown，转用Typora
"markdown,作者推荐使用的markdown-preview.nvim要求vim
">=8.1,版本太低，所以还是用这个，区别在于新版的不需要mathjax-support-for-mkdp插件去输入数学公式
" Plug 'iamcco/mathjax-support-for-mkdp'
" Plug 'iamcco/markdown-preview.vim'
call plug#end()

"nerdtree
" NERDTree config,https://www.jianshu.com/p/eXMxGx
map <F1> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif


"ycm
let g:ycm_server_python_interpreter='/usr/bin/python3'
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
"https://zhuanlan.zhihu.com/p/33046090
"关闭代码静态检查，使用异步的ale插件
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
"最小补全字符长度
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
"语义补全快捷键设置为Ctrl+z.这一项可以不设置，因为下面已经设置了自动触发的条件。
let g:ycm_key_invoke_completion = '<c-z>'
"set completeopt=menu,menuone
"弹出函数原型预览窗口,当使用其他插件时可关闭
let g:ycm_add_preview_to_completeopt = 0
noremap <c-z> <NOP>
"语义补全的触发正则，追加到默认的触发器中。
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }
"设置触发ycm的文件后缀
let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "cc":1,
			\ "cxx":1,
			\ "h":1,
			\ "hpp":1,
			\ "py":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ }

"ycm补全窗口的颜色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
let g:ycm_key_list_stop_completion = ['<CR>']
" 跳转到定义处
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

"nerdcommenter
"注释加空格
let g:NERDSpaceDelims=1

"auto-format
"F2自动格式化代码并保存
noremap <F2> :Autoformat<CR>:w<CR>
let g:autoformat_verbosemode=1
"AlignAfterOpenBracket:AlwaysBreak作用是大括号换行
let g:formatdef_my_cfam = '"clang-format -style=LLVM AlignAfterOpenBracket:AlwaysBreak"'
let g:formatters_cpp = ['my_cfam']
let g:formatters_c = ['my_cfam']

"ale，https://zhuanlan.zhihu.com/p/23317292
"设置样式
let g:ale_sign_column_always = 1 "保持侧边栏可见
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--' "改变标识符
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta

"http://www.skywind.me/blog/archives/2084
" let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
" "normal模式下文字改动以及离开insertr模式运行linter
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1
"C/C++版本
let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

"Ctrl+k往上翻,Ctrl+j往下翻
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"airline
"显示时间
let g:airline_section_b = '%{strftime("%m/%d/%y - %H:%M")}'
"只显示文件名，不显示路径
let g:airline#extensions#tabline#fnamemod = ':t'

" "https://zhuanlan.zhihu.com/p/36279445
" "gtags插件需要手动安装gtags,没有可供包管理器安装的gtags插件
" source $PLUG_DIR/gtags.vim
" source $PLUG_DIR/gtags-cscope.vim
" " 使用 cscope 作为 tags 命令
" set cscopetag
" " 使用 gtags-cscope 代替 cscope
" set cscopeprg='gtags-cscope'
" "gtags插件
" let GtagsCscope_Auto_Load = 1
" let CtagsCscope_Auto_Map = 1
" let GtagsCscope_Quiet = 1
" "vim-gutentags,依赖于universal-ctags或者gtags
" "let $GTAGSLABEL = 'native'
" let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/home/jk54/.globalrc'
" "gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
" let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" "所生成的数据文件的名称
" let g:gutentags_ctags_tagfile = '.tags'

" " " 同时开启 ctags 和 gtags 支持：
" let g:gutentags_modules = []
" if executable('ctags')
	" let g:gutentags_modules += ['ctags']
" endif
" if executable('gtags-cscope') && executable('gtags')
	" let g:gutentags_modules += ['gtags_cscope']
" endif

" " 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags

" " 檢測 ~/.cache/tags 不存在就新建 "
" if !isdirectory(s:vim_tags)
	" silent! call mkdir(s:vim_tags, 'p')
" endif

" " 配置 ctags 的参数
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" " 如果使用 universal ctags 需要增加下面一行
" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
" "gutentags 自动加载gtags数据库
" let g:gutentags_auto_add_gtags_cscope = 1
" change focus to quickfix window after search (optional).
" let g:gutentags_plus_switch = 1
"日志,调试用
" let g:gutentags_define_advanced_commands = 1

"cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1


"markdown
"insert模式下的映射
" nmap <silent> <F8> <Plug>MarkdownPreview
" "normal模式下的映射
" imap <silent> <F8> <Plug>MarkdownPreview
" nmap <silent> <F9> <Plug>StopMarkdownPreview
" imap <silent> <F9> <Plug>StopMarkdownPreview
