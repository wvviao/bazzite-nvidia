#!/bin/bash
set -ouex pipefail

### Install packages
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1
# this installs a package from fedora repos
# dnf install -y tmux
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

echo "::group:: ===Install packages==="
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

# Vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc' | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 install -y code
echo "::endgroup::"

# Scrcpy
dnf5 -y copr enable zeno/scrcpy
dnf5 install -y scrcpy

echo "::group:: ===Cleanup==="
repos=(
    google-chrome
    vscode
    scrcpy
)

for repo in "${repos[@]}"; do
    if [[ -f "/etc/yum.repos.d/{$repo}.repo" ]]; then
        sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/{$repo}.repo"
    fi
done

dnf5 clean all
ostree container commit
echo "::endgroup::"
