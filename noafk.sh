#!/bin/bash

#   auxiliary-character's Minecraft No-afk script

# Bugs/Notes: 
#   xdotool needs to be installed.
#   Wierd stdio and stderror output.

mode="Normal"
interval="60s"
verbose=

#Grab arguments
while getopts 'bwvt:i:' FLAG
do
   case $FLAG in
   v)   verbose=1;;
   w)   mode="water";;
   t)   mode="text"
        textval="$OPTARG";;
   b)   mode="button";;
   i)   interval="$OPTARG";;
   ?)   echo "Usage: $0 [-w | -b | -t text] [-v] [-i interval]"
        exit 2;
   esac
done

#Checks for xdotool, if it isn't installed the program warns user and closes
if [ ! -f "/usr/bin/xdotool" ]; then
   #Checks for the program using hash (if exits successfully - command exists)
   if hash apt-get 2>/dev/null; then
       echo "xdotool is not installed!"
       echo "Use '[sudo] apt-get install xdotool' to install!"
   elif hash pacman 2>/dev/null; then
       echo "xdotool is not installed!"
       echo "Use '[sudo] pacman -S xdotool' to install!"
   elif hash yum 2>/dev/null; then
       echo "xdotool is not installed!"       
       echo "Use '[sudo] yum install xdotool' to install!"
   elif [ $(uname -s) == Darwin ]; then
       echo "We have detected you're using a Mac!"
       echo "You need a Linux computer to use this :("
   else
       echo "We couldn't detect your package manager. :("
       echo "xdotool is not installed!"
   fi
   exit 1
fi

#Find the Minecraft Window and switch to it
minecraftwindowid=$(xwininfo -name "Minecraft" | grep "Window id" | awk '{print $4}') 
#If the Minecraft Window is not open, the script will close
case "${#minecraftwindowid}" in
 0 ) echo "Minecraft not open!"; exit 1;;
esac
if [ "$verbose" ]; then
   echo "Switching to Minecraft"
fi
eval $(xdotool windowactivate $minecraftwindowid)
sleep .5s
xdotool key Escape
sleep .5s

#Text Entry mode
if [[ "$mode" == "text" ]]; then
   if [ "$verbose" ]; then
      echo "Text entry mode engaged."
   fi
   while [ 1 ]
      do
         #Open chat
         xdotool key t
         sleep .1s
         #Type payload
         xdotool type "$textval"
         #Exit Chat
         xdotool key Return
         sleep $interval
      done

#Button mode
elif [[ "$mode" == "button" ]]; then
   if [ "$verbose" ]; then
      echo "Button mode engaged"
   fi
   while [ 1 ]
      do
         xdotool click 3
         sleep .1
         xdotool click 3
         sleep $interval
      done

#Water Mode
elif [[ "$mode" == "water" ]]; then
   if [ "$verbose" ]; then
      echo "Water mode engaged."
   fi
   while [ 1 ]
      do
          #Walk Upstream
          xdotool keydown w
          sleep 1.5s
          #Flow Downstream
          xdotool keyup w
          sleep $interval
      done

#Normal mode
else
   if [ "$verbose" ]; then
      echo "Normal Mode engaged."
   fi
   while [ 1 ]
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
      done
fi
echo "Done."

