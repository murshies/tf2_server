#!/bin/bash

function set_config_file() {
    local config_file="$1"
    local default_config="$2"
    local config_dest="$3"

    if [ -f "$PWD/tf2/tf/cfg/$config_file" ]; then
        # This container was given the name of an existing config type.
        ln -sf "$PWD/tf2/tf/cfg/$config_file" "$PWD/tf2/tf/cfg/$config_dest"
    else
        # No matches were found, use default.cfg
        ln -sf "$PWD/configs/$default_config" "$PWD/tf2/tf/cfg/$config_dest"
    fi
}

# Updates the server
./steamcmd.sh +runscript tf2_ds.txt

if [ -z "$TF2_MODE" ]; then
   echo 'No TF2_MODE environment variable set, using "default"'
   TF2_MODE=default
fi

server_config_file="$(basename $TF2_MODE).cfg"
map_config_file="mapcycle_$(basename $TF2_MODE).txt"

for cfg in $(find $PWD/configs/*); do
    ln -sf $cfg ./tf2/tf/cfg
done

for map in $(find $PWD/maps/*); do
    ln -sf $map ./tf2/tf/maps
done

set_config_file "$server_config_file" default.cfg server.cfg
set_config_file "$map_config_file" mapcycle_default.txt mapcycle.txt

for addon in $(find $PWD/addons/*.tar.gz); do
    tar -xf $addon -C ./tf2/tf
done

# Runs the server
./tf2/srcds_run -console -game tf +randommap +maxplayers 24
