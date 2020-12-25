# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

#登陆连接tmux
if [ `command -v tmux` ]
then
	if [ -z "$TMUX" ]
	then
    	tmux attach || tmux
	fi
fi
# User specific environment and startup programs
export PATH=$PATH:/home/jk54/Inventory/Common/tool/bin
