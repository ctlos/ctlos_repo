#!/bin/bash

# GPG_PASS to ~/.env

repo=/media/files/github/ctlos/ctlos_repo/x86_64
dir_repo=/media/files/github/ctlos/ctlos_repo

## sync repo
if [[ "$1" = "-sync" && -d "$dir_repo" && -f $dir_repo/update.sh ]]; then
  cd $dir_repo
  sh update.sh -all
  cd $PWD
  echo "sync done!"; exit 1
fi

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
  find './' -maxdepth 1 -type f -name '*.pkg.tar.zst' -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;
  cp -rfv *.pkg* $repo
  cd ..
  rm -rf $PWD/build
fi

if [[ -f $HOME/.config/clean-chroot-manager.conf.bak ]]; then
  mv -f $HOME/.config/clean-chroot-manager.{conf.bak,conf}
fi