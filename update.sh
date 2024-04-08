#!/bin/bash

# rsync -cauv --delete --info=stats2 --exclude={"caur.files","*.files.tar*","caur.db","*.db.tar*"} /var/cache/pacman/caur/ /home/cretm/app/dev.ctlos.ru/ctlos-aur

# find './' -maxdepth 1 -type f -regex '.*\.\(zst\|xz\)' -exec gpg -b '{}' \;
# find './' -type f -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;

# apindex .
# ./update.sh -add
# systemctl --user start kbfs
# ./update.sh -all
# surge --project ../ --domain https://ctlos.surge.sh

# https://osdn.net/projects/ctlos/storage/ctlos_repo/x86_64/
# https://github.com/ctlos/ctlos_repo/tree/master/x86_64
# https://cvc.keybase.pub/ctlos_repo

local_repo=${PWD}
arch=x86_64
echo $local_repo
repo_ctlos=cretm@cloud.ctlos.ru:/home/cretm/app/cloud.ctlos.ru/ctlos_repo/
repo_osdn=creio@storage.osdn.net:/storage/groups/c/ct/ctlos/ctlos_repo/
repo_keybase=/run/user/1000/keybase/kbfs/public/cvc/ctlos_repo/

aur_ctlos=/media/files/github/ctlos/ctlos-aur/x86_64/
aur_keybase=/run/user/1000/keybase/kbfs/public/cvc/ctlos-aur/

srht_repo=/media/files/srht/ctlos/ctlos_repo/

_git_up() {
  git add --all
  msg="$(date +%d.%m.%Y) Update"
  git commit -a -m "$msg"
  git push
}

_keybase() {
  srv_keybase="$(systemctl status --user kbfs | grep -i running 2>/dev/null || echo '')"
  if [[ "$srv_keybase" ]]; then
    rsync -cauvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo/$arch/" "$repo_keybase"
  else
    systemctl start --user kbfs
    sleep 4
    echo "systemctl start --user kbfs done"
    rsync -cauvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo/$arch/" "$repo_keybase"
  fi
  # if read -re -p "stop keybase user service? [Y/n]: " ans && [[ $ans == 'n' || $ans == 'N' ]]; then
  #   echo "skip stop kbfs"
  # else
  #   systemctl stop --user kbfs
  #   echo "stop kbfs done"
  # fi
  echo "rsync keybase repo"
}

_srht() {
  if [[ -d "$srht_repo" ]]; then
    rsync -avrCLP --delete --exclude={"build",".git*"} "$local_repo" "$srht_repo"
    cd $srht_repo
    _git_up
    cd $local_repo
  fi
}

if [ "$1" = "-add" ]; then
  cd $local_repo/$arch
  # repo-add -s -v -n -R ctlos_repo.db.tar.zst *.pkg.tar.xz
  # repo-add -n -R ctlos_repo.db.tar.zst *.pkg.tar.{xz,zst}
  repo-add -n -R -q ctlos_repo.db.tar.zst *.pkg.tar.zst 2>/dev/null;
  rm ctlos_repo.{db,files}
  cp -f ctlos_repo.db.tar.zst ctlos_repo.db
  cp -f ctlos_repo.files.tar.zst ctlos_repo.files
  ##optional-remove for old repo.db##
  # rm *gz.old{,.sig}
echo "Repo Up"
elif [ "$1" = "-clean" ]; then
  rm ctlos_repo*
  echo "Repo clean"
elif [ "$1" = "-o" ]; then
  # rsync -cauvCLP --delete-excluded --delete "$local_repo/$arch/" "$repo_osdn"
  echo "rsync osdn repo"
elif [ "$1" = "-sync" ]; then
  _keybase
  _git_up
  _srht
  echo "rsync all repo"
elif [ "$1" = "-k" ]; then
  _keybase
elif [ "$1" = "-all" ]; then
  cd $local_repo/$arch
  repo-add -n -R -q ctlos_repo.db.tar.zst *.pkg.tar.zst
  rm ctlos_repo.{db,files}
  cp -f ctlos_repo.db.tar.zst ctlos_repo.db
  cp -f ctlos_repo.files.tar.zst ctlos_repo.files
  _keybase
  _git_up
  _srht
  echo "add pkg, rsync all repo"
fi

## sync ctlos-aur repo
if [[ "$1" = "-aur" && -d "$aur_ctlos" ]]; then
  srv_keybase="$(systemctl status --user kbfs | grep -i running 2>/dev/null || echo '')"
  if [[ "$srv_keybase" ]]; then
    rsync -cauvCLP --delete-excluded --delete "$aur_ctlos" "$aur_keybase"
  fi
  echo "sync aur"
fi
