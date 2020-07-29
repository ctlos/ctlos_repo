#!/bin/bash

local_repo=/media/files/github/ctlos/ctlos_repo/
dest_osdn=creio@storage.osdn.net:/storage/groups/c/ct/ctlos/ctlos_repo/
dest_keybase=/run/user/1001/keybase/kbfs/public/cvc/ctlos_repo/

if [ "$1" = "-add" ]; then
  # repo-add -s -v -n -R ctlos_repo.db.tar.gz *.pkg.tar.xz
  repo-add -n -R ctlos_repo.db.tar.gz *.pkg.tar.{xz,zst}
  rm ctlos_repo.db
  cp -f ctlos_repo.db.tar.gz ctlos_repo.db
  ##optional-remove for old repo.db##
  # rm *gz.old{,.sig}
echo "Repo Up"
elif [ "$1" = "-clean" ]; then
  rm ctlos_repo*
echo "Repo clean"
elif [ "$1" = "-o" ]; then
  rsync -auvCLP --delete-excluded --delete "$local_repo"x86_64 "$dest_osdn"
echo "rsync osdn repo"
elif [ "$1" = "-k" ]; then
  systemctl start --user kbfs
  rsync -auvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo" "$dest_keybase"
echo "rsync keybase repo"
elif [ "$1" = "-all" ]; then
  rsync -auvCLP --delete-excluded --delete "$local_repo"x86_64 "$dest_osdn"
  systemctl start --user kbfs && \
  rsync -auvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo" "$dest_keybase"
echo "rsync all repo"
else
  echo "No rsync repo"
fi

