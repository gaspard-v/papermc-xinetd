#!/usr/bin/env bash

## Change these configuration variables. They should probably match server.properties
## Leave them blank if you think I'm a good guesser.
SERVER_ROOT=
SERVER_PROPERTIES=
LOCAL_PORT=
LOCAL_IP=
MINECRAFT_JAR=
MINECRAFT_LOG=
SESSION=
WAIT_TIME=
SERVER_USER=
LAUNCH=
START_LOCKFILE=
IDLE_LOCKFILE=
PLAYERS_FILE=
MINECRAFT_OPTS=

## NB: This default may not be sensible
JAVAOPTS=
JAVAOPTS=${JAVAOPTS:--Xmx2G -Xms2G}

## TODO: Currenently not used. Need to recompute size and UTF-16BE
## encode the message, which is annoying
MESSAGE=
## Here be defaults
SERVER_ROOT=${SERVER_ROOT:-/srv/minecraft}
SERVER_PROPERTIES=${SERVER_PROPERTIES:-$SERVER_ROOT/server.properties}
LOCAL_PORT=${LOCAL_PORT:-$(sed -n 's/^server-port=\([0-9]*\)$/\1/p' ${SERVER_PROPERTIES})}
LOCAL_IP=${LOCAL_IP:-$(sed -n 's/^server-ip=\([0-9]*\)$/\1/p' ${SERVER_PROPERTIES})}
MINECRAFT_JAR=${MINECRAFT_JAR:-$SERVER_ROOT/server.jar}
MINECRAFT_LOG=${MINECRAFT_LOG:-$SERVER_ROOT/logs/latest.log}
SESSION=${SESSION:-Minecraft}
MESSAGE=${MESSAGE:-Just a moment please}
WAIT_TIME=${WAIT_TIME:-600}
SERVER_USER=${SERVER_USER:-minecraft}
LAUNCH=${LAUNCH:-/etc/tekkit-on-demand/launch.sh}
START_LOCKFILE=${START_LOCKFILE:-$SERVER_ROOT/minecraft.lock}
IDLE_LOCKFILE=${IDLE_LOCKFILE:-/tmp/minecraftidle}
PLAYERS_FILE=${PLAYERS_FILE:-/tmp/minecraftplayer}
MINECRAFT_OPTS=${MINECRAFT_OPTS:--nogui}
