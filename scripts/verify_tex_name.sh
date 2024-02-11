#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

DIRS="*"
_DIRS=""

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
        *)
            _DIRS="${_DIRS} $1"
        ;;
    esac
    shift
done

if [ -n "$_DIRS" ]
then
    DIRS="$_DIRS"
fi

for d in $DIRS
do
    if [ -d $d ]
    then
        my_file=${d:0:3}*.tex
        if [ ! -f $d/${my_file} ]
        then
            echo "$d/${my_file}: not found"
        fi
    fi
done
