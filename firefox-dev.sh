#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

# https://github.com/the4runner/firefox-dev

mv /opt{,.bak} && mkdir /opt
dnf5 install --setopt=install_weak_deps=False -y firefox-dev
mv /opt/firefox-dev /usr/lib/firefox-dev
mkdir -p /usr/share/icons/hicolor/{16x16/apps,32x32/apps,48x48/apps,64x64/apps,128x128/apps}
for i in "16" "32" "48" "64" "128"; do
    ln -sf /usr/lib/firefox-dev/browser/chrome/icons/default/default$i.png /usr/share/icons/hicolor/${i}x${i}/apps/firefox-developer-edition.png
done
sed -i 's@/opt/firefox-dev/firefox@/usr/lib/firefox-dev/firefox@g' "/usr/bin/firefox-aurora"
mv /opt{.bak,}
