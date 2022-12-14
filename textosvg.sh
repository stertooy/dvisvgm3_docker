#!/bin/bash

files=( $@ )
folder="/convert"
tempfilename="tex_to_svg_temp"

for file in "${files[@]}"; do
    filename="${file%.*}"
    pdflatex -interaction=batchmode -halt-on-error -output-format=dvi -output-directory=$folder -jobname=$tempfilename $1

    ## INPUT OPTIONS
    # --page                Which page(s) to process, supports ranges.

    ## SVG OUTPUT OPTIONS
    # --bbox                Size of bounding box - use preview to get box from preview package.
    # --clipjoin            Compute intersection of clipping paths, prevents dependency on svg viewer.
    # --embed-bitmaps       Embed bitmaps included using e.g. \includegraphics.
    # --font-format         Use ttf for greatest compatibility, woff/woff2 also possible. Autohint currently gives worse results, do not use.
    # --optimize            Use all for greatest file compression. Should not affect quality.
    # --output              Specify output filename, use %p as current page variable.
    # --precision           Set to 6 for greatest precision of floating-point values.
    # --relative            Relative paths to reduce file size.

    ## PROCESSING OPTIONS
    # --exact-bbox          Calculate exact bounding box.
                 
    /opt/dvisvgm-3.0/src/dvisvgm $folder/$tempfilename.dvi \
        --page=1-                                          \
        --bbox=preview                                     \
        --clipjoin                                         \
        --embed-bitmaps                                    \
        --font-format=ttf                                  \
        --optimize=all                                     \
        --output=$filename-%p.svg                          \
        --precision=6                                      \
        --relative                                         \
        --exact-bbox
    chmod go+w $filename-*.svg
    rm $folder/$tempfilename.*
done

