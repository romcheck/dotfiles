[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

urxvtd -q -o -f

autocutsel -fork &
autocutsel -selection PRIMARY -fork -pause 1000 &

setxkbmap -layout us,ru -option grp:caps_toggle,compose:ralt

while true; do

if [ ! -d /sys/class/power_supply/AC0 ] || [ "$(cat /sys/class/power_supply/AC0/online)" -eq "1" ]; then
    BATTERY="";
else
    BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full`));
    BATTERY="$BATTERY%  ";
fi;

GMAIL=$(~/bin/gmail.py)

TIME=$(date '+%R');

xsetroot -name "$GMAIL$BATTERY$TIME";

sleep 60;

done &

dwm
