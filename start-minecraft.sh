#!/usr/bin/env bash

. config-minecraft.sh

sign(){
  protocol_version="47"
  minecraft_version="1.6.4"
  motd="Up in just a sec.."
  current_players="0"
  max_players="0"
  char_length=$((${#protocol_version}+${#motd}+${#current_players}+${#max_players}))
  # Kick protocol start
  echo -en "\xFF"
  # Length in characters: (including protocol, MOTD, current, max players)
  #               22
  #               |
  echo-utf16be "${char_length}"
  # UTF-16BE String: Protocol header
  echo -en "\x00\xA7\x00\x31\x00\x00"
  # Protocol version:
  #                4       7
  #                |       |
  # echo -en "\x00\x34\x00\x37\x00\x00"
  echo-utf16be "${protocol_version}\0"
  # Minecraft version:
  #                1       .       6        .      4
  #                |               |               |
  # echo -en "\x00\x31\x00\x2E\x00\x36\x00\x2E\x00\x34\x00\x00"
  echo-utf16be "${minecraft_version}\0"
  # MOTD: "Up in just a sec.."
  # echo -en "\x00\x55\x00\x70\x00\x20\x00\x69\x00\x6E\x00\x20\x00\x6A\x00\x75\x00\x73\x00\x74\x00\x20\x00\x61\x00\x20\x00\x73\x00\x65\x00\x63\x00\x2E\x00\x2E\x00\x00"
  echo-utf16be "${motd}\0"
  # Current Players:
  #                0
  #                |
  echo -en "\x00\x30\x00\x00"
  # Max Players:
  #                0
  #                |
  echo -en "\x00\x30"
}

if [ ! -f $START_LOCKFILE ]; then
  touch $START_LOCKFILE
  if ! pgrep -U $SERVER_USER -f "$MINECRAFT_JAR" >/dev/null; then
    sudo -u $SERVER_USER -- screen -dmS $SESSION $LAUNCH
    sign
    while netcat -vz -w 1 localhost $LOCAL_PORT 2>&1 | grep refused > /dev/null; do
      debug "Connection refused"
      sleep 1
    done
    debug "Deleting start lock"
    /bin/rm $START_LOCKFILE
    debug `[ -f $START_LOCKFILE ] && echo "Lockfile still exists"`
  else
    /bin/rm $START_LOCKFILE
    debug `[ -f $START_LOCKFILE ] && echo "Lockfile still exists"`
    exec sudo -u $SERVER_USER nc $LOCAL_IP $LOCAL_PORT
  fi
else
  sign
fi