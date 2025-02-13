#!/bin/bash

repo=/media/files/github/ctlos/ctlos_repo/x86_64
dir_repo=/media/files/github/ctlos/ctlos_repo

if [[ ! $(pacman -Q | grep clean-chroot-manager) ]]; then
  echo "ERROR. no install clean-chroot-manager"; exit 1
fi

if [[ ! -f $PWD/PKGBUILD ]]; then
  echo "ERROR. no PKGBUILD file"; exit 1
fi

if [[ -f $HOME/.config/clean-chroot-manager.conf ]]; then
  mv -f $HOME/.config/clean-chroot-manager.{conf,conf.bak}
  cp $dir_repo/clean-chroot-manager.conf $HOME/.config/clean-chroot-manager.conf
fi

mkdir $PWD/build
cp -r $PWD/* $PWD/build
cd $PWD/build
sudo ccm S

if [[ $(ls | grep *.pkg*) && ! $(ls | grep *.sign) ]]; then
  gpg --detach-sign *.pkg*
  cp -rfv *.pkg* $repo
  cd ..
  rm -rf $PWD/build
fi

if [[ -f $HOME/.config/clean-chroot-manager.conf.bak ]]; then
  mv -f $HOME/.config/clean-chroot-manager.{conf.bak,conf}
fi