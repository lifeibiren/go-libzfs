from alpine

run apk add gcc make go linux-virt linux-virt-dev coreutils \
        zlib-dev libtirpc-dev openssl-dev \
        attr-dev e2fsprogs-dev glib-dev linux-headers \
        py3-cffi py3-distlib py3-setuptools python3-dev util-linux-dev \
        virtiofsd qemu-system-x86_64 rsync

run wget https://github.com/openzfs/zfs/releases/download/zfs-2.2.1/zfs-2.2.1.tar.gz
run tar -xvf zfs-2.2.1.tar.gz
run cd zfs-2.2.1 && \
    ./configure \
        --prefix=/usr \
        --with-tirpc \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --with-config=all \
        --with-linux=$(echo /usr/src/linux-headers-*) \
        --with-udevdir=/lib/udev \
        --disable-systemd \
        --disable-static \
        --with-python=3 \
        --enable-pyzfs && \
    make -j && \
    make install

add ci/init.sh /init.sh
add ci/runner.sh /runner.sh

add . /src/
run cd /src && go build

CMD ["/runner.sh"]

