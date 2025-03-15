#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

echo "::group:: ===Copr Packages==="
/ctx/copr-packages.sh
echo "::endgroup::"

echo "::group:: ===Desktop Packages==="
/ctx/desktop-packages.sh
echo "::endgroup::"

echo "::group:: ===Cleanup==="
/ctx/cleanup.sh
echo "::endgroup::"
