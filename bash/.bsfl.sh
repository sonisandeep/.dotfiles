#!/usr/bin/env bash
# -*- tab-width: 4; encoding: utf-8 -*-

## \mainpage
## \section Introduction
## The Bash Shell Function Library (BSFL) is a small Bash script that acts as a library
## for bash scripts. It provides a couple of functions that makes the lives of most
## people using shell scripts a bit easier.

## @file
## @author Louwrentius <louwrentius@gmail.com>
## @author Paul-Emmanuel Raoul <skyper@skyplabs.net>
## @brief Bash Shell Function Library
## @copyright New BSD
## @version 0.1.0
## @par URL
## https://github.com/SkypLabs/bsfl
## @par Purpose
## The Bash Shell Function Library (BSFL) is a small Bash script that acts as a library
## for bash scripts. It provides a couple of functions that makes the lives of most
## people using shell scripts a bit easier.

# Do not edit this file. Just source it into your script
# and override the variables to change their value.

# Variables
# --------------------------------------------------------------#

## @var BSFL_VERSION
## @brief BSFL version number.
declare -rx BSFL_VERSION="0.1.0"

## @var DEBUG
## @brief Enables / disables the debug mode.
## @details The debug mode adds extra information for troubleshooting purposes.
## Value: yes or no (y / n).
declare -x DEBUG="no"

## @var LOGDATEFORMAT
## @brief Sets the log data format (syslog style).
declare -x LOGDATEFORMAT="%FT%T%z"

## @var LOG_FILE
## @brief Sets the log file to use when the logs are enabled.
declare -x LOG_FILE="$0.log"

## @var LOG_ENABLED
## @brief Enables / disables logging in a file.
## @details Value: yes or no (y / n).
declare -x LOG_ENABLED="no"

## @var SYSLOG_ENABLED
## @brief Enables / disables logging to syslog.
## @details Value: yes or no (y / n).
declare -x SYSLOG_ENABLED="no"

## @var SYSLOG_TAG
## @brief Tag to use with syslog.
## @details Value: yes or no (y / n).
declare -x SYSLOG_TAG="$0"

## @var __START_WATCH
## @brief Internal use.
## @private
declare -x __START_WATCH=""

## @var __STACK
## @brief Internal use.
## @private
declare -x __STACK

## @var __TMP_STACK
## @brief Internal use.
## @private
declare -x __TMP_STACK

## @var RED
## @brief Internal color.
declare -rx RED="tput setaf 1"

## @var GREEN
## @brief Internal color.
declare -rx GREEN="tput setaf 2"

## @var YELLOW
## @brief Internal color.
declare -rx YELLOW="tput setaf 3"

## @var BLUE
## @brief Internal color.
declare -rx BLUE="tput setaf 4"

## @var MAGENTA
## @brief Internal color.
declare -rx MAGENTA="tput setaf 5"

## @var CYAN
## @brief Internal color.
declare -rx CYAN="tput setaf 6"

## @var BOLD
## @brief Internal color.
declare -rx BOLD="tput bold"

## @var DEFAULT
## @brief Internal color.
declare -rx DEFAULT="tput sgr0"

## @var RED_BG
## @brief Internal color.
declare -rx RED_BG="tput setab 1"

## @var GREEN_BG
## @brief Internal color.
declare -rx GREEN_BG="tput setab 2"

## @var YELLOW_BG
## @brief Internal color.
declare -rx YELLOW_BG="tput setab 3"

## @var BLUE_BG
## @brief Internal color.
declare -rx BLUE_BG="tput setab 4"

## @var MAGENTA_BG
## @brief Internal color.
declare -rx MAGENTA_BG="tput setab 5"

## @var CYAN_BG
## @brief Internal color.
declare -rx CYAN_BG="tput setab 6"

# Configuration
# --------------------------------------------------------------#

# Bug fix for Bash, parsing exclamation mark.
set +o histexpand

# Groups of functions
# --------------------------------------------------------------#

## @defgroup array Array
## @defgroup command Command
## @defgroup file_and_dir File and Directory
## @defgroup log Log
## @defgroup message Message
## @defgroup misc Miscellaneous
## @defgroup network Network
## @defgroup stack Stack
## @defgroup string String
## @defgroup time Time
## @defgroup variable Variable

# Functions
# --------------------------------------------------------------#

# Group: Variable
# ----------------------------------------------------#

