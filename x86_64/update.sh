#!/bin/bash

repo-add ctlos_repo.db.tar.gz *.pkg.tar.xz
sleep 2
rm ctlos_repo.db
sleep 2
cp ctlos_repo.db.tar.gz ctlos_repo.db

##optional-remove for old repo.db##
rm *gz.old

echo "Repo Updated!!"