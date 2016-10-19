#!/bin/bash

tmp_image=/tmp/lockscreen.png

trap 'rm -f "$tmp_image"' EXIT

lock_logo=$(realpath "$0")
lock_logo=${lock_logo%/*}/lock.png
screen_count=$(xrandr | grep '*' | wc -l)
total_resolution=$(xrandr | grep -oP 'current \d{1,} x \d{1,}' | grep -oP '\d{1,} x \d{1,}' | sed 's| x |*|')

#----------------------------------------------
# Get and blur screenshot
#----------------------------------------------
ffmpeg -f x11grab -video_size $total_resolution -y -i $DISPLAY -filter_complex "boxblur=5:3" -vframes 1 -loglevel quiet $tmp_image

#----------------------------------------------
# Add lock overlay
#----------------------------------------------

# Get lock logo dimensions
lock_image_info=$(identify $lock_logo | grep -oP ' \d{1,}x\d{1,} ')
image_width=$(echo $lock_image_info | grep -oP '\d{1,}x' | grep -oP '\d{1,}')
image_height=$(echo $lock_image_info | grep -oP 'x\d{1,}' | grep -oP '\d{1,}')

while read LINE; do
    if [[ "$LINE" =~ ([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+) ]] ; then
        width=${BASH_REMATCH[1]}
        height=${BASH_REMATCH[2]}
        x_off=${BASH_REMATCH[3]}
        y_off=${BASH_REMATCH[4]}
        mid_x_image=$(($width  / 2 + $x_off - $image_width  / 2))
        mid_y_image=$(($height / 2 + $y_off - $image_height / 2))

        # Update image with overlay for screen
        ffmpeg -y -i $tmp_image -i $lock_logo -filter_complex "overlay=$mid_x_image:$mid_y_image" -loglevel quiet $tmp_image
    fi
done <<<"`xrandr`"

#----------------------------------------------
# Invoke i3lock
#----------------------------------------------
color_lock_params=(--textcolor=ffffff00 --insidecolor=ffffff1c --ringcolor=ffffff3e \
                   --linecolor=ffffff00 --keyhlcolor=00000080 --ringvercolor=00000000 \
                   --separatorcolor=22222260 --insidevercolor=0000001c \
                   --ringwrongcolor=00000055 --insidewrongcolor=0000001c)
# Try to use with color parameters
if ! i3lock-color -n "${color_lock_params[@]}" -i "$tmp_image" > /dev/null 2>&1 ; then
    i3lock -n -e -i "$tmp_image"
fi
