#!/bin/bash
./format.sh
git add .
git commit -m "$1"
git pull
git push
