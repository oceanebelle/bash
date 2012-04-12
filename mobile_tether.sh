#!/bin/bash

echo "Please make sure that you have your mobile phone attached to the PC via USB"
echo "and Start Proxoid app."

sleep 5

cd ~/Android/platform-tools
./adb forward tcp:8080 tcp:8080

firefox&
