#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Teacher
TMP_T=/tmp/press/t
# Student
TMP_S=/tmp/press/s

rm -rf $TMP_T $TMP_S

mkdir -p $TMP_T
mkdir -p $TMP_S

for f in $*
do
    if [ -d $f ]
    then
        pushd $f
        my_file=${f:0:3}*
        if grep --quiet "^\\\newcommand..pausa...pause" ${my_file}.tex
        then
            echo teacher
            #pdflatex ${my_file}.tex
            #pdflatex ${my_file}.tex
            #pdflatex ${my_file}.tex
            #mv ${my_file}.pdf $TMP_T
        else
            echo student
        fi
        popd
    fi
done

