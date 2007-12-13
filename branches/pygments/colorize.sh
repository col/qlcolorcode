#!/bin/zsh

# This code is licensed under the GPL v2.  See LICENSE.txt for details.
  
# colorize.sh
# QLColorCode
#
# Created by Nathaniel Gray on 11/27/07.
# Copyright 2007 Nathaniel Gray. All rights reserved.

# Expects   $1 = path to resources dir of bundle
#           $2 = name of file to colorize
#
# Produces HTML on stdout with exit code 0 on success

# Fail immediately on failure of sub-command
setopt err_exit

rsrcDir=$1
target=$2
thumb=$3

thumblines=50

export PYTHONPATH=$rsrcDir/pygments
pyg=$rsrcDir/pygments/pygmentize
# Styles: manni, perldoc, borland, colorful, default, murphy, trac, fruity, autumn,
#         emacs, pastie, friendly, native
# dark styles: native, fruity
# autumn is almost nice, except that the comments are too light
# don't like: murphy
pygOpts=(-f html -O outencoding=UTF-8,full=True,style=nautumn -P "cssstyles=font-size: small")
font=Monaco

case $target in
    *.plist )
        if [ $thumb = "1" ]; then
            pyg="head -n $thumblines | $pyg"
        fi
        /usr/bin/plutil -convert xml1 -o - $target | $pyg -l xml $pygOpts \
            | sed "s/pre *{/pre { font-family: $font; /"
        ;;
    * )
        if [ $thumb = "1" ]; then
            #echo "making thumbnail: $thumb" >> ~/qlcc-debug.txt
            tmpDir=`mktemp -d -t qlcolorcode-XXXXXX`
            tgtBase="`basename $target`"
            head -n $thumblines $target > $tmpDir/$tgtBase
            target=$tmpDir/$tgtBase
        fi
        $pyg $pygOpts $target \
                | sed "s/pre *{/pre { font-family: $font; /"
        if [ $thumb = "1" ]; then
            rm -rf $tmpDir
        fi
        ;;
esac
