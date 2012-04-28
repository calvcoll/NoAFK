#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Bugs/Notes: 
#   xdotool needs to be installed.
#   Wierd stdio and stderror output.

verbose=
inwater=
text=
interval="60s"

#Grab arguments
while getopts 'wvt:i:' FLAG
do
   case $FLAG in
   v)   verbose=1;;
   w)   inwater=1;;
   t)   text=1
        textval="$OPTARG";;
   i)   interval="$OPTARG";;
   ?)   echo "Usage: $0 [-w | -t text] [-v] [-i interval]"
        exit 2;
   esac
done

#A bit of error handeling
if [ "$inwater" ] && [ "$text" ]; then
   echo "You can't use both of those flags, silly."
   exit 2
fi

#Find the Minecraft Window and switch to it
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

#Text Entry mode
if [ "$text" ]; then
   if [ "$verbose" ]; then
      echo "Text entry mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
         #Open chat
         xdotool key T
         sleep .1s
         #Type payload
         xdotool type "$textval"
         #Exit Chat
         xdotool key Return
         sleep $interval
         eval $(xdotool getmouselocation --shell)
      done

#Water Mode
elif [ "$inwater" ]; then
   if [ "$verbose" ]; then
      echo "Water mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
          #Walk Upstream
          xdotool keydown W
          sleep 1.5s
          #Flow Downstream
          xdotool keyup W
          sleep $interval
          eval $(xdotool getmouselocation --shell)
      done

#Normal mode
else
   if [ "$verbose" ]; then
      echo "Normal Mode engaged."
   fi
   while [[ "$WINDOW" == "$minecraftwindow" ]]
      do
         #Walk Forward
         xdotool keydown w
         sleep .3s          
         xdotool keyup w
         #Walk Backward   
         xdotool keydown s
         sleep .3s
         xdotool keyup s
         sleep $interval
         eval $(xdotool getmouselocation --shell)
      done
fi
echo "Done."