## @fn defined()
## @ingroup variable
## @brief Tests if a variable is defined.
## @param variable Variable to test.
## @retval 0 if the variable is defined.
## @retval 1 in others cases.
defined() {
    [[ "${!1-X}" == "${!1-Y}" ]]
}

## @fn has_value()
## @ingroup variable
## @brief Tests if a variable has a value.
## @param variable Variable to operate on.
## @retval 0 if the variable is defined and if value's length > 0.
## @retval 1 in others cases.
has_value() {
    defined "$1" && [[ -n ${!1} ]]
}

## @fn option_enabled()
## @ingroup variable
## @brief Checks if a variable is set to "y" or "yes".
## @details Useful for detecting if a boolean configuration
## option is set or not.
## @param variable Variable to test.
## @retval 0 if the variable is set to "y" or "yes".
## @retval 1 in others cases.
option_enabled() {
    VAR="$1"
    VAR_VALUE=$(eval echo \$"$VAR")
    if [[ "$VAR_VALUE" == "y" ]] || [[ "$VAR_VALUE" == "yes" ]]; then
        return 0
    else
        return 1
    fi
}

# Group: File and Directory
# ----------------------------------------------------#

## @fn directory_exists()
## @ingroup file_and_dir
## @brief Tests if a directory exists.
## @param directory Directory to operate on.
## @retval 0 if the directory exists.
## @retval 1 in others cases.
directory_exists() {
    if [[ -d "$1" ]]; then
        return 0
    fi
    return 1
}

## @fn file_exists()
## @ingroup file_and_dir
## @brief Tests if a file exists.
## @param file File to operate on.
## @retval 0 if the (regular) file exists.
## @retval 1 in others cases.
file_exists() {
    if [[ -f "$1" ]]; then
        return 0
    fi
    return 1
}

## @fn device_exists()
## @ingroup file_and_dir
## @brief Tests if a device exists.
## @param device Device file to operate on.
## @retval 0 if the device exists.
## @retval 1 in others cases.
device_exists() {
    if [[ -b "$1" ]]; then
        return 0
    fi
    return 1
}

# Group: String
# ----------------------------------------------------#

## @fn to_lower()
## @ingroup string
## @brief Converts uppercase characters in a string to lowercase.
## @param string String to operate on.
## @return Lowercase string.
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

## @fn to_upper()
## @ingroup string
## @brief Converts lowercase characters in a string to uppercase.
## @param string String to operate on.
## @return Uppercase string.
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

