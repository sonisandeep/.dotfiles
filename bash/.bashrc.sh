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

detect_os() {
  # Detect OS
  # $os_version variables aren't always in use, but are kept here for convenience
  if grep -qs "ubuntu" /etc/os-release; then
          os="ubuntu"
          os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
  elif [[ -e /etc/debian_version ]]; then
          os="debian"
          os_version=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
  elif [[ -e /etc/almalinux-release || -e /etc/rocky-release || -e /etc/centos-release ]]; then
          os="centos"
          os_version=$(grep -shoE '[0-9]+' /etc/almalinux-release /etc/rocky-release /etc/centos-release | head -1)
  elif [[ -e /etc/fedora-release ]]; then
          os="fedora"
          os_version=$(grep -oE '[0-9]+' /etc/fedora-release | head -1)
  else
          echo "This installer seems to be running on an unsupported distribution.
  Supported distros are Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS and Fedora."
          exit
  fi
}

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