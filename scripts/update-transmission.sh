#!/usr/bin/env bash

set -e

LATEST_PATH="/usr/local/etc/transmission/home/settings.latest.json"
CONFIG_PATH="/usr/local/etc/transmission/home/settings.json"

_log() {
    echo "update-transmission.sh: $1" 1>&2;
}

if test -f "$LATEST_PATH"; then
    _log "found latest config"
else
    _log "latest config does not exist!"
    exit 1
fi

if service transmission status > /dev/null; then
    _log "stopping transmission"
    if service transmission stop > /dev/null; then
	_log "transmission stopped"
    else
	_log "could not stop transmission!"
	exit 1
    fi
else
    _log "transmission already stopped"
fi

_log "copying latest config into place"
cp "$LATEST_PATH" "$CONFIG_PATH"

_log "setting permissions"
chown transmission:transmission "$CONFIG_PATH"
chmod 0600 "$CONFIG_PATH"

_log "starting transmission"
if service transmission start > /dev/null; then
    _log "finished"
else
    _log "could not start transmission!"
    exit 1
fi