## @fn trim()
## @ingroup string
## @brief Removes whitespace from both ends of a string.
## @see <a href="https://unix.stackexchange.com/a/102021">Linux Stack Exchange</a>
## @param string String to operate on.
## @return The string stripped of whitespace from both ends.
trim() {
    echo "${1}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Group: Log
# ----------------------------------------------------#

## @fn log2syslog()
## @ingroup log
## @brief Logs a message using syslog.
## @param message Message to be logged.
log2syslog() {
    if option_enabled  SYSLOG_ENABLED; then
        MESSAGE="$1"
        logger -t "$SYSLOG_TAG" " $MESSAGE" # The space is not a typo!
    fi
}

## @fn log()
## @ingroup log
## @brief Writes a message in a log file and/or to syslog.
## @param message Message to be logged.
## @param status Message status.
log() {
    if option_enabled LOG_ENABLED || option_enabled SYSLOG_ENABLED; then
        LOG_MESSAGE="$1"
        STATE="$2"
        DATE=$(date +"$LOGDATEFORMAT")

        if has_value LOG_MESSAGE; then
            LOG_STRING="$DATE $STATE - $LOG_MESSAGE"
        else
            LOG_STRING="$DATE -- empty log message, no input received --"
        fi

        if option_enabled LOG_ENABLED; then
            echo "$LOG_STRING" >> "$LOG_FILE"
        fi

        if option_enabled SYSLOG_ENABLED; then
            # Syslog already prepends a date/time stamp so only the message
            # is logged.
            log2syslog "$LOG_MESSAGE"
        fi
    fi
}

## @fn log_status()
## @ingroup log
## @brief Logs a message with its status.
## @details The log message is formatted with its status preceding its content.
## @param message Message to be logged.
## @param status Message status.
log_status() {
    if option_enabled LOG_ENABLED; then
        MESSAGE="$1"
        STATUS="$2"

        log "$MESSAGE" "$STATUS"
    fi
}

## @fn log_emergency()
## @ingroup log
## @brief Logs a message with the 'emergency' status.
## @param message Message to be logged.
log_emergency() {
    MESSAGE="$1"
    STATUS="EMERGENCY"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_alert()
## @ingroup log
## @brief Logs a message with the 'alert' status.
## @param message Message to be logged.
log_alert() {
    MESSAGE="$1"
    STATUS="ALERT"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_critical()
## @ingroup log
## @brief Logs a message with the 'critical' status.
## @param message Message to be logged.
log_critical() {
    MESSAGE="$1"
    STATUS="CRITICAL"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_error()
## @ingroup log
## @brief Logs a message with the 'error' status.
## @param message Message to be logged.
log_error() {
    MESSAGE="$1"
    STATUS="ERROR"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_warning()
## @ingroup log
## @brief Logs a message with the 'warning' status.
## @param message Message to be logged.
log_warning() {
    MESSAGE="$1"
    STATUS="WARNING"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_notice()
## @ingroup log
## @brief Logs a message with the 'notice' status.
## @param message Message to be logged.
log_notice() {
    MESSAGE="$1"
    STATUS="NOTICE"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_info()
## @ingroup log
## @brief Logs a message with the 'info' status.
## @param message Message to be logged.
log_info() {
    MESSAGE="$1"
    STATUS="INFO"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_debug()
## @ingroup log
## @brief Logs a message with the 'debug' status.
## @param message Message to be logged.
log_debug() {
    MESSAGE="$1"
    STATUS="DEBUG"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_ok()
## @ingroup log
## @brief Logs a message with the 'ok' status.
## @param message Message to be logged.
log_ok() {
    MESSAGE="$1"
    STATUS="OK"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_not_ok()
## @ingroup log
## @brief Logs a message with the 'not ok' status.
## @param message Message to be logged.
log_not_ok() {
    MESSAGE="$1"
    STATUS="NOT_OK"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_failed()
## @ingroup log
## @brief Logs a message with the 'failed' status.
## @param message Message to be logged.
log_failed() {
    MESSAGE="$1"
    STATUS="FAILED"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_success()
## @ingroup log
## @brief Logs a message with the 'success' status.
## @param message Message to be logged.
log_success() {
    MESSAGE="$1"
    STATUS="SUCCESS"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_passed()
## @ingroup log
## @brief Logs a message with the 'passed' status.
## @param message Message to be logged.
log_passed() {
    MESSAGE="$1"
    STATUS="PASSED"
    log_status "$MESSAGE" "$STATUS"
}

# Group: Message
# ----------------------------------------------------#

## @fn msg()
## @ingroup message
## @brief Similar to the 'echo' function but with extra features.
## @details This function basically replaces the 'echo' function in bash scripts.
## The added functionalities over 'echo' are logging and using colors.
## @param message Message to display.
## @param color Text color.
msg() {
    MESSAGE="$1"
    COLOR="$2"

    if ! has_value COLOR; then
        COLOR="$DEFAULT"
    fi

    if has_value "MESSAGE"; then
        $COLOR
        echo "$MESSAGE"
        $DEFAULT
        if ! option_enabled "DONOTLOG"; then
            log "$MESSAGE"
        fi
    else
        echo "-- no message received --"
        if ! option_enabled "DONOTLOG"; then
            log "$MESSAGE"
        fi
    fi
}

## @fn msg_status()
## @ingroup message
## @brief Displays a message with its status at the end of the line.
## @param message Message to display.
## @param status Message status.
msg_status() {
    MESSAGE="$1"
    STATUS="$2"

    export DONOTLOG="yes"
    log_status "$MESSAGE" "$STATUS"
    msg "$MESSAGE"
    display_status "$STATUS"
    export DONOTLOG="no"
}

## @fn msg_emergency()
## @ingroup message
## @brief Displays a message with the 'emergency' status.
## @param message Message to display.
msg_emergency() {
    MESSAGE="$1"
    STATUS="EMERGENCY"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_alert()
## @ingroup message
## @brief Displays a message with the 'alert' status.
## @param message Message to display.
msg_alert() {
    MESSAGE="$1"
    STATUS="ALERT"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_critical()
## @ingroup message
## @brief Displays a message with the 'critical' status.
## @param message Message to display.
msg_critical() {
    MESSAGE="$1"
    STATUS="CRITICAL"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_error()
## @ingroup message
## @brief Displays a message with the 'error' status.
## @param message Message to display.
msg_error() {
    MESSAGE="$1"
    STATUS="ERROR"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_warning()
## @ingroup message
## @brief Displays a message with the 'warning' status.
## @param message Message to display.
msg_warning() {
    MESSAGE="$1"
    STATUS="WARNING"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_notice()
## @ingroup message
## @brief Displays a message with the 'notice' status.
## @param message Message to display.
msg_notice() {
    MESSAGE="$1"
    STATUS="NOTICE"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_info()
## @ingroup message
## @brief Displays a message with the 'info' status.
## @param message Message to display.
msg_info() {
    MESSAGE="$1"
    STATUS="INFO"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_debug()
## @ingroup message
## @brief Displays a message with the 'debug' status.
## @param message Message to display.
msg_debug() {
    MESSAGE="$1"
    STATUS="DEBUG"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_ok()
## @ingroup message
## @brief Displays a message with the 'ok' status.
## @param message Message to display.
msg_ok() {
    MESSAGE="$1"
    STATUS="OK"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_not_ok()
## @ingroup message
## @brief Displays a message with the 'not ok' status.
## @param message Message to display.
msg_not_ok() {
    MESSAGE="$1"
    STATUS="NOT_OK"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_failed()
## @ingroup message
## @brief Displays a message with the 'failed' status.
## @param message Message to display.
msg_failed() {
    MESSAGE="$1"
    STATUS="FAILED"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_success()
## @ingroup message
## @brief Displays a message with the 'success' status.
## @param message Message to display.
msg_success() {
    MESSAGE="$1"
    STATUS="SUCCESS"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_passed()
## @ingroup message
## @brief Displays a message with the 'passed' status.
## @param message Message to display.
msg_passed() {
    MESSAGE="$1"
    STATUS="PASSED"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn __raw_status()
## @ingroup message
## @brief Internal use.
## @private
## @details This function just positions the cursor one row
## up and to the right. It then prints the message to display
## with the specified color. It is used for displaying colored
## status messages on the right side of the screen.
## @param status Message status.
## @param color Message color.
__raw_status() {
    STATUS="$1"
    COLOR="$2"

    position_cursor () {
        ((RES_COL=$(tput cols)-12))
        tput cuf $RES_COL
        tput cuu1
    }

    position_cursor
    echo -n "["
    $DEFAULT
    $BOLD
    $COLOR
    echo -n "$STATUS"
    $DEFAULT
    echo "]"
}

## @fn display_status()
## @ingroup message
## @brief Displays the specified message status on the right
## side of the screen.
## @param status Message status to display.
display_status() {
    STATUS="$1"

    case $STATUS in
        EMERGENCY )
            STATUS="EMERGENCY"
            COLOR="$RED"
            ;;
        ALERT )
            STATUS="  ALERT  "
            COLOR="$RED"
            ;;
        CRITICAL )
            STATUS="CRITICAL "
            COLOR="$RED"
            ;;
        ERROR )
            STATUS="  ERROR  "
            COLOR="$RED"
            ;;
        WARNING )
            STATUS=" WARNING "
            COLOR="$YELLOW"
            ;;
        NOTICE )
            STATUS=" NOTICE  "
            COLOR="$BLUE"
            ;;
        INFO )
            STATUS="  INFO   "
            COLOR="$CYAN"
            ;;
        DEBUG )
            STATUS="  DEBUG  "
            COLOR="$DEFAULT"
            ;;
        OK  )
            STATUS="   OK    "
            COLOR="$GREEN"
            ;;
        NOT_OK)
            STATUS=" NOT OK  "
            COLOR="$RED"
            ;;
        PASSED )
            STATUS=" PASSED  "
            COLOR="$GREEN"
            ;;
        SUCCESS )
            STATUS=" SUCCESS "
            COLOR="$GREEN"
            ;;
        FAILURE | FAILED )
            STATUS=" FAILED  "
            COLOR="$RED"
            ;;
        *)
            STATUS="UNDEFINED"
            COLOR="$YELLOW"
    esac

    __raw_status "$STATUS" "$COLOR"
}

# Group: Command
# ----------------------------------------------------#

## @fn cmd()
## @ingroup command
## @brief Executes a command and displays its status ('OK' or 'FAILED').
## @param command Command to execute.
cmd() {
    COMMAND="$*"
    msg "Executing: $COMMAND"

    RESULT=$(eval "$COMMAND" 2>&1)
    ERROR="$?"

    MSG="Command: ${COMMAND:0:29}..."

    tput cuu1

    if [ "$ERROR" == "0" ]; then
        msg_ok "$MSG"
        if option_enabled DEBUG; then
            msg "$RESULT"
        fi
    else
        msg_failed "$MSG"
        log "$RESULT"
    fi

    return "$ERROR"
}

# Group: Time
# ----------------------------------------------------#

## @fn now()
## @ingroup time
## @brief Displays the current timestamp.
## @return Current timestamp.
now() {
    date +%s
}

## @fn elapsed()
## @ingroup time
## @brief Displays the time elapsed between the 'start' and 'stop'
## parameters.
## @param start Start timestamp.
## @param stop Stop timestamp.
## @return Time elapsed between the 'start' and 'stop' parameters.
elapsed() {
    START="$1"
    STOP="$2"

    ELAPSED=$(( STOP - START ))
    echo $ELAPSED
}

## @fn start_watch()
## @ingroup time
## @brief Starts the watch.
start_watch() {
    __START_WATCH=$(now)
}

## @fn stop_watch()
## @ingroup time
## @brief Stops the watch and displays the time elapsed.
## @retval 0 if succeed.
## @retval 1 if the watch has not been started.
## @return Time elapsed since the watch has been started.
stop_watch() {
    if has_value __START_WATCH; then
        STOP_WATCH=$(now)
        elapsed "$__START_WATCH" "$STOP_WATCH"
        return 0
    else
        return 1
    fi
}

# Group: Miscellaneous
# ----------------------------------------------------#

## @fn die()
## @ingroup misc
## @brief Prints an error message to stderr and exits
## with the error code given as parameter. The message
## is also logged.
## @param errcode Error code.
## @param errmsg Error message.
die() {
    local -r err_code="$1"
    local -r err_msg="$2"
    local -r err_caller="${3:-$(caller 0)}"

    msg_failed "ERROR: $err_msg"
    msg_failed "ERROR: At line $err_caller"
    msg_failed "ERROR: Error code = $err_code"
    exit "$err_code"
} >&2 # function writes to stderr

## @fn die_if_false()
## @ingroup misc
## @brief Displays an error message and exits if the previous
## command has failed (if its error code is not '0').
## @param errcode Error code.
## @param errmsg Error message.
die_if_false() {
    local -r err_code=$1
    local -r err_msg=$2
    local -r err_caller=$(caller 0)

    if [[ "$err_code" != "0" ]]; then
        die "$err_code" "$err_msg" "$err_caller"
    fi
} >&2 # function writes to stderr

## @fn die_if_true()
## @ingroup misc
## @brief Displays an error message and exits if the previous
## command has succeeded (if its error code is '0').
## @param errcode Error code.
## @param errmsg Error message.
die_if_true() {
    local -r err_code=$1
    local -r err_msg=$2
    local -r err_caller=$(caller 0)

    if [[ "$err_code" == "0" ]]; then
        die "$err_code" "$err_msg" "$err_caller"
    fi
} >&2 # function writes to stderr

# Group: Array
# ----------------------------------------------------#

## @fn __array_append()
## @ingroup array
## @brief Internal use.
## @private
## @param array Array name.
## @param item Item to append.
# shellcheck disable=SC2016
__array_append() {
    echo -n 'eval '
    echo -n "$1" # array name
    echo -n '=( "${'
    echo -n "$1"
    echo -n '[@]}" "'
    echo -n "$2" # item to append
    echo -n '" )'
}

## @fn __array_append_first()
## @ingroup array
## @brief Internal use.
## @private
## @param array Array name.
## @param item Item to append.
__array_append_first() {
    echo -n 'eval '
    echo -n "$1" # array name
    echo -n '=( '
    echo -n "$2" # item to append
    echo -n ' )'
}

## @fn __array_len()
## @ingroup array
## @brief Internal use.
## @private
## @param variable Variable name.
## @param array Array name.
# shellcheck disable=SC2016
__array_len() {
    echo -n 'eval local '
    echo -n "$1" # variable name
    echo -n '=${#'
    echo -n "$2" # array name
    echo -n '[@]}'
}

## @fn array_append()
## @ingroup array
## @brief Appends one or more items to an array.
## @details If the array does not exist, this function will create it.
## @param array Array to operate on.
# shellcheck disable=SC2091
array_append() {
    local array=$1; shift 1
    local len

    $(__array_len len "$array")

    if (( len == 0 )); then
        $(__array_append_first "$array" "$1" )
        shift 1
    fi

    local i
    for i in "$@"; do
        $(__array_append "$array" "$i")
    done
}

## @fn array_size()
## @ingroup array
## @brief Returns the size of an array.
## @param array Array to operate on.
## @return Size of the array given as parameter.
# shellcheck disable=SC2091
array_size() {
    local size

    $(__array_len size "$1")
    echo "$size"
}

## @fn array_print()
## @ingroup array
## @brief Prints the content of an array.
## @param array Array to operate on.
## @return Content of the array given as parameter.
array_print() {
    eval "printf '%s\n' \"\${$1[@]}\""
}

# Group: String
# ----------------------------------------------------#

## @fn str_replace()
## @ingroup string
## @brief Replaces some text in a string.
## @param origin Content to be matched.
## @param destination New content that replaces the matched content.
## @param data Data to operate on.
## @return The new string after having replaced the matched
## content with the new one.
str_replace() {
    local ORIG="$1"
    local DEST="$2"
    local DATA="$3"

    echo "${DATA//$ORIG/$DEST}"
}

## @fn str_replace_in_file()
## @ingroup string
## @brief Replaces some text in a file.
## @param origin Content to be matched.
## @param destination New content that replaces the matched content.
## @param file File to operate on.
## @retval 0 if the original content has been replaced.
## @retval 1 if an error occurred.
str_replace_in_file() {
    [[ $# -lt 3 ]] && return 1

    local ORIG="$1"
    local DEST="$2"

    for FILE in "${@:3:$#}"; do
        file_exists "$FILE" || return 1

        printf ',s/%s/%s/g\nw\nQ' "${ORIG}" "${DEST}" | ed -s "$FILE" > /dev/null 2>&1 || return "$?"
    done

    return 0
}

# Group: Stack
# ----------------------------------------------------#

## @fn __stack_push_tmp()
## @ingroup stack
## @brief Internal use.
## @private
## @param item Item to add on the temporary stack.
__stack_push_tmp() {
    local TMP="$1"

    if has_value __TMP_STACK; then
        __TMP_STACK="${__TMP_STACK}"$'\n'"${TMP}"
    else
        __TMP_STACK="$TMP"
    fi
}

## @fn stack_push()
## @ingroup stack
## @brief Adds an item on the stack.
## @param item Item to add on the stack.
stack_push() {
    line="$1"

    if has_value __STACK; then
        __STACK="${line}"$'\n'"${__STACK}"
    else
        __STACK="$line"
    fi
}

## @fn stack_pop()
## @ingroup stack
## @brief Removes the highest item of the stack and puts it
## in the 'REGISTER' variable.
## @retval 0 if succeed.
## @retval 1 in others cases.
stack_pop() {
    __TMP_STACK=""
    i=0
    tmp=""
    for x in $__STACK; do
        if [ "$i" == "0" ]; then
            tmp="$x"
        else
            __stack_push_tmp "$x"
        fi
        ((i++))
    done
    __STACK="$__TMP_STACK"
    REGISTER="$tmp"
    if [ -z "$REGISTER" ]; then
        return 1
    else
        return 0
    fi
}

# Group: Network
# ----------------------------------------------------#

## @fn is_ipv4()
## @ingroup network
## @brief Tests an IPv4 address.
## @param address Address to test.
## @retval 0 if the address is an IPv4.
## @retval 1 in others cases.
is_ipv4() {
    local -r regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

    [[ $1 =~ $regex ]]
    return $?
}

## @fn is_fqdn()
## @ingroup network
## @brief Tests a FQDN.
## @param fqdn FQDN to test.
## @retval 0 if the FQDN is valid.
## @retval 1 in others cases.
is_fqdn() {
    echo "$1" | grep -Pq '(?=^.{4,255}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}\.?$)'

    return $?
}

## @fn is_ipv4_netmask()
## @ingroup network
## @brief Tests if an IPv4 decimal netmask is valid.
## @param netmask IPv4 decimal netmask to test.
## @retval 0 if the IPv4 decimal netmask is valid.
## @retval 1 in others cases.
# shellcheck disable=SC2154
is_ipv4_netmask() {
    is_ipv4 "$1" || return 1

    IFS='.' read -r ipb[1] ipb[2] ipb[3] ipb[4] <<< "$1"

    local -r list_msb='0 128 192 224 240 248 252 254'

    for i in {1,2,3,4}; do
        if [[ $rest_to_zero ]]; then
            [[ ${ipb[i]} -eq 0 ]] || return 1
        else
            if [[ $list_msb =~ (^|[[:space:]])${ipb[i]}($|[[:space:]]) ]]; then
                local -r rest_to_zero=1
            elif [[ ${ipb[i]} -eq 255 ]]; then
                continue
            else
                return 1
            fi
        fi
    done

    return 0
}

## @fn is_ipv4_cidr()
## @ingroup network
## @brief Tests an IPv4 CIDR netmask.
## @param netmask CIDR netmask to test.
## @retval 0 if the IPv4 CIDR netmask is valid.
## @retval 1 in others cases.
is_ipv4_cidr() {
    local -r regex='^[[:digit:]]{1,2}$'

    [[ $1 =~ $regex ]] || return 1
    [ "$1" -gt 32 ] || [ "$1" -lt 0 ] && return 1

    return 0
}

## @fn is_ipv4_subnet()
## @ingroup network
## @brief Tests an IPv4 subnet.
## @param subnet Subnet to test with /CIDR.
## @retval 0 if the IPv4 subnet is valid.
## @retval 1 in others cases.
is_ipv4_subnet() {
    IFS='/' read -r tip tmask <<< "$1"

    is_ipv4_cidr "$tmask" || return 1
    is_ipv4 "$tip" || return 1

    return 0
}

## @fn get_ipv4_network()
## @ingroup network
## @brief Computes the network address of an IPv4 subnet.
## @param address IPv4 address.
## @param netmask IPv4 netmask.
## @retval 0 if the input parameters are valid.
## @retval 1 in others cases.
## @return Network address.
get_ipv4_network() {
    is_ipv4 "$1" || return 1
    is_ipv4_netmask "$2" || return 1

    IFS='.' read -r ipb1 ipb2 ipb3 ipb4 <<< "$1"
    IFS='.' read -r mb1 mb2 mb3 mb4 <<< "$2"

    echo "$((ipb1 & mb1)).$((ipb2 & mb2)).$((ipb3 & mb3)).$((ipb4 & mb4))"
}

## @fn get_ipv4_broadcast()
## @ingroup network
## @brief Computes the broadcast address of an IPv4 subnet.
## @param address IPv4 address.
## @param netmask IPv4 netmask.
## @retval 0 if the input parameters are valid.
## @retval 1 in others cases.
## @return Broadcast address.
get_ipv4_broadcast() {
    is_ipv4 "$1" || return 1
    is_ipv4_netmask "$2" || return 1

    IFS='.' read -r ipb1 ipb2 ipb3 ipb4 <<< "$1"
    IFS='.' read -r mb1 mb2 mb3 mb4 <<< "$2"

    nmb1=$((mb1 ^ 255))
    nmb2=$((mb2 ^ 255))
    nmb3=$((mb3 ^ 255))
    nmb4=$((mb4 ^ 255))

    echo "$((ipb1 | nmb1)).$((ipb2 | nmb2)).$((ipb3 | nmb3)).$((ipb4 | nmb4))"
}

## @fn mask2cidr()
## @ingroup network
## @brief Converts IPv4 decimal netmask notation into CIDR.
## @param netmask Decimal netmask to convert.
## @retval 0 if the input parameters are valid.
## @retval 1 in others cases.
## @return CIDR notation of the given decimal netmask.
mask2cidr() {
    is_ipv4_netmask "$1" || return 1

    local x=${1##*255.}
    set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) "${x%%.*}"
    x=${1%%$3*}
    echo $(( $2 + (${#x}/4) ))
}

## @fn cidr2mask()
## @ingroup network
## @brief Converts CIDR notation into IPv4 decimal netmask.
## @param netmask CIDR to convert.
## @retval 0 if the input parameters are valid.
## @retval 1 in others cases.
## @return Decimal notation of the given CIDR.
cidr2mask() {
    is_ipv4_cidr "$1" || return 1

    local i mask=""
    local full_octets=$(($1/8))
    local partial_octet=$(($1%8))

    for ((i=0;i<4;i+=1)); do
        if [ $i -lt $full_octets ]; then
            mask+=255
        elif [ $i -eq $full_octets ]; then
            mask+=$((256 - 2**(8-partial_octet)))
        else
            mask+=0
        fi

        test $i -lt 3 && mask+=.
    done

    echo $mask
}