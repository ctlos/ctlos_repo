#!/bin/bash

rm ctlos_repo*

repo-add -n -R ctlos_repo.db.tar.xz *.pkg.tar.xz
repo-add -n -R ctlos_repo.db.tar.xz *.pkg.tar.zst
cp -f ctlos_repo.db.tar.gz ctlos_repo.db
# rm *gz.old{,.sig}
echo "Repo Up"
