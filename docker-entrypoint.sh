cend='\033[0m'
darkorange='\033[38;5;208m'
pink='\033[38;5;197m'
purple='\033[38;5;135m'
green='\033[38;5;41m'
blue='\033[38;5;99m'
printf "%b" "[💡 entrypoint - Info] Hiya, you're running as $(whoami)!\n"
printf "🦆 Who up fraggin' they quaker rn?\n"

printf "%b" "[✨" " $green" "entrypoint" "$cend" "] Starting NGINX\n"
/usr/sbin/nginx -g 'daemon on;'
printf "%b" "[✨" " $green" "entrypoint" "$cend" "] NGINX started!\n"

printf "%b" "[✨" " $green" "entrypoint" "$cend" "] Starting QuakeJS server via NodeJS and leaving entrypoint\n"
exec node /quakejs/build/ioq3ded.js +set fs_game baseq3 set dedicated 1 +exec server.cfg
