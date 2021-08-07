#!/bin/sh

pandoc \
    $1 -f markdown \
    --template /usr/share/eisvogel/eisvogel.latex \
    --pdf-engine=xelatex \
    -o $2 \
    -V lang=ru-RU \
    -V 'mainfont:Exo 2 Light Condensed' \
    -V 'sansfont:Exo 2 Regular Condensed' \
    -V 'monofont:Fira Code' \
    -V 'mathfont:texgyredejavu-math.otf' \
    -V 'fontsize: 14pt' \
    -V 'code-block-font-size: \footnotesize' \
    -V 'listings-disable-line-numbers: true'
