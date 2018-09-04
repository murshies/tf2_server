#!/bin/bash

# Updates the server
./steamcmd.sh +runscript tf2_ds.txt

# Runs the server
./tf2/srcds_run -console -game tf +randommap +maxplayers 24
