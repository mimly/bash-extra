#!/bin/bash

# shellcheck disable=SC1091

#buildInfo() {
#    local allCharacters=0
#    local nonPrintableCharacters=0
#
#    local CONFIG_FILES=("settings.xml" "build.gradle" "pom.xml" "package.json")
#    local ANT
#    ANT=$(colorize --arrow-right --fg-color 232 --fg-color-step 0 --bg-custom-scheme 0:230,2:229,4:228,6:227,8:226 " ant    ")
#    local GRADLE
#    GRADLE=$(colorize --arrow-right --fg-color 232 --fg-color-step 0 --bg-custom-scheme 0:50,2:49,4:48,6:47,8:46 " gradle ")
#    local MAVEN
#    MAVEN=$(colorize --arrow-right --fg-color 232 --fg-color-step 0 --fg-style 2 --bg-custom-scheme 0:27,3:26,6:25,9:24 " maven  ")
#    local NPM
#    NPM=$(colorize --arrow-right --fg-color 232 --fg-color-step 0 --bg-custom-scheme 0:200,2:199,4:198,6:197,8:196 " npm    ")
#    local TOOLS=("$ANT" "$GRADLE" "$MAVEN" "$NPM")
#
#    local buildInfo
#    for ((i = 0; i < ${#TOOLS[@]}; ++i)) ; do
#        if [[ -f "${CONFIG_FILES[$i]}" ]] ; then
#            buildInfo+="${TOOLS[$i]}"
#        fi
#    done
#
#    allCharacters=$(( ${#buildInfo} + 1 ))
#    nonPrintableCharacters=$(( nonPrintableCharacters + $(read -r -u 7 x ; echo "$x") ))
#
#    printf "%s " "$buildInfo"
#
#    echo $allCharacters >&7
#    echo $nonPrintableCharacters >&7
#}

setLocale() {
    local lang=$1
    if [[ "${lang}" == "EN" ]] ; then
        localectl set-locale LANG=en_US.utf8 &&\
        localectl --no-convert set-keymap us &&\
        setfont Lat2-Terminus16 &&\
        LANG= &&\
        source /etc/profile.d/locale.sh ;\
        printf "Locales changed [US]\n"
    elif [[ "${lang}" == "PL" ]] ; then
        localectl set-locale LANG=pl_PL.utf8 &&\
        localectl --no-convert set-keymap pl &&\
        setfont Lat2-Terminus16 &&\
        LANG= &&\
        source /etc/profile.d/locale.sh ;\
        printf "Locales changed [PL]\n"
    elif [[ "${lang}" == "SV" ]] ; then
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
    local allCharacters nonPrintableCharacters output
    read -r -u 7 allCharacters
    read -r -u 7 nonPrintableCharacters

    output=""
    for (( i = 0; i < $(( allCharacters - nonPrintableCharacters )); ++i )) ; do
        output+=""
    done
    printf "%s" "${output}"
}

historyFormatter() {
    local positionc datec anchorc commandc
    positionc="[0;38;5;251m"
    datec="[0;38;5;253m"
    anchorc="[${HOST_DEFAULT_COLOR}m"
    commandc="[0;38;5;255m"

    sed -E "s/(\\s+)([[:digit:]]+)(\\s+)(.{19})(\\s+)([#$]{1})(\\s+)(.*)/[${ITALIC}m\1${positionc}\2\3${datec}\4\5${anchorc}\6\7${commandc}\8[${TERMINAL_DEFAULT_COLOR}m/g"
}

lsFormatter() {
    local rc wc xc inodec numberc uidc gidc sizec datec
    rc="[1;38;5;228m"
    wc="[1;38;5;204m"
    xc="[1;38;5;84m"
    inodec="[1;38;5;112m"
    numberc="[1;38;5;113m"
    uidc="[1;38;5;114m"
    gidc="[1;38;5;115m"
    sizec="[1;38;5;116m"
    datec="[1;38;5;117m"

    # Replace r, w and x permission attributes by single rare unicode character.
    # ANSI colors include multiple characters.
    local u1 u2 u3 u4 u5 u6

    u1=馑 u2=馒 u3=馓 u4=馔 u5=馕 u6=首  &&\
        sed -E "s/(total [[:digit:]]+(\.[[:digit:]]+)?(K|M|G|T)?)/${sizec}\1[${RESET}m/" |

        sed -E "s/^([0-9 ]*)d/\1${u1}/g" |
        sed -E "s/^([0-9 ]*)l/\1${u2}/g" |
        sed -E "s/^([0-9 ]*)p/\1${u3}/g" |

        sed -E "s/^([0-9 ]*.{1})r/\1${u4}/g" |
        sed -E "s/^([0-9 ]*.{4})r/\1${u4}/g" |
        sed -E "s/^([0-9 ]*.{7})r/\1${u4}/g" |

        sed -E "s/^([0-9 ]*.{2})w/\1${u5}/g" |
        sed -E "s/^([0-9 ]*.{5})w/\1${u5}/g" |
        sed -E "s/^([0-9 ]*.{8})w/\1${u5}/g" |

        sed -E "s/^([0-9 ]*.{3})x/\1${u6}/g" |
        sed -E "s/^([0-9 ]*.{6})x/\1${u6}/g" |
        sed -E "s/^([0-9 ]*.{9})x/\1${u6}/g" |

        sed -E "s/${u1}/[${TERMINAL_DEFAULT_COLOR_B}md[${RESET}m/g" |
        sed -E "s/${u2}/[${LN}ml[${RESET}m/g" |
        sed -E "s/${u3}/[${PI}mp[${RESET}m/g" |
        sed -E "s/${u4}/${rc}r[${RESET}m/g" |
        sed -E "s/${u5}/${wc}w[${RESET}m/g" |
        sed -E "s/${u6}/${xc}x[${RESET}m/g" |

        sed -E "s/([[:digit:]]+)(\\s+)([[:alpha:]]+)(\\s+)([[:alpha:]]+)(\\s+)([0-9.KMGT]+)(\\s+)((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec){1}\\s+([[:digit:]]+)\\s+([0-9:]+))/${numberc}\1\2${uidc}\3\4${gidc}\5\6${sizec}\7\8[${ITALIC}m${datec}\9[${RESET}m/g" |

        sed -E "s/^(\\s*[[:digit:]]+)/${inodec}\1[${RESET}m/g"
}

showDateAndTime() {
    printf "[${YELLOW}m%s" "$( date | awk '{ printf $0 }' )"
}

showBatteryStatus() {
    local color status
    status=$( acpi | awk '{ gsub( /,|%/, "", $4 ); print $4 }' )
    if [[ ${status} -lt 10 ]] ; then
        color="[${DARK_RED}m"
    elif [[ ${status} -lt 30 ]] ; then
        color="[${RED}m"
    elif [[ ${status} -lt 60 ]] ; then
        color="[${YELLOW}m"
    else
        color="[${GREEN}m"
    fi
    printf "${color}%s" "$( acpi | awk '{ gsub( ",", "", $4 ); print $1 ": " $4 }' )"
}

showEntropy() {
    printf "[${YELLOW}m%s" "$( awk '{ print "Entropy: " $0 }' < /proc/sys/kernel/random/entropy_avail )"
}

menu() {
    tput sc &&\
    tput cup 1 98 &&\
    printf "%s %s %s" "$(showDateAndTime)" "$(showBatteryStatus)" "$(showEntropy)" &&\
    tput sgr0 &&\
    tput rc
}

launch() {
    xinit "$@" -- :0 vt"${XDG_VTNR}"
}
