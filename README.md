# A web remote control

![alt text](https://github.com/fabrizio2210/web-infrared/blob/master/images/web_remote_control.jpg "The hardware")

This web remote control is bornt to replace my broken remote control. Somebody can find as inspiration to implement his own.
You can find more on https://medium.com/@fabrizio2210/a-web-remote-control-4de614a62b32

# Goals

- Have got a working remote control
- No app installed on smartphone
- Adhere to CI/CD mechanism

# Develop

## Requirements

To develop the webservice, you need:
- Vagrant with NFS support (to share the foldersrc/)
- libvirt

You can follow these guides for Vagrant/libvirt:

https://linuxsimba.com/vagrant-libvirt-install

https://docs.cumulusnetworks.com/display/VX/Vagrant+and+Libvirt+with+KVM+or+QEMU

https://docs.cumulusnetworks.com/cumulus-vx/Getting-Started/Libvirt-and-KVM-QEMU/

In summary the steps to do are:
```
sudo apt install vagrant vagrant-libvirt

sudo apt install libvirt-daemon-system  python3-distutils  python3-gi-cairo  python3-lib2to3  python3-libvirt qemu-kvm   spice-client-glib-usb-acl-helper  systemd-container    virt-manager  virt-viewer   virtinst  libgovirt-common   gir1.2-gtk-vnc-2.0

sudo systemctl restart libvirtd

# logout and login, you should have the libvirt group

sudo apt install python3-paramiko python3-venv python3-pip

```

## Steps to develop

```
 user@host:~ cd web-infrared/
 user@host:~/web-infrared vagrant-tools/dev-web.sh
```
And then, you can change the file inside `src/` and Flask automatically reloads.

# Installation

You need extra hardware:
- an IR shield
- optionally, an ethernet adapter

The installation is done by Ansible and Jenkins, but it can be done also manually. These commands are taken from Jenkinsfile:
```
 user@host:~ buildDir=/tmp/build
 user@host:~ installDir=opt/web-infrared
 user@host:~ venvPackage=venv.tar
 user@host:~ prefixPackage=web-infrared
 user@host:~ cd web-infrared/
 user@host:~/web-infrared mkdir -p ${buildDir} ; cp -rav * ${buildDir}
 user@host:~/web-infrared DEBIAN/venvCreation.sh -b ${buildDir} -i /${installDir} -o ${venvPackage}
 user@host:~/web-infrared mkdir -p ${buildDir} ; cp -rav * ${buildDir} 
 user@host:~/web-infrared DEBIAN/packetize.sh -b ${buildDir} -i ${installDir} -p ${venvPackage} -o . -f ${prefixPackage}
 user@host:~/web-infrared dpkg -i ./${prefixPackage}-*.deb
```
They should be executed on the target platform (i.e. raspberry) because are platworm dependent (e.g. armv6l).


## How CI/CD

- create test
..- use unit test for python
..- use infratest for Ansible part

- use tools to automate test and deploy
..- use Jenkins to do test and deploy

# Tests

The tests are in the folder tests. They will can be executed by script in a Vagrant environment, or individually executed by Jenkins or Travis.
