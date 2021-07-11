#!/bin/bash

export RESET="[0;000m"
export BOLD="[0;001m"
export DIM="[0;002m"
export ITALIC="[0;003m"
export UNDERLINED="[0;004m"
export BLINK="[0;005m"
export REVERSE="[0;007m"
export HIDDEN="[0;008m"

export BLACK="[0;030m"
export DARK_RED="[0;031m"
export DARK_GREEN="[0;032m"
export DARK_ORANGE="[0;033m"
export DARK_BLUE="[0;034m"
export DARK_PURPLE="[0;035m"
export DARK_CYAN="[0;036m"

export LIGHT_GREY="[0;040m"
export DARK_GREY="[0;090m"
export RED="[0;091m"
export GREEN="[0;092m"
export YELLOW="[0;093m"
export BLUE="[0;094m"
export PURPLE="[0;095m"
export CYAN="[0;096m"
export WHITE="[0;097m"

export LIGHT_GREY_B="[1;040m"
export DARK_GREY_B="[1;090m"
export RED_B="[1;091m"
export GREEN_B="[1;092m"
export YELLOW_B="[1;093m"
export BLUE_B="[1;094m"
export PURPLE_B="[1;095m"
export CYAN_B="[1;096m"
export WHITE_B="[1;097m"

export ROOT_DEFAULT_COLOR="[1;38;5;125m"
export HOST_DEFAULT_COLOR="[1;38;5;126m"
export TERMINAL_DEFAULT_COLOR="[0;38;5;230m"
export TERMINAL_DEFAULT_COLOR_B="[1;38;5;230m"

#  dircolors -b >> fileName
#
#  no    NORMAL, NORM             Global default, although everything should be something
#  fi    FILE                     Normal file
#  di    DIR                      Directory
#  ln    SYMLINK, LINK, LNK       Symbolic link. If you set this to `target' instead of a numerical value,
#                                 the color is as for the file pointed to.
#  pi    FIFO, PIPE               Named pipe
#  do    DOOR                     Door
#  bd    BLOCK, BLK               Block device
#  cd    CHAR, CHR                Character device
#  or    ORPHAN                   Symbolic link pointing to a non-existent file
#  so    SOCK                     Socket
#  su    SETUID                   File that is setuid (u+s)
#  sg    SETGID                   File that is setgid (g+s)
#  tw    STICKY_OTHER_WRITABLE    Directory that is sticky and other-writable (+t,o+w)
#  ow    OTHER_WRITABLE           Directory that is other-writable (o+w) and not sticky
#  st    STICKY                   Directory with the sticky bit set (+t) and not other-writable
#  ex    EXEC                     Executable file (i.e. has `x' set in permissions)
#  mi    MISSING                  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
#  lc    LEFTCODE, LEFT           Opening terminal code
#  rc    RIGHTCODE, RIGHT         Closing terminal code
#  ec    ENDCODE, END             Non-filename text
#  *.extension                    Every file using this extension e.g. *.jpg

# 0   = default colour
# 1   = bold
# 4   = underlined
# 5   = flashing text
# 7   = reverse field
# 31  = red
# 32  = green
# 33  = orange
# 34  = blue
# 35  = purple
# 36  = cyan
# 37  = grey
# 40  = black background
# 41  = red background
# 42  = green background
# 43  = orange background
# 44  = blue background
# 45  = purple background
# 46  = cyan background
# 47  = grey background
# 90  = dark grey
# 91  = light red
# 92  = light green
# 93  = yellow
# 94  = light blue
# 95  = light purple
# 96  = turquoise
# 100 = dark grey background
# 101 = light red background
# 102 = light green background
# 103 = yellow background
# 104 = light blue background
# 105 = light purple background
# 106 = turquoise background

DI="1;38;5;230"  # DIRECTORIES
FI="2;38;5;203"  # ORDINARY FILES
AR="1;38;5;203"  # ARCHIVES & COMPRESSED FILES
EX="1;38;5;084"  # EXECUTABLE FILES (UNIX)
XE="2;38;5;084"  # EXECUTABLE FILES (WINDOWS)
TX="0;38;5;032"  # TEXT FILES
GI="0;38;5;240"  # GIT SPECIFIC FILES
CF="4;38;5;203"  # CONFIGURATION FILES (BUILD AUTOMATION TOOLS)
IM="1;38;5;210"  # IMAGE FILES
AU="1;38;5;216"  # AUDIO FILES
VI="1;38;5;222"  # VIDEO FILES

export LS_COLORS="di=$DI:fi=$FI:ex=$EX:*.bat=$XE:*.com=$XE:*.exe=$XE\
:*.7z=$AR\
:*.7zip=$AR\
:*.apk=1;38;5;139\
:*.bz=$AR\
:*.bz2=$AR\
:*.bzip=$AR\
:*.bzip2=$AR\
:*.gz=$AR\
:*.gzip=$AR\
:*.rar=$AR\
:*.tar=$AR\
:*.zip=$AR\
:*.cpp=0;38;5;228\
:*.c=0;38;5;228\
:*.h=0;38;5;222\
:*makefile=$CF\
:*.groovy=1;38;5;24\
:*.kt=0;38;5;135\
:*.gradle=$CF\
:*.gradle.kts=$CF\
:*.java=0;38;5;137\
:*.jsp=2;38;5;137\
:*.class=1;38;5;138\
:*.jar=1;38;5;139\
:*.war=1;38;5;140\
:*.ear=1;38;5;141\
:*.MF=$TX\
:*.properties=$CF\
:*.xml=$CF\
:*.yml=$CF\
:*.htm=0;38;5;209\
:*.html=0;38;5;209\
:*.xhtm=0;38;5;209\
:*.xhtml=0;38;5;209\
:*.css=0;38;5;39\
:*.cjs=1;38;5;150\
:*.mjs=1;38;5;150\
:*.js=1;38;5;150\
:*.jsx=0;38;5;156\
:*.ts=1;38;5;152\
:*.tsx=0;38;5;158\
:*.vue=0;38;5;156\
:*.json=$CF\
:*.lock=$CF\
:*.py=1;38;5;227\
:*.gitattributes=$GI\
:*.gitconfig=$GI\
:*.gitignore=$GI\
:*.gitmodules=$GI\
:*AUTHORS=$TX\
:*CHANGELOG=$TX\
:*CONTRIBUTING=$TX\
:*LICENSE=$TX\
:*NOTICE=$TX\
:*README=$TX\
:*.md=$TX\
:*.pdf=$TX\
:*.csv=$TX\
:*.txt=$TX\
:*.srt=$TX\
:*.sub=$TX\
:*.gif=$IM\
:*.ico=$IM\
:*.jpeg=$IM\
:*.jpg=$IM\
:*.png=$IM\
:*.ape=$AU\
:*.flac=$AU\
:*.mp3=$AU\
:*.wav=$AU\
:*.avi=$VI\
:*.mkv=$VI\
:*.mp4=$VI"
