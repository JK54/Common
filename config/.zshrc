# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DEFAULT_USER=$USER
PS1="[%n@%m]%~# "
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"
# 禁止zsh解释*
setopt no_nomatch
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	# git
	colored-man-pages
	cp
	z
	# safe-paste
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-completions
)

source $ZSH/oh-my-zsh.sh

# oh-my-zsh 自动更新
DISABLE_UPDATE_PROMPT=true

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#GO
export GOROOT=/usr/bin/go
export GOPATH=~/Workspace/go

#yay
export PATH=/opt/openresty/bin:$PATH

#opengrok
TOMCATPATH=/var/lib/tomcat8
OPENGROKPATH=/usr/share/java/opengrok
export PATH=$HOME/.local/bin:$PATH
alias deployindex='sudo opengrok-deploy -c $OPENGROKPATH/etc/configuration.xml $OPENGROKPATH/lib/source.war $TOMCATPATH/webapps'
alias updateindex='sudo java -jar $OPENGROKPATH/lib/opengrok.jar -P -S -v -s $OPENGROKPATH/src -d $OPENGROKPATH/data -W $OPENGROKPATH/etc/configuration.xml -U http://localhost:8080/source'
alias createindex='sudo java -Djava.util.logging.config.file=$OPENGROKPATH/etc/logging.properties -jar $OPENGROKPATH/lib/opengrok.jar -c /usr/bin/ctags -s $OPENGROKPATH/src -d $OPENGROKPATH/data -H -P -S -G -W $OPENGROKPATH/etc/configuration.xml -U http://localhost:8080/source'

#proxy
alias setproxy='export http_proxy=socks5://127.0.0.1:10808;export https_proxy=socks5://127.0.0.1:10808'
alias unsetproxy='unset http_proxy; unset https_proxy'

export EDITOR=/usr/bin/vim
#howdy
export OPENCV_LOG_LEVEL=ERROR

#nginx code debug
alias buildngxdbg="auto/configure --prefix=/$HOME/Workspace/nginx/etc/nginx --conf-path=/$HOME/Workspace/nginx/etc/nginx/nginx.conf --sbin-path=/$HOME/Workspace/nginx/usr/bin/nginx --pid-path=/$HOME/Workspace/nginx/run/nginx.pid --lock-path=/$HOME/Workspace/nginx/run/lock/nginx.lock --user=http --group=http --http-log-path=/$HOME/Workspace/nginx/var/log/nginx/access.log --error-log-path=stderr --http-client-body-temp-path=/$HOME/Workspace/nginx/var/lib/nginx/client-body --http-proxy-temp-path=/$HOME/Workspace/nginx/var/lib/nginx/proxy --http-fastcgi-temp-path=/$HOME/Workspace/nginx/var/lib/nginx/fastcgi --http-scgi-temp-path=/$HOME/Workspace/nginx/var/lib/nginx/scgi --http-uwsgi-temp-path=/$HOME/Workspace/nginx/var/lib/nginx/uwsgi --with-cc-opt='-march=x86-64 -mtune=generic -O2 -pipe -fno-plt -D_FORTIFY_SOURCE=2' --with-ld-opt=-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now --with-compat --with-debug --with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-pcre-jit --with-stream --with-stream_geoip_module --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-debug --with-cc-opt='-O0 -g'"


#my alias
alias mj='make -j 16'
alias mi='make install'

#my alias
findall()
{
	grep -rn $1 *
}
alias fa=findall

findhistory()
{
	args=""
	for i in "$*"; do
		args="$args $i"
	done
	history | grep $args
}
alias fh=findhistory

trash()
{
	mv $@ ~/.trash/
}
alias rm=trash
alias ug=updategit
alias cw='find . -name "*.cc" -o -name "*.cpp" -o -name "*.h" | xargs cat | grep -v ^$ | grep -v ^# | grep -v "^//" | grep -v "^/\*" | wc -l'
alias cu='git log  | grep Author | awk '"'"'{print $2}'"'"' | sort | uniq -c'

#docker
alias dr='docker ps -a | awk '"'"'NR == 1 {next} {print $1}'"'"' | xargs docker rm -f '
docker_attach_bash()
{
	docker exec -it $1 /bin/bash
}
alias db=docker_attach_bash
docker_attach_zsh()
{
	docker exec -it $1 /bin/zsh
}
alias dz=docker_attach_zsh
