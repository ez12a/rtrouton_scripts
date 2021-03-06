#!/bin/bash

# fork of Tim Sutton's osx-vm-template script:
# https://github.com/timsutton/osx-vm-templates/blob/master/scripts/puppet.sh

# Install the latest VMware Tools using AutoPkg recipes
# https://github.com/autopkg/autopkg
#
# Note: Either Xcode.app or the Xcode command line tools
# must be installed and licensed before running this script.
#

# Download AutoPkg from GitHub using git

AUTOPKG_DIR=$(mktemp -d /tmp/autopkg-XXXX)
git clone --single-branch --branch AutoPkg_1.x https://github.com/autopkg/autopkg "$AUTOPKG_DIR"
AUTOPKG="$AUTOPKG_DIR/Code/autopkg"

# Add the recipes repo containing the
# VMwareTools .download and .pkg recipes

"${AUTOPKG}" repo-add rtrouton-recipes

# Redirect the AutoPkg cache to a temp location

defaults write com.github.autopkg CACHE_DIR -string "$(mktemp -d /tmp/autopkg-cache-XXX)"

# Store the location of the AutoPkg cache

cache_path=$(defaults read com.github.autopkg CACHE_DIR)

# Downloads the current release version of VMware Tools for OS X
# and builds an installer package.

"${AUTOPKG}" run VMwareTools.pkg

# Install VMware Tools using the AutoPkg-generated installer package

pkg_path="$(/usr/bin/find ${cache_path} -maxdepth 2 \( -iname \VMware*\.pkg -o -iname \VMware*\.mpkg \))"
/usr/sbin/installer -pkg "${pkg_path}" -target /

# Clean up

/bin/rm -rf "${AUTOPKG_DIR}"

# If this script is run on a logged-out machine,
# a /var/root/Library/AutoPkg directory will be
# created. As part of the clean-up process, this
# folder will be removed.

if [[ -d "/var/root/Library/AutoPkg" ]]; then
   /bin/rm -rf "/var/root/Library/AutoPkg"
fi

# If this script is run by while logged-in, an
# AutoPkg directory will be created in the logged-in
# user's home folder. As part of the clean-up process, this
# folder will be removed, but only if the AutoPkg directory
# is owned by root. If the AutoPkg directory is not owned by
# root, it will be left alone as it may contain previously-created
# AutoPkg downloads and cached recipes.

if [[ "echo $HOME" != "" ]] && [[ -d "$HOME/Library/AutoPkg" ]]; then
   OWNERSHIP_CHECK=`/usr/bin/stat -F "$HOME/Library/AutoPkg" | awk '{ print $3 }'`
     if [[ "${OWNERSHIP_CHECK}" = "root" ]]; then
        /bin/rm -rf "$HOME/Library/AutoPkg"
     fi
fi