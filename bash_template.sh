#!/bin/bash

####################################################################
# BEGIN
####################################################################
#0 NAME
#0    ${SCRIPT_NAME} - ${SCRIPT_DESCRIPTION}
#0
#0 SYNOPSIS
#1    ${SCRIPT_NAME} ${SCRIPT_ARGUMENTS}
#0
####################################################################
#2 DESCRIPTION
####################################################################
#3 EXAMPLES
####################################################################
#4 ABOUT
#4    name           ${SCRIPT_NAME}
#4    version        ${SCRIPT_VERSION}
#4    author         ${SCRIPT_AUTHOR} (${SCRIPT_GIT})
#4    license        ${SCRIPT_LICENSE}
#4
####################################################################
#5 CHANGELOG
####################################################################
#6 DEBUG
#6   set -n  # Uncomment to check your syntax, without execution
#6   set -x  # Uncomment to debug this shell script
#6
####################################################################
# END
####################################################################

getTemplateSize() {
    head -33 "$TEMPLATE" | grep -n "^# END" | cut -f1 -d:
}

TEMPLATE=${BASH_SOURCE[0]}
TEMPLATE_SIZE=$(getTemplateSize)

####################################################################

usage() {
    printf "Usage: "
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#1" | sed -e "
        s/^#1[ ]*//g
        s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g
        s/\${SCRIPT_ARGUMENTS}/${SCRIPT_ARGUMENTS}/g"
    printf "Try '%s --help' for more information.\n" "$SCRIPT_NAME"
}

usageFull() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#[01]" | sed -e "
        s/^#[01]//g
        s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g
        s/\${SCRIPT_DESCRIPTION}/${SCRIPT_DESCRIPTION}/g
        s/\${SCRIPT_ARGUMENTS}/${SCRIPT_ARGUMENTS}/g"
    description
    examples
    about
}

description() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#2" | sed -e "s/^#2//g"
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
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#3" | sed -e "s/^#3//g"
    for (( i = 0; i < ${#SCRIPT_EXAMPLES[@]}; ++i )) ; do
        printf "    %s %s\n" "$SCRIPT_NAME" "${SCRIPT_EXAMPLES[$i]}"
    done
    printf "\n"
}

about() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#4" | sed -e "
        s/^#4//g
        s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g
        s/\${SCRIPT_VERSION}/${SCRIPT_VERSION}/g
        s/\${SCRIPT_AUTHOR}/${SCRIPT_AUTHOR}/g
        s|\${SCRIPT_GIT}|${SCRIPT_GIT}|g
        s/\${SCRIPT_LICENSE}/${SCRIPT_LICENSE}/g"
}

changelog() {
    local GIT_REPO
    GIT_REPO="$(dirname "$(whereis "$1" | awk '{print $2}')")"
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#5" | sed -e "s/^#5//g"
    git --git-dir="$(realpath "$GIT_REPO")"/.git log --reverse --format="%as|%aN|%s" | awk -F'|' '{printf "    %-15s%s (%s)\n", $1, $3, $2}'
    printf "\n"
}

debug() {
    head -"$TEMPLATE_SIZE" "$TEMPLATE" | grep -e "^#6" | sed -e "s/^#6//g"
}

error() {
    printf "%s: %s\n" "$SCRIPT_NAME" "$1"
}
