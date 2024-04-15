#!/bin/sh

/usr/lib/qemu/virtiofsd --socket-path=vhostqemu --shared-dir=/ --sandbox=none &

qemu-system-x86_64 \
    -nographic  -no-reboot -enable-kvm \
	-m 4G -smp 8 \
	-object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
	-numa node,memdev=mem \
	-kernel /boot/vmlinuz-virt \
	-append "console=ttyS0 rootfstype=virtiofs root=myfs rw init=/init.sh panic=-1" \
	-initrd /boot/initramfs-virt \
	-netdev user,id=net0 \
	-device virtio-net-pci,netdev=net0 \
	-chardev socket,id=char0,path=vhostqemu \
	-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs

exit $(cat /test-result)
