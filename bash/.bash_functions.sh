#!/bin/bash
#
# Bash functions
# System info

get_OS () {
    hostnamectl | grep -Po "^Operating System: \K[^<]+"
}


simple-http-server() {
    docker stop http-server
    docker run --rm \
            --name http-server \
            -v $(pwd):/serve \
            -P \
            -d \
            jdkelley/simple-http-server:latest
    echo -ne "\nBrowse to http://localhost:"
    docker port http-server | cut -d':' -f'2'
    docker logs -f http-server
}

# Updates
update () {
    if [[ $(get_OS) == *"Ubuntu"* ]]; then
        sudo echo -e "updating available software\n----"
        sudo apt-get update;
        echo -e "\nupgrading software\n----"
        sudo apt-get upgrade;
        echo -e "\nremoving obsolete dependency software\n----"
        sudo apt-get autoremove --purge;
        echo -e "\nremoving software in local cache\n----"
        sudo apt-get clean;
        echo "Done"
    elif [[ $(get_OS) == *"Fedora"* ]]; then
        sudo echo -e "updating available software\n----"
        sudo dnf upgrade
        echo -e "\nremoving obsolete dependency software\n----"
        sudo dnf autoremove
        echo -e "\nremoving software in local cache\n----"
        sudo dnf clean all
        echo "Done"
    fi
}

function cl() {
    DIR="$*";
    # if no DIR given, go home
    if [ $# -lt 1 ]; then
            DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

# Aliases and functions which help in working with virsh and qemu
function sshl {
  ip=$(virsh net-dhcp-leases default | grep ${1} | awk '{print $5}' | sed 's/\/24//')
  ssh ubuntu@${ip} -i ~/.ssh/id_cloudinit_rsa
}

function myip {
  ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
  echo $ip
}

function ssh_ip {
    local HOST=$1
    IP_LINE=$(grep -A 4 -e ${HOST} ~/.ssh/config | grep HostName | sed -E 's/HostName\s+(.+)/\1/M' | sed 's/^ *//;s/ *$//' )
    echo $IP_LINE
}

function set_win_title(){
    echo -ne "\033]0; ${USER}@${HOSTNAME} \007"
    # echo -ne "\033]0; $USER on $HOSTNAME, at $(basename "$PWD") \007"
}

starship_precmd_user_func="set_win_title"

##################################################### PROXMOX ######################################################
function pve_vmip {
    qm guest cmd $1 network-get-interfaces
}

function randomkey() {
    local NUM_CHARS="${1:-30}"
    tr -dc A-Za-z0-9 </dev/urandom | head -c ${NUM_CHARS} ; echo ''
}

function prompt() {
    read -p "$1 (yes/no) " yn

    case $yn in 
        yes ) echo ok, we will proceed;;
        no ) echo exiting...;
            exit;;
        * ) echo invalid response;
            exit 1;;
    esac
}

speed_test() {
    local nodeName="$2"
    [ -z "$1" ] && speedtest --progress=no --accept-license --accept-gdpr > /tmp/speedtest.log 2>&1 || \
    speedtest --progress=no --server-id=$1 --accept-license --accept-gdpr > /tmp/speedtest.log 2>&1
    if [ $? -eq 0 ]; then
        local dl_speed=$(awk '/Download/{print $3" "$4}' /tmp/speedtest.log)
        local up_speed=$(awk '/Upload/{print $3" "$4}' /tmp/speedtest.log)
        local latency=$(awk '/Latency/{print $2" "$3}' /tmp/speedtest.log)
        if [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
            printf "\033[0;33m%-18s\033[0;32m%-18s\033[0;31m%-20s\033[0;36m%-12s\033[0m\n" " ${nodeName}" "${up_speed}" "${dl_speed}" "${latency}"
        fi
    fi
}

speed() {
    speed_test '' 'Speedtest.net'
    speed_test '21541' 'Los Angeles, US'
    speed_test '43860' 'Dallas, US'
    speed_test '40879' 'Montreal, CA'
    speed_test '24215' 'Paris, FR'
    speed_test '28922' 'Amsterdam, NL'
    speed_test '24447' 'Shanghai, CN'
    speed_test '26352' 'Nanjing, CN'
    speed_test '27594' 'Guangzhou, CN'
    speed_test '32155' 'Hongkong, CN'
    speed_test '6527'  'Seoul, KR'
    speed_test '7311'  'Singapore, SG'
    speed_test '21569' 'Tokyo, JP'
}
