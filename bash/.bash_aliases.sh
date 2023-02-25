#!/bin/bash
#
 
# Source and reload bashrc
alias edp="vi ~/${RC_FILE}"
alias rlp="source ~/${RC_FILE}"

alias bpull="pushd $REPOS_DIR/bash && git pull && popd"

# Bash aliases
alias my_public_ip="echo $(curl -s ifconfig.me)"
alias gh='history|grep'

# General aliases which are helpful
#alias mount="mount |column -t"
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias ..='cd ..'
alias ...='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# ls related aliases
alias ll="ls -l $*"
alias la="ls -a $*"
alias lal="ls -al $*"
# list by size
alias lt='ls --human-readable --size -1 -S --classify'
alias ltl='ls -l --human-readable --size -1 -S --classify'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias ports='netstat -tulanp'


## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
 
# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

#alias ls="exa --icons --color=always $*"

alias vdhcp="virsh net-dhcp-leases default"


# tmux related aliases

# Attaches tmux to the last session; creates a new session with a panel split into left and right
alias t='tmux attach || tmux new-session -s default\; new-window\; new-window'

alias ta='tmux attach -t'

# Creates a new session
alias tn='tmux new-session'

# Lists all ongoing sessions
alias tl='tmux list-sessions'


############### https://aruva.medium.com/100-bash-aliases-for-supersonic-productivity-d54a796422d9 #############
alias backup='tar -zcvf $(date +%Y%m%d).tar.gz *'

alias path='echo -e ${PATH//:/\\n}'

alias extract='for i in *.gz; do tar xvf $i; done'

# This shows the size of the current directory and its subdirectories in human-readable format
alias du1='du -h -d 1'

alias weather='function _weather() { curl wttr.in/$1; }; _weather' # This shows the weather for your system location using the wttr.in service

alias jsonpretty='function _jsonpretty() { python -m json.tool $1; }; _jsonpretty' # This pretty prints JSON file

alias to='function _to() { cd "$@" && tree; }; _to' # - This allows you to navigate to a directory and list the files in it with a single command and also show the directory tree

alias search='function _search() { grep -r --exclude-dir={.git,.svn} $1 *; }; _search' # This recursively searches for a specified string in all files in the current directory and its subdirectories, excluding version control directories

################################################## Proxmox Section ##################################################
alias qmt="qm terminal $1 --escape ^]"




################################################## Zerotier Section ##################################################
alias zt-install="curl -s https://install.zerotier.com | sudo bash"
alias ztcli="zerotier-cli $*"



################################################# Mac OS Specific aliases ###########################################
alias dockervm="docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh"
