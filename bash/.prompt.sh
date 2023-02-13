#!/bin/bash
#
# Bash prompt
YELLOW=$'\033[0;38;5;222m'
MAGENTA=$'\033[0;38;5;211m'
PURPLE=$'\033[0;38;5;147m'
GREEN=$'\033[0;38;5;150m'
CYAN=$'\033[0;38;5;117m'
WHITE=$'\033[0;37m'
USER_COLOR=$MAGENTA
WORKING_DIR_COLOR=$CYAN
STANDARD_COLOR=$WHITE
force_color_prompt=yes


ID=$(whoami)
if [ "$ID" = "root" ]; then
  SYMBOL="#"
 else
  SYMBOL="$"
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[$WORKING_DIR_COLOR\]\w \[$SYMBOL\]\[$STANDARD_COLOR\] '
else
    PS1='\u@\h:\w\[$SYMBOL\] '
fi


unset color_prompt force_color_prompt


if [ ${MACHINE} = "Mac" ]; then
    NEWLINE=$'\n'
    PROMPT="%F{cyan}%T@%d%f:>${NEWLINE}%F{yellow}~$ %f"
fi


## From Christian Lempa's .bashrc at : https://raw.githubusercontent.com/ChristianLempa/dotfiles/main/.bashrc

# find out which distribution we are running on
LFILE="/etc/*-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"

if [ -f "$MFILE" ]; then
    # If SystemVersion.plist exists it is a MacOS.
    _distro="macos"
else
    _distro=$(find /etc -type f -follow -name "*-release" -exec awk '/^ID=/' {} \; 2> /dev/null |  awk -F'=' '{ print tolower($2) }')
    #_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
fi

# set an icon based on the distro
# make sure your font is compatible with https://github.com/lukas-w/font-logos
# these below are for Hack Ned Fonts
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *coreos*)                ICON="";;
    *gentoo*)                ICON="";;
    *mageia*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *sabayon*)               ICON="";;
    *slackware*)             ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *aosc*)                  ICON="";;
    *nixos*)                 ICON="";;
    *devuan*)                ICON="";;
    *manjaro*)               ICON="";;
    *rhel*)                  ICON="";;
    *macos*)                 ICON="";;
    *)                       ICON="";;
esac

export STARSHIP_DISTRO="$ICON "
export STARSHIP_CONFIG=$BASH_REPO_DIR/.config/starship.toml

if [ $_distro = "macos" ]; then
    eval "$(starship init zsh)"
else
    eval "$(starship init bash)"
fi

