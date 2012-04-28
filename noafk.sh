#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Bugs/Notes: 
#   xdotool needs to be installed. 
#   Minecraft window needs to be focused.

verbose=
inwater=
while getopts 'wv' FLAG        #Grab arguments
do
   case $FLAG in
   v)   verbose=1;;
   w)   inwater=1;;
   ?)   echo "Usage: $0 [-w] [-v]"
        exit 2;
   esac
done

minecraftwindowid=$(xwininfo -name "Minecraft" | grep "Window id" | awk '{print $4}') 
echo "Switching to Minecraft"
xdotool windowactivate $minecraftwindowid
sleep 1s
xdotool key Escape
sleep 1s

if [ "$inwater" ]; then
   if [ "$verbose" ]; then
      echo "Water mode engaged"
   fi
   while [ 1 ]
      do          
          xdotool keydown w  #Walk upstream
          sleep 1.5s
          xdotool keyup w    #Flow Downstream
          sleep 30s
      done
else 
   if [ "$verbose" ]; then
      echo "Normal Mode engaged"
   fi
   while [ 1 ]
      do
         xdotool keydown w  #Walk forward
         sleep .3s          
         xdotool keyup w     
         xdotool keydown s  #Walk backward
         sleep .3s
         xdotool keyup s
         sleep 30s
      done
fi

