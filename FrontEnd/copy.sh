#!/bin/bash
echo "Only usable for Andres enviroment to sync repos, in the meantime that we get a definitive repo"
scp 192.168.0.4:~/intersystem/* .
scp -r 192.168.0.4:~/intersystem/assets/ .
scp -r 192.168.0.4:~/intersystem/src/ .
