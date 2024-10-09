function fastfetch {
    rm -rf ~/.cache/fastfetch
    builtin read -r rows cols < <(command stty size)
    IFS=x builtin read -r width height < <(command kitten icat --print-window-size); builtin unset IFS
    img=$(find ~/.config/fastfetch/pngs/ -name "*.*" | shuf -n 1)

    imgWidth=$(magick identify -ping -format '%w' $img\[0\])
    imgHeight=$(magick identify -ping -format '%h' $img\[0\])

    cellHeight=$(($height / $rows))
    cellWidth=$(($width / $cols))
    cellRatio=$(echo "scale=2; ${cellHeight}/${cellWidth}" | bc)

    imageScaling=$(echo "scale=2; ${imgHeight}/18" | bc)
    numColsUnadjusted=$(echo "scale=2; ${imgWidth}/${imageScaling}" | bc)
    numCols=$(printf "%.0f" $(echo "scale=2; ${numColsUnadjusted}*${cellRatio}" | bc))

    magick $img\[0\] -channel RGB -brightness-contrast 100 ~/.config/fastfetch/placeholder/bright.png

    clear
    kitty +kitten icat --z-index 1 --place ${numCols}x18@0x0 $img
    /usr/bin/fastfetch
}
