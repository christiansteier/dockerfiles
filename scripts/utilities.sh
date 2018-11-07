#!/bin/bash
set -e
source /scripts/buildconfig

echo -e "\n[i] Install often used tools\n"
$minimal_apt_get_install less bzip2 vim-tiny psmisc curl git-core rsync unzip
ln -s /usr/bin/vim.tiny /usr/bin/vim

exit 0
