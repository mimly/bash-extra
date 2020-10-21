#!/bin/bash

buildInfo() {
    :
}

setLocale() {
    local lang=$1
    if [[ "$lang" -eq "EN" ]] ; then
        localectl set-locale LANG=en_US.utf8 &&\
        localectl --no-convert set-keymap us &&\
        setfont Lat2-Terminus16 &&\
        LANG= &&\
        source /etc/profile.d/locale.sh ;\
        printf "Locales changed [US]\n"
    elif [[ "$lang" -eq "PL" ]] ; then
        localectl set-locale LANG=pl_PL.utf8 &&\
        localectl --no-convert set-keymap pl &&\
        setfont Lat2-Terminus16 &&\
        LANG= &&\
        source /etc/profile.d/locale.sh ;\
        printf "Locales changed [PL]\n"
    elif [[ "$lang" -eq "SV" ]] ; then
        localectl set-locale LANG=sv_SE.utf8 &&\
        localectl --no-convert set-keymap sv-latin1 &&\
        setfont lat9w-16 &&\
        LANG= &&\
        source /etc/profile.d/locale.sh ;\
        printf "Locales changed [SE]\n"
    else
        printf "Unsupported language!\n"
    fi
}

setManualColors() {
    export LESS_TERMCAP_md="[1;38;5;111m" &&\
    export LESS_TERMCAP_me="[0;38;5;230m" &&\
    export LESS_TERMCAP_se="[0;38;5;230m" &&\
    export LESS_TERMCAP_so="[1;44;33m" &&\
    export LESS_TERMCAP_ue="[0;38;5;230m" &&\
    export LESS_TERMCAP_us="[1;38;5;228m"
}

removeHistoryDuplicates() {
    tac ~/.bash_history | awk '!x[$0]++' | tac > ~/.bash_history_temp && mv ~/.bash_history_temp ~/.bash_history
}

# In order to wrap lines correctly -> checkwinsize/ps
padWithNonPrintableCharacters() {
    local allCharacters
    read -r -u 7 allCharacters
    local nonPrintableCharacters
    read -r -u 7 nonPrintableCharacters

    local output=""
    for (( i = 0; i < $(( allCharacters - nonPrintableCharacters )); ++i )) ; do
        output+=""
    done
    printf "%s" "$output"
}

historyFormatter() {
    local POSITION_COLOR="[0;38;5;251m"
    local DATE_COLOR="[0;38;5;253m"
    local ANCHOR_COLOR=$HOST_DEFAULT_COLOR
    local COMMAND_COLOR="[0;38;5;255m"

    sed -E "s/(\\s+)([[:digit:]]+)(\\s+)(.{19})(\\s+)([#$]{1})(\\s+)(.*)/$ITALIC\1$POSITION_COLOR\2\3$DATE_COLOR\4\5$ANCHOR_COLOR\6\7$COMMAND_COLOR\8$TERMINAL_DEFAULT_COLOR/g"
}

lsFormatter() {
    local WHITE="[1;38;5;230m"
    local YELLOW="[1;38;5;228m"
    local RED="[1;38;5;204m"
    local GREEN="[1;38;5;84m"

    local INODE_COLOR="[1;38;5;112m"
    local NUMBER_COLOR="[1;38;5;113m"
    local UID_COLOR="[1;38;5;114m"
    local GID_COLOR="[1;38;5;115m"
    local SIZE_COLOR="[1;38;5;116m"
    local DATE_COLOR="[1;38;5;117m"

    sed -E "s/(total [[:digit:]]+(\.[[:digit:]]+)?(K|M|G|T)?)/$SIZE_COLOR\1$RESET/" |

    # Replace r, w and x permission attributes by single rare character.
    # ANSI colors include multiple characters.
    sed -E "s/^([0-9 ]*)d/\1\!/g" |

    sed -E "s/^([0-9 ]*.{1})r/\1\%/g" |
    sed -E "s/^([0-9 ]*.{4})r/\1\%/g" |
    sed -E "s/^([0-9 ]*.{7})r/\1\%/g" |

    sed -E "s/^([0-9 ]*.{2})w/\1\@/g" |
    sed -E "s/^([0-9 ]*.{5})w/\1\@/g" |
    sed -E "s/^([0-9 ]*.{8})w/\1\@/g" |

    sed -E "s/^([0-9 ]*.{3})x/\1\?/g" |
    sed -E "s/^([0-9 ]*.{6})x/\1\?/g" |
    sed -E "s/^([0-9 ]*.{9})x/\1\?/g" |

    sed -E "s/\!/${WHITE}d$RESET/g" |
    sed -E "s/\%/${YELLOW}r$RESET/g" |
    sed -E "s/\@/${RED}w$RESET/g" |
    sed -E "s/\?/${GREEN}x$RESET/g" |

    sed -E "s/([[:digit:]]+)(\\s+)([[:alpha:]]+)(\\s+)([[:alpha:]]+)(\\s+)([0-9.KMGT]+)(\\s+)((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec){1}\\s+([[:digit:]]+)\\s+([0-9:]+))/$NUMBER_COLOR\1\2$UID_COLOR\3\4$GID_COLOR\5\6$SIZE_COLOR\7\8$ITALIC$DATE_COLOR\9$RESET/g" |

    sed -E "s/^(\\s*[[:digit:]]+)/$INODE_COLOR\1$RESET/g"
}

showDateAndTime() {
    local output
    output=$( date | awk '{ printf $0 }' )
    printf "$YELLOW%s" "$output"
}

showBatteryStatus() {
    local COLOR
    local output
    output=$( acpi | awk '{ gsub( ",", "", $4 ); print $1 ": " $4 }' )
    local status
    status=$( acpi | awk '{ gsub( /,|%/, "", $4 ); print $4 }' )
    if [[ $status -lt 10 ]] ; then
        COLOR=$DARK_RED
    elif [[ $status -lt 30 ]] ; then
        COLOR=$RED
    elif [[ $status -lt 60 ]] ; then
        COLOR=$YELLOW
    else
        COLOR=$GREEN
    fi
    printf "$COLOR%s" "$output"
}

showEntropy() {
    local output
    output=$( awk '{ print "Entropy: " $0 }' < /proc/sys/kernel/random/entropy_avail )
    printf "$YELLOW%s" "$output"
}

menu() {
    local dateAndTime
    dateAndTime=$(showDateAndTime)
    local batteryStatus
    batteryStatus=$(showBatteryStatus)
    local entropy
    entropy=$(showEntropy)

    tput sc &&\
    tput cup 1 98 &&\
    printf "%s %s %s" "$dateAndTime" "$batteryStatus" "$entropy" &&\
    tput sgr0 &&\
    tput rc
}

launch() {
    xinit "$@" -- :0 vt"$XDG_VTNR"
}
