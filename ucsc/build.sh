#!/bin/sh
arch=x86_64
pkg=ucsc
version=312
build_deps="libc6-dev zlib1g-dev libncurses5-dev libmysqlclient-dev unzip libpng-dev"
urls="
http://hgdownload.soe.ucsc.edu/admin/jksrc.v${version}.zip
"

apt-get -qq update &&
    apt-get install --no-install-recommends -y $build_deps &&
    mkdir /build &&
    cd /build &&

    ( for url in $urls; do
        wget "$url" || false || exit
    done ) &&

    mkdir -p /bin/${arch}/ /build/dest/bin /build/dest/lib &&
    unzip jksrc.v${version}.zip &&
    cd kent/src/lib/ &&
    make &&
    cd ../utils/ &&
    find . -type d -maxdepth 1 -mindepth 1 -exec make -C '{}' \; &&
    mv /bin/${arch}/* /build/dest/bin/ &&
    tar zcf /host/ucsc-${version}-Linux-${arch}.tar.gz -C /build/dest .
