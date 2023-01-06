#!/usr/bin/env bash
. config-minecraft.sh

if [ ! -f $IDLE_LOCKFILE ]; then
  touch $IDLE_LOCKFILE
  debug "No lock file, checking!"
  if pgrep -U $SERVER_USER -f "$MINECRAFT_JAR" >/dev/null; then
    debug "Server is up, checking"
  if idle; then
    debug "Idle, waiting!..."
    sleep $WAIT_TIME
    if idle; then
      debug "Still idle, stopping!"
      stop
    fi
    fi
  else
    debug "Server is not up, I'm done!"
  fi
  /bin/rm $IDLE_LOCKFILE
fi
debug "Idle check complete"