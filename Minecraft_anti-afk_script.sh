#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Busg/Notes: 
#   xdotool needs to be installed. 
#   Minecraft window needs to be focused.
#   Assumes you are standing in a backwards flowing pool of water.

sleep 5
while [ 1 ]
   do
         xdotool keydown w
         sleep 3s
         xdotool keyup w
         sleep 30s
   done 
