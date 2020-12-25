alias vi=vim
alias cw='find . -type f -and -name "*.*" -or -name "*.cpp" -or -name "*.hpp" -or -name "*.c" -or -name "*.h" -or -name "*.sh" | xargs cat | grep -v ^$ | grep -v / | grep -v \* | wc -l'

alias setrm='sudo mv /bin/rm /bin/rm.origin;sudo mv /usr/local/bin/rm2 /usr/local/bin/rm'
alias unsetrm='sudo mv /bin/rm.origin /bin/rm;sudo mv /usr/local/bin/rm /usr/local/bin/rm2'

alias setkbd='xinput set-prop 16 "Device Enabled" 0;xinput set-prop 18 "Device Enabled" 0;xinput set-prop 19 "Device Enabled" 0'
alias unsetkbd='xinput set-prop 16 "Device Enabled" 1;xinput set-prop 18 "Device Enabled" 1;xinput set-prop 19 "Device Enabled" 1'

alias setproxy='export http_proxy=socks5://127.0.0.1:1080;export https_proxy=socks5://127.0.0.1:1080;export no_proxy=localhost'
alias unsetproxy='unset http_proxy https_proxy no_proxy'
