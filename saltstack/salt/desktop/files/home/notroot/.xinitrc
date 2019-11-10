setxkbmap us
xset -dpms s off s noblank s 0 0 s noexpose
xrandr --output `xrandr -q | grep ' connected' | cut -d' ' -f1` --mode `xrandr -q | grep ' connected' -A1 | tail -n 1 | awk '{print $1}'`
[ -f ~/.wallpaper ] || wget http://www.brendangregg.com/Perf/linux_perf_tools_full.png -O ~/.wallpaper
type -p feh && feh --bg-scale ~/.wallpaper
while :; do xsetroot -name "mem: $( free -m | grep Mem | awk '{print $3 / $2 * 100}')%  | $(date)"; sleep 10; done &
while true; do echo 'connect 11:1B:78:3B:BD:57' | bluetoothctl || /bin/true; sleep 10; done &
[[ -f /usr/bin/kodi ]] && (sleep 10; export DISPLAY=:0; /usr/bin/kodi) &
exec dwm
