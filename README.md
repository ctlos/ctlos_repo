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
./buildpkg.sh deploy
```

Если вы не используете утилиты типа rsnapshot, btrbk или не храните дублирующиеся бинарники через ln, флаг -H обычно не нужен.

-rlptH безопасен для пользовательских данных. Если жёсткие ссылки не критичны → уберите -H для прироста скорости. Если делаете полный бэкап системы → замените на -a (или -aAX для расширенных атрибутов).


```bash
# 1. Универсальный (домашние данные, код, медиа)
rsync -rlpt

# 2. Полный системный бэкап (от root)
rsync -aAXH

# 3. Сеть + прогресс + сжатие
rsync -rlptvz --info=progress2

# 4. Если нужны жёсткие ссылки, но хотите избежать оверхеда
rsync -rlptH --hard-links  # то же самое, но явно
```
