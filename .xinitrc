[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

urxvtd -q -o -f

autocutsel -fork &
autocutsel -selection PRIMARY -fork -pause 500 &

setxkbmap -layout us,ru -option grp:caps_toggle,compose:ralt

xinput set-button-map 14 1 3 2 4 5 6 7
xinput set-prop 14 284 -0.75
xinput set-prop 14 278 1

while true; do

WDEV=wlp3s0

if [ "$(cat /sys/class/power_supply/AC0/online)" -eq "1" ]; then
    BATTERY="";
else
    BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full`));
    BATTERY="$BATTERY% ";
fi;

if [ $(cat /sys/class/net/$WDEV/operstate) == "up" ]; then
    SSID=$(iw dev $WDEV link |grep SSID | awk '{print $2}');
    SSID="$SSID ";
else
    SSID="";
fi;

GMAIL=$($HOME/bin/gmail.py);

TIME=$(date '+%R');

xsetroot -name "$GMAIL$SSID $BATTERY $TIME";

sleep 60;

done &

dwm
