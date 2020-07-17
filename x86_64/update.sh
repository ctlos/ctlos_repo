#!/bin/bash

rm ctlos_repo*

# repo-add -s -v -n -R ctlos_repo.db.tar.gz *.pkg.tar.xz
repo-add -n -R ctlos_repo.db.tar.gz *.pkg.tar.{xz,zst}

# rm ctlos_repo.db
cp -f ctlos_repo.db.tar.gz ctlos_repo.db
##optional-remove for old repo.db##
# rm *gz.old{,.sig}

rsync -auvC -L -P --delete-excluded --delete /media/files/github/ctlos/ctlos_repo/x86_64 creio@storage.osdn.net:/storage/groups/c/ct/ctlos/ctlos_repo/

echo "Repo Up"
