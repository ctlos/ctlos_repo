#!/bin/bash

# GPG_PASS to ~/.env

repo=/media/files/github/ctlos/ctlos_repo/x86_64
dir_repo=/media/files/github/ctlos/ctlos_repo
PWD_DIR=$PWD

## sync repo
if [[ "$1" = "-sync" && -d "$dir_repo" && -f $dir_repo/update.sh ]]; then
  cd $dir_repo
  sh update.sh -all
  cd $PWD_DIR
  echo "sync done!"; exit 1
fi
## repo status
if [[ "$1" = "-status" && -d "$dir_repo" ]]; then
  cd $dir_repo
  git status
  exit 1
fi

if [[ ! $(pacman -Q | grep clean-chroot-manager) ]]; then
  echo "ERROR. no install clean-chroot-manager"; exit 1
fi

if [[ ! -f $PWD_DIR/PKGBUILD ]]; then
  echo "ERROR. no PKGBUILD file"; exit 1
fi

if [[ -f $HOME/.config/clean-chroot-manager.conf ]]; then
  mv -f $HOME/.config/clean-chroot-manager.{conf,conf.bak}
  cp $dir_repo/clean-chroot-manager.conf $HOME/.config/clean-chroot-manager.conf
fi

mkdir $PWD_DIR/build
cp -r $PWD_DIR/* $PWD_DIR/build
cd $PWD_DIR/build
sudo ccm S
cd $PWD_DIR/build

if [[ $(ls | grep *.pkg*) && ! $(ls | grep *.sign) ]]; then
  find './' -maxdepth 1 -type f -name '*.pkg.tar.zst' -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;
  cp -rfv *.pkg* $repo
  cd $PWD_DIR
  rm -rf $PWD_DIR/build
  echo 'rm build dir'
  makepkg --printsrcinfo > $PWD_DIR/.SRCINFO
fi

if [[ -f $HOME/.config/clean-chroot-manager.conf.bak ]]; then
  mv -f $HOME/.config/clean-chroot-manager.{conf.bak,conf}
fi
