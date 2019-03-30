[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

urxvtd -q -o -f
unclutter --timeout 1 -b
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

setxkbmap -layout us,ru -option grp:caps_toggle,compose:ralt

while true; do

if [ ! -d /sys/class/power_supply/AC0 ] || [ "$(cat /sys/class/power_supply/AC0/online)" -eq "1" ]; then
    BATTERY=" ";
else
    BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full`));
    BATTERY=" $BATTERY% ";
fi;

TIME=$(date '+%R');

xsetroot -name "$BATTERY$TIME ";

sleep 60;

done &

dwm
