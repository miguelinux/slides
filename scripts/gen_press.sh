#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

# Teacher
TMP_T=/tmp/press/t
# Student
TMP_S=/tmp/press/s

DIRS="*"
_DIRS=""

compile_student() {
    pdflatex ${1}
    pdflatex ${1}
    pdflatex ${1}
    mv *.pdf $TMP_S
}

compile_teacher() {
    pdflatex ${1}
    pdflatex ${1}
    pdflatex ${1}
    mv *.pdf $TMP_T
}

without_pausa() {
    sed -i "/^\\\newcommand/ s/./%&/" ${1}
    sed -i "/^%\\\newcommand..pausa... .*/ s/.//" ${1}
}

with_pausa() {
    sed -i "/^%\\\newcommand/ s/.//" ${1}
    sed -i "/^\\\newcommand..pausa... .*/ s/./%&/" ${1}
}

rm -rf $TMP_T $TMP_S

mkdir -p $TMP_T
mkdir -p $TMP_S

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
        pushd $d
        my_file=${d:0:3}*.tex
        if grep --quiet "^\\\newcommand..pausa...pause" ${my_file}
        then
            echo teacher: ${my_file}
            compile_teacher ${my_file}
            without_pausa ${my_file}
            compile_student ${my_file}
            with_pausa ${my_file}
            echo teacher: ${my_file}
        else
            echo student: ${my_file}
            compile_student ${my_file}
            with_pausa ${my_file}
            compile_teacher ${my_file}
            without_pausa ${my_file}
            echo student: ${my_file}
        fi
        popd
    fi
done
