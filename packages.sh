#!/usr/bin/bash
set ${SET_X:+-x} -eou pipefail

# Google-chrome
mv /opt{,.bak}
mkdir /opt
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
dnf5 clean all

# Vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc' | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 install -y vscode
