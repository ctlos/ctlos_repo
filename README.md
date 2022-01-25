# Ctlos repo

```bash
#!/bin/bash
# https://gitlab.com/archlinux_build/tallow/-/blob/master/.gitlab-ci.yml

rm -rf *.sig
# find './' -maxdepth 1 -type f -regex '.*\.\(zst\|xz\)' -exec gpg -b '{}' \;
# find './' -type f -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;
repo-add -n -R aur-package-manager.db.tar.zst *.pkg.tar{.xz,.zst}
rm -rf aur-package-manager.db
cp -f aur-package-manager.db.tar.zst aur-package-manager.db

exit 0
```
