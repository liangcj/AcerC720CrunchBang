#!/bin/bash

currentbright=$(cat /sys/class/backlight/intel_backlight/brightness)

if [ $1 == "inc" ]; then
  if [ "$currentbright" -gt 468 ]; then
    echo 936 | sudo tee /sys/class/backlight/intel_backlight/brightness
    exit
  fi
  if [ "$currentbright" -eq 0 ]; then
    echo 1 | sudo tee /sys/class/backlight/intel_backlight/brightness
    exit
  fi
  echo $(($currentbright*2)) | sudo tee /sys/class/backlight/intel_backlight/brightness
  exit
fi

if [ $1 == "dec" ]; then
  echo $(($currentbright/2)) | sudo tee /sys/class/backlight/intel_backlight/brightness
  exit
fi
