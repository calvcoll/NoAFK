#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Bugs/Notes: 
#   xdotool needs to be installed. 
#   Minecraft window needs to be focused.
#   Assumes you are standing in a backwards flowing pool of water.

sleep 5 
#Wait for you to switch the window

while [ 1 ]
   do
         xdotool keydown w   #Start walking forward
         sleep 3s            #Wait until you walk forward enough
         xdotool keyup w     #Let the water take you back
         sleep 30s           #Wait until the next cycle
   done 
