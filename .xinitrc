[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

urxvtd -q -o -f

autocutsel -fork &
autocutsel -selection PRIMARY -fork -pause 1000 &

setxkbmap -layout us,ru -option grp:caps_toggle,compose:ralt

#xinput set-button-map 13 1 3 2 4 5 7 6
#xinput set-prop 13 284 -0.75
#xinput set-prop 13 278 1

while true; do

if [ ! -d /sys/class/power_supply/AC0 ] || [ "$(cat /sys/class/power_supply/AC0/online)" -eq "1" ]  then
    BATTERY="";
else
    BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full`));
    BATTERY="$BATTERY% ";
fi;

TIME=$(date '+%R');

xsetroot -name "$BATTERY$TIME";

sleep 60;

done &

dwm
