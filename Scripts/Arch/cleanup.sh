#!/usr/bin/env bash

# Fedora RootFS:
# https://artifacts.dev.testing-farm.io/4aa345e8-5263-44db-b635-37e476c11c77/work-build-fex-rootfs8nc5v0ub/tmt/plans/asahi/build-fex-rootfs/execute/data/guest/default-0/tmt/tests/build-image-1/data/Fedora-FEX-RootFS-Rawhide.20241209.2006.x86_64.erofs.xz
# Fedora cleanup script:
# https://pagure.io/fedora-kiwi-descriptions/blob/rawhide/f/config.sh#_312
# https://pagure.io/fedora-kiwi-descriptions/blob/rawhide/f/fex-excludes.yaml

# mkfs.erofs -x-1 -zlz4hc,12 default.erofs wip/

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#ROOTFSPATH="$SCRIPTPATH/RootFS"
BASEPATH=$SCRIPTPATH

rm -rf "$BASEPATH/boot"
rm -rf "$BASEPATH/dev"
rm -rf "$BASEPATH/home"
rm -rf "$BASEPATH/media"
rm -rf "$BASEPATH/mnt"
rm -rf "$BASEPATH/opt"
rm -rf "$BASEPATH/proc"
rm -rf "$BASEPATH/root"
rm -rf "$BASEPATH/run"
rm -rf "$BASEPATH/srv"
rm -rf "$BASEPATH/sys"
rm -rf "$BASEPATH/tmp"
rm -rf "$BASEPATH/var"

# rm everything in /usr/share except wine and mesa related stuff
find "$BASEPATH"/usr/share -mindepth 1 -maxdepth 1 \
    \! -name wine -a \
    \! -name mesa-demos -a \
    \! -name drirc.d -a \
    \! -name glvnd -a \
    \! -name vulkan -a \
    \! -name licenses \
    -exec rm -rf {} \;


# rm everything in /etc except /etc/alternatives and ld stuff
find "$BASEPATH"/etc -mindepth 1 -maxdepth 1 \
    \! -name 'ld.so*' -a \
    \! -name OpenCL \
    -exec rm -rf {} \;

# rm non-libs in lib/lib64
rm -rf "$BASEPATH"/usr/lib/{locale,tmpfiles.d,systemd,modprobe.d,kbd,cmake}
rm -rf "$BASEPATH"/usr/lib/python*

# rm misc stuff
rm -rf $BASEPATH/usr/{include,games,local,src,tmp}
rm -f $BASEPATH/version
rm -f $BASEPATH/pkglist.x86_64.txt

# Finally, remove most binaries except Wine stuff, Mesa stuff, the shell,
# path-related stuff, and system info tools.
find "$BASEPATH/usr/bin" -mindepth 1 -maxdepth 1 \
    \! -name 'cat' -a \
    \! -name 'strace' -a \
    \! -name 'wine*' -a \
    \! -name 'mango*' -a \
    \! -name notepad -a \
    \! -name 'msi*' -a \
    \! -name regedit -a \
    \! -name regsvr32 -a \
    \! -name 'vulkan*' -a \
    \! -name 'vk*' -a \
    \! -name clinfo -a \
    \! -name 'eglinfo*' -a \
    \! -name 'glxinfo*' -a \
    \! -name 'egltri_*' -a \
    \! -name es2_info -a \
    \! -name 'es2gears_*' -a \
    \! -name es2tri -a \
    \! -name 'glxgears*' -a \
    \! -name vkgears -a \
    \! -name '*eglgears*' -a \
    \! -name 'xauth' -a \
    \! -name 'xeyes' -a \
    \! -name mesa-overlay-control.py -a \
    \! -name ulimit -a \
    \! -name ldd -a \
    \! -name ldconfig -a \
    \! -name env -a \
    \! -name sh -a \
    \! -name bash -a \
    \! -name ls -a \
    \! -name file -a \
    \! -name stat -a \
    \! -name dirname -a \
    \! -name realpath -a \
    \! -name readlink -a \
    \! -name basename -a \
    \! -name nproc -a \
    \! -name uname -a \
    \! -name arch -a \
    \! -name rm \
    -exec rm -rf {} \;

# Do this last for obvious reasons.
rm -f $BASEPATH/usr/bin/rm
