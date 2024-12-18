#!/bin/bash

CONFIG_FILE="./config.conf"
SYSINFO_SCRIP="./sysinfo.sh"

# Значения по умолчанию
DEFAULT_COLUMN1_BACKGROUND=1
DEFAULT_COLUMN1_FONT_COLOR=4
DEFAULT_COLUMN2_BACKGROUND=3
DEFAULT_COLUMN2_FONT_COLOR=2

COLORS=("white" "red" "green" "blue" "purple" "black")

check_value() {
  if [[ -z "${1}" || "${1}" -lt "1" || "${1}" -gt "6" ]] ; then
    return 1
  else
    return 0
  fi
}


if test -f $CONFIG_FILE ; then
    . ${CONFIG_FILE}

    if check_value $column1_background ; then
        column1_bcg_msg="$column1_background (${COLORS[$column1_background - 1]})"
    else
        column1_background="$DEFAULT_COLUMN1_BACKGROUND"
        column1_bcg_msg="default (${COLORS[$column1_background - 1]})"
    fi

    if check_value $column1_font_color ; then
        column1_fnt_msg="$column1_font_color (${COLORS[$column1_font_color - 1]})"
    else
        column1_font_color="$DEFAULT_COLUMN1_FONT_COLOR"
        column1_fnt_msg="default (${COLORS[$column1_font_color - 1]})"
    fi

    if check_value $column2_background ; then
        column2_bcg_msg="$column2_background (${COLORS[$column2_background - 1]})"
    else
        column2_background=$DEFAULT_COLUMN2_BACKGROUND
        column2_bcg_msg="default (${COLORS[$column2_background - 1]})"
    fi

    if check_value $column2_font_color ; then
        column2_fnt_msg="$column2_font_color (${COLORS[$column2_font_color - 1]})"
    else
        column2_font_color=$DEFAULT_COLUMN2_FONT_COLOR
        column2_fnt_msg="default (${COLORS[$column2_font_color - 1]})"
    fi
else
    column1_background=$DEFAULT_COLUMN1_BACKGROUND
    column1_bcg_msg="default (${COLORS[$column1_background - 1]})"
    column2_background=$DEFAULT_COLUMN2_BACKGROUND
    column2_bcg_msg="default (${COLORS[$column2_background - 1]})"
    column1_font_color=$DEFAULT_COLUMN1_FONT_COLOR
    column1_fnt_msg="default (${COLORS[$column1_font_color - 1]})"
    column2_font_color=$DEFAULT_COLUMN2_FONT_COLOR
    column2_fnt_msg="default (${COLORS[$column2_font_color - 1]})"
fi

if test -f $SYSINFO_SCRIP ; then
    $SYSINFO_SCRIP $column1_background $column1_font_color $column2_background $column2_font_color 
else
    echo "Executable script $SYSINFO_SCRIPT not found."
fi

echo "Column 1 Background: ${column1_bcg_msg}"
echo "Column 1 Font Color: ${column1_fnt_msg}"
echo "Column 2 Background: ${column2_bcg_msg}"
echo "Column 2 Font Color: ${column2_fnt_msg}"