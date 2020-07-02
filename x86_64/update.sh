#!/bin/bash

rm ctlos_repo*

# repo-add -s -n -R ctlos_repo.db.tar.gz *.pkg.tar.gz
repo-add -s -n -R ctlos_repo.db.tar.gz *.pkg.tar.gz
repo-add -s -n -R ctlos_repo.db.tar.gz *.pkg.tar.zst

cp -f ctlos_repo.db.tar.gz ctlos_repo.db
# rm *gz.old{,.sig}

echo "Repo Up"
