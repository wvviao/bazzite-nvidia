#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

# https://github.com/travier/fedora-sysexts/blob/main/google-chrome/Containerfile
# https://github.com/bsherman/bos/blob/927bfe310932f42c39685ce19639ec59f36f8d0f/desktop-1password.sh

mv /opt{,.bak} && mkdir /opt
dnf5 install -y --enablerepo="google-chrome" google-chrome-stable
mv /opt/google/chrome /usr/lib/google-chrome
ln -sf /usr/lib/google-chrome/google-chrome /usr/bin/google-chrome-stable
mkdir -p usr/share/icons/hicolor/{16x16/apps,24x24/apps,32x32/apps,48x48/apps,64x64/apps,128x128/apps,256x256/apps}
for i in "16" "24" "32" "48" "64" "128" "256"; do
    ln -sf /usr/lib/google-chrome/product_logo_$i.png /usr/share/icons/hicolor/${i}x${i}/apps/google-chrome.png
done
rm -rf /etc/cron.daily
rmdir /opt/{google,}
mv /opt{.bak,}
