#!/bin/bash

function set_config_file() {
    local config_file="$1"
    local default_config="$2"
    local config_dest="$3"

    if [ -f "./configs/$config_file" ]; then
        # A custom config was found under configs.
        cp "./configs/$config_file" "./tf2/tf/cfg/$config_dest"
    elif [ -f "./tf2/tf/cfg/$config_file" ]; then
        # This container was given the name of a built-in config type.
        cp "./tf2/tf/cfg/$config_file" "./tf2/tf/cfg/$config_dest"
    else
        # No matches were found, use default.cfg
        cp "./configs/$default_config" "./tf2/tf/cfg/$config_dest"
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

set_config_file "$server_config_file" default.cfg server.cfg
set_config_file "$map_config_file" mapcycle_default.txt mapcycle.txt

cp ./maps/* ./tf2/tf/maps

# Runs the server
./tf2/srcds_run -console -game tf +randommap +maxplayers 24
