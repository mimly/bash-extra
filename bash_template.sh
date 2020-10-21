#!/bin/bash

#####################################################################################
# BEGIN
#####################################################################################
#ID_NAME           |NAME
#ID_NAME           |    ${SCRIPT_NAME} - ${SCRIPT_DESCRIPTION}
#ID_NAME           |
#ID_SYNOPSIS       |SYNOPSIS
#%                 |    ${SCRIPT_NAME} ${SCRIPT_ARGUMENTS}
#ID_SYNOPSIS       |
#####################################################################################
#ID_DESCRIPTION    |DESCRIPTION
#ID_DESCRIPTION    |    ${SCRIPT_FULL_DESCRIPTION}
#ID_DESCRIPTION    |
#####################################################################################
#ID_OPTIONS        |OPTIONS
#####################################################################################
#ID_EXAMPLES       |EXAMPLES
#####################################################################################
#ID_SEE_ALSO       |SEE ALSO
#####################################################################################
#ID_BUGS           |BUGS
#####################################################################################
#ID_ABOUT          |ABOUT
#ID_ABOUT          |    name           ${SCRIPT_NAME}
#ID_ABOUT          |    version        ${SCRIPT_VERSION}
#ID_ABOUT          |    author         ${SCRIPT_AUTHOR} (${SCRIPT_GIT})
#ID_ABOUT          |    license        ${SCRIPT_LICENSE}
#ID_ABOUT          |
#####################################################################################
#ID_CHANGELOG      |CHANGELOG
#####################################################################################
#ID_DEBUG          |DEBUG
#ID_DEBUG          |    set -n  # Uncomment to check your syntax, without execution
#ID_DEBUG          |    set -x  # Uncomment to debug this shell script
#ID_DEBUG          |
#####################################################################################
# END
#####################################################################################

#####################################################################################
######   D E F A U L T   V A L U E S   ##############################################
#####################################################################################

: "${SCRIPT_NAME=$(basename "${BASH_SOURCE[1]}")}"
: "${SCRIPT_VERSION="0.0.1"}"
: "${SCRIPT_AUTHOR="mimly"}"
: "${SCRIPT_GIT="https://github.com/mimly"}"
: "${SCRIPT_LICENSE="MIT"}"
: "${SCRIPT_DESCRIPTION="Lorem ipsum dolor sit amet, consectetur adipiscing elit."}"
: "${SCRIPT_FULL_DESCRIPTION="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam interdum scelerisque eleifend. Interdum et malesuada fames ac ante ipsum primis in faucibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin a imperdiet ante, non sodales arcu. Donec efficitur, nulla ac lobortis scelerisque, lectus eros efficitur massa, vitae ullamcorper metus purus quis lacus. Curabitur sit amet mi tristique, tincidunt tellus ut, mattis risus. Aenean vulputate rhoncus nisi, et luctus enim dignissim in. Nullam iaculis mollis risus, sit amet laoreet risus scelerisque sed. Phasellus ac luctus nulla, nec fringilla diam. Cras blandit consequat porttitor."}"
: "${SCRIPT_ARGUMENTS="[LOREM]... IPSUM"}"
: "${SCRIPT_OPTIONS[0]="-l LOREM, --lorem=LOREM"}"
: "${SCRIPT_OPTION_DESCRIPTIONS[0]="Lorem ipsum dolor sit amet, consectetur adipiscing elit."}"
: "${SCRIPT_EXAMPLES[0]=}"
: "${SCRIPT_SEE_ALSO[0]=}"
: "${SCRIPT_BUGS[0]=}"

#####################################################################################
######   T E M P L A T E   I N F O   ################################################
#####################################################################################

getTemplateSize() {
    head -100 "$TEMPLATE" | grep -n "^# END" | cut -f1 -d:
}

TEMPLATE=${BASH_SOURCE[0]}
TEMPLATE_SIZE=$(getTemplateSize)

#####################################################################################
######   T E M P L A T E   F U N C T I O N S   ######################################
#####################################################################################

name() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_NAME" | sed -E "
        s/^.{20}//g
        s/\\$\{SCRIPT_NAME\}/${SCRIPT_NAME}/g
        s/\\$\{SCRIPT_DESCRIPTION\}/${SCRIPT_DESCRIPTION}/g"
}

synopsis() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -E "^#(ID_SYNOPSIS|%)" | sed -E "
        s/^.{20}//g
        s/\\$\{SCRIPT_NAME\}/${SCRIPT_NAME}/g
        s/\\$\{SCRIPT_ARGUMENTS\}/${SCRIPT_ARGUMENTS}/g"
}

usage() {
    printf "Usage: "
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#%" | sed -E "
        s/^#%[| ]*//g
        s/\\$\{SCRIPT_NAME\}/${SCRIPT_NAME}/g
        s/\\$\{SCRIPT_ARGUMENTS\}/${SCRIPT_ARGUMENTS}/g"
    printf "Try '%s --help' for more information.\n" "$SCRIPT_NAME"
}

usageFull() {
    name
    synopsis
    description
    options
    examples
    seeAlso
    about
}

description() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -E "^#ID_DESCRIPTION" | sed -E "
        s/^.{20}//g
        s/\\$\{SCRIPT_FULL_DESCRIPTION\}/${SCRIPT_FULL_DESCRIPTION}/g"
}

options() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_OPTIONS" | sed -E "s/^.{20}//g"
    local LEN=0
    for (( i = 0; i < ${#SCRIPT_OPTIONS[@]}; ++i )) ; do
        if [[ $LEN -lt ${#SCRIPT_OPTIONS[$i]} ]] ; then
            LEN=${#SCRIPT_OPTIONS[$i]}
        fi
    done
    for (( i = 0; i < ${#SCRIPT_OPTIONS[@]}; ++i )) ; do
        local L=${SCRIPT_OPTIONS[$i]}
        local R=${SCRIPT_OPTION_DESCRIPTIONS[$i]}
        printf "    %-$(( LEN + 8 ))s%s\n" "$L" "$R"
    done
    printf "\n"
}

examples() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_EXAMPLES" | sed -E "s/^.{20}//g"
    for (( i = 0; i < ${#SCRIPT_EXAMPLES[@]}; ++i )) ; do
        printf "    %s %s\n" "$SCRIPT_NAME" "${SCRIPT_EXAMPLES[$i]}"
    done
    printf "\n"
}

seeAlso() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_SEE_ALSO" | sed -E "s/^.{20}//g"
    for (( i = 0; i < ${#SCRIPT_SEE_ALSO[@]}; ++i )) ; do
        printf "    %s " "${SCRIPT_SEE_ALSO[$i]}"
    done
    printf "\n\n"
}

about() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_ABOUT" | sed -E "
        s/^.{20}//g
        s/\\$\{SCRIPT_NAME\}/${SCRIPT_NAME}/g
        s/\\$\{SCRIPT_VERSION\}/${SCRIPT_VERSION}/g
        s/\\$\{SCRIPT_AUTHOR\}/${SCRIPT_AUTHOR}/g
        s|\\$\{SCRIPT_GIT\}|${SCRIPT_GIT}|g
        s/\\$\{SCRIPT_LICENSE\}/${SCRIPT_LICENSE}/g"
}

changelog() {
    local GIT_REPO
    GIT_REPO="$(dirname "$(whereis "$SCRIPT_NAME" | awk '{print $2}')")"
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_CHANGELOG" | sed -E "s/^.{20}//g"
    git --git-dir="$(realpath "$GIT_REPO")"/.git log --reverse --format="%as|%aN|%s" | awk -F'|' '{printf "    %-15s%s (%s)\n", $1, $3, $2}'
    printf "\n"
}

bugs() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_BUGS" | sed -E "s/^.{20}//g"
    for (( i = 0; i < ${#SCRIPT_BUGS[@]}; ++i )) ; do
        printf "    %s\n" "${SCRIPT_BUGS[$i]}"
    done
    printf "\n"
}

debug() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#ID_DEBUG" | sed -E "s/^.{20}//g"
}

#####################################################################################
######   M A N U A L   F U N C T I O N S   ##########################################
#####################################################################################

updateManual() {
    local MANPATH="/usr/local/man/man1"
    manual > "${SCRIPT_NAME}.1" &&\
    su -c "install -g 0 -o 0 -m 0644 ${SCRIPT_NAME}.1 $MANPATH &&\
        gzip ${MANPATH}/${SCRIPT_NAME}.1" &&\
    rm "${SCRIPT_NAME}.1" &&\
    printf "%s manual updated: %s\n" "${SCRIPT_NAME}" "${MANPATH}/${SCRIPT_NAME}.1.gz"
}

manual() {
    printf ".TH man 1 \"%s\" \"%s\" \"%s man page\"\n" "$(date -I)" "$SCRIPT_VERSION" "$SCRIPT_NAME"
    for SECTION in "$(name)" "$(synopsis)" "$(description)" "$(options)" "$(examples)" "$(seeAlso)" "$(about)" "$(changelog)" "$(bugs)" "$(debug)"; do
        printf ".SH "
        printf "%s" "$SECTION" | head -1
        printf " %s\n" "$SECTION" | tail +2 | sed -E -e "/^[ ]*/i.PP" -e "
            s/^[ ]*//g
            s/(${SCRIPT_NAME})/\\\fB\1\\\fR/g
            s/($(printf "%q" "$SCRIPT_ARGUMENTS"))/\\\fI\1\\\fR/g
            s/(^|[ ]{1})(--[A-Za-z-]+)(([ =]{1})([A-Za-z:.,]+))?/\1\\\fB\2\\\fR\\\fI\3\\\fR/g
            s/(^|[ ]{1})(-[A-Za-z]{1})(([ =]{1})([A-Za-z:.,]+))?/\1\\\fB\2\\\fR\\\fI\3\\\fR/g"
        printf "\n"
    done
}

#####################################################################################
######   O T H E R   F U N C T I O N S   ############################################
#####################################################################################

error() {
    printf "%s: %s\n" "$SCRIPT_NAME" "$1"
}
