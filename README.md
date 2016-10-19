# i3lock-blur

Based on petvas' i3lock-blur using ffmpeg and also on meskarune's and guimeira's multimonitor lock logo implementations

This solution uses ffmpeg to get a blurred screenshot and then uses ffmpeg again to overlay the lock logo separately

You can use any lock logo you want as the script looks up the logo size at runtime

##Dependencies:
- [ffmpeg](www.ffmpeg.org)
- realpath
- i3lock

##i3lock-color:
Fun fact of the day: the original i3lock-color is no longer being maintained
Therefore I added handling to avoid errors if you don't have i3lock-color installed. But there is another version of i3lock-color that is still being maintained [here](https://github.com/chrjguill/i3lock-color).

##Example Usage:

1. Create symlink in /usr/local/bin to where lock.sh ends up `sudo ln -s $(pwd)/lock.sh /usr/local/bin/i3lock-blur`
2. Add i3 config: `bindsym $mod+q exec i3lock-blur` to bind lock to `mod+q`
3. PROFIT!!!
