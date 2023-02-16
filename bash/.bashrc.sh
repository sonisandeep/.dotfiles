#!/bin/bash -n
#

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac
# echo ${MACHINE}

# PATH Variable
export PATH="$PATH:/home/ansible/.local/bin"
export PATH="$PATH:/home/xcad/.cargo/bin"

bash_specific_settings() {
    # Bash History Settings
    HISTCONTROL=ignoreboth
    HISTSIZE=1000
    HISTFILESIZE=2000

    shopt -s histappend
    shopt -s checkwinsize

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).

    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi

}


if [ ${MACHINE} = "Mac" ]; then
    RC_FILE=.zshrc
else
    RC_FILE=.bashrc
    bash_specific_settings
fi

# # Configs for bashrc
declare -a FILES_TO_SOURCE=('.prompt.sh' 
                                  '.bash_aliases.sh' 
                                  '.bash_functions.sh' 
                                  '.bsfl.sh' 
                                  '.docker_functions.sh')

for SRC_FILE in "${FILES_TO_SOURCE[@]}" 
do
    if [ -f ${BASH_REPO_DIR}/${SRC_FILE} ]; then
        . ${BASH_REPO_DIR}/${SRC_FILE}
    fi
done