#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

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

/ctx/test.sh

copr_repos=(
    zeno/scrcpy
    ublue-os/packages
)

for repo in "${copr_repos[@]}"; do
    dnf5 -y copr enable ${repo}
done

# Layered Applications
LAYERED_PACKAGES=(
    scrcpy
    uupd
)

dnf5 install --setopt=install_weak_deps=False -y "${LAYERED_PACKAGES[@]}"

systemctl enable uupd.timer

echo "::group:: ===Install packages==="
# Sysexts
# https://github.com/m2Giles/m2os/blob/0f1d38d1b0374d9a2e638cf79229f544f8a12c18/desktop-packages.sh#L91
mkdir -p /etc/sysupdate.d/
tee /usr/lib/tmpfiles.d/my-bazzite-nvidia-sysext.conf <<EOF
d /var/lib/extensions/ 0755 root root - -
d /var/lib/extensions.d/ 0755 root root - -
EOF

SYSEXTS=(
    google-chrome
    vscode
    firefox
)

for SYSEXT in "${SYSEXTS[@]}"; do
    tee /etc/sysupdate.d/"$SYSEXT".conf <<EOF
[Transfer]
Verify=false

[Source]
Type=url-file
Path=https://github.com/travier/fedora-sysexts/releases/download/fedora-kinoite-41/
MatchPattern=$SYSEXT-@v-%a.raw

[Target]
InstancesMax=2
Type=regular-file
Path=/var/lib/extensions.d/
MatchPattern=$SYSEXT-@v-%a.raw
CurrentSymlink=/var/lib/extensions/$SYSEXT.raw
EOF
done

/usr/lib/systemd/systemd-sysupdate update
systemctl restart systemd-sysext.service

echo "::endgroup::"

echo "::group:: ===Cleanup==="
repos=(
    google-chrome
    vscode
)

for repo in "${repos[@]}"; do
    if [[ -f "/etc/yum.repos.d/{$repo}.repo" ]]; then
        sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/{$repo}.repo"
    fi
done

dnf5 clean all
ostree container commit
echo "::endgroup::"
