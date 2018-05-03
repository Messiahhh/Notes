#!/usr/bin/env zsh

git add .
git commit -m 'update'
git push

./deploy.sh
