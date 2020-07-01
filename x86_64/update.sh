#!/bin/bash

rm ctlos_repo*

# repo-add -s -n -R ctlos_repo.db.tar.xz *.pkg.tar.xz
repo-add -n -R ctlos_repo.db.tar.xz *.pkg.tar.xz
repo-add -n -R ctlos_repo.db.tar.xz *.pkg.tar.zst

rm ctlos_repo.db
cp -f ctlos_repo.db.tar.xz ctlos_repo.db
rm *xz.old{,.sig}

echo "Repo Up"
