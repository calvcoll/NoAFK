#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Bugs/Notes: 
#   xdotool needs to be installed. 
#   Minecraft window needs to be focused.

verbose=
inwater=
text=
while getopts 'wvt:' FLAG        #Grab arguments
do
   case $FLAG in
   v)   verbose=1;;
   w)   inwater=1;;
   t)   text=1
        textval="$OPTARG";;
   ?)   echo "Usage: $0 [-w] [-v]"
        exit 2;
   esac
done
if [ "$inwater" ] && [ "$text" ]; then
   echo "You can't use both of those flags, silly."
   exit 2
fi
  
minecraftwindowid=$(xwininfo -name "Minecraft" | grep "Window id" | awk '{print $4}') 
if [ "$verbose" ]; then
   echo "Switching to Minecraft"
fi

eval $(xdotool windowactivate $minecraftwindowid)
eval $(xdotool getmouselocation --shell)
minecraftwindow=$WINDOW
sleep .5s
xdotool key Escape
sleep .5s

if [ "$text" ]; then
   if [ "$verbose" ]; then
      echo "Text entry mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
         echo "debug"
         xdotool key T
         sleep .1s
         xdotool type "$textval"
         xdotool key Return
         sleep 30s
         eval $(xdotool getmouselocation --shell)
      done
elif [ "$inwater" ]; then
   if [ "$verbose" ]; then
      echo "Water mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
          xdotool keydown w  #Walk upstream
          sleep 1.5s
          xdotool keyup w    #Flow Downstream
          sleep 30s
          eval $(xdotool getmouselocation --shell)
      done
else
   if [ "$verbose" ]; then
      echo "Normal Mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
         xdotool keydown w  #Walk forward
         sleep .3s          
         xdotool keyup w     
         xdotool keydown s  #Walk backward
         sleep .3s
         xdotool keyup s
         sleep 30s
         eval $(xdotool getmouselocation --shell)
      done
fi
