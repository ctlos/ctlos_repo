# Ctlos repo

```bash
#!/bin/bash
# https://gitlab.com/archlinux_build/tallow/-/blob/master/.gitlab-ci.yml

rm -rf *.sig
# find './' -maxdepth 1 -type f -regex '.*\.\(zst\|xz\)' -exec gpg -b '{}' \;
# find './' -maxdepth 1 -type f -name '*.pkg.tar.zst' -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;
repo-add -n -R ctlos-aur.db.tar.zst *.pkg.tar.zst
rm -rf ctlos-aur.{db,files}
cp -f ctlos-aur.db.tar.zst ctlos-aur.db

exit 0
```

## Сборка пакетов

Выполняется в директории с PKGBUILD в chroot.

```bash
./buildpkg.sh
```

## Синхронизация репозиториев

```bash
./update.sh -all
# или
./buildpkg.sh -sync
```
