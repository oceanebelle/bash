#!/bin/bash -e

#Start SSH
ssh -L 2001:localhost:8888 -Nf myserver.com &

#Start Firefox using the profile SSHProxy in the background
firefox -p "SSHProxy" &

#Kill the SSH port 2001 when Firefox stops
#When the previous command exits then the trap command executes (in this ase killing the port forwarding command)
trap "ps aux | grep ssh | grep 2001 | awk '{print \$2}' | xargs kill" EXIT SIGINT SIGTERM

#Don't kill this session until trap completes
wait
