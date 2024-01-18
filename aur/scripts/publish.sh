#!/bin/bash

set -e  # Exit on error

VERSION="$1"
REMOTE="$2"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone $REMOTE

cd cmonk

rm -rf PKGBUILD
rm -rf .SRCINFO
ls -la

cp  ../aur/PKGBUILD .
cp  ../aur/.SRCINFO .
ls -la

git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_USER"

git config --get user.email
git config --get user.name

git add PKGBUILD .SRCINFO

git status

# git commit -m "Chipmunk release $VERSION"
# git push origin master

