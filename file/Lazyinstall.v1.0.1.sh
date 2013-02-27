#!/bin/sh
# Lazy Minimal Install Scripts
# root's password: LazyZhu, Run "passwd" to Change it.
# © 2013 LazyZhu All Rights Reserved.

# Set Linux PATH Environment Variables
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# Disable BASH History For Session
unset HISTFILE
stty erase '^?'
# Check If You Are Root
if [ $(id -u) != "0" ]; then
    clear
    echo -e "\033[33m Error: You must be root to run this script! \033[0m"
    exit 2
fi
## Set Source & Timezone
function do_source {
    # Ask Using Which Package Source and Timezone
    echo -n -e "\033[36m Which package source and timezone do you want? \033[0m"
    read -t 60 -p "(en/cn): " SOURCE
    # Check User Input
    if [ "$SOURCE" != "en" ] && [ "$SOURCE" != "cn" ]; then
    # Execute Function Again
        do_source
    fi
}
## Peinstall CentOS
function do_centos {
    # Get Grub Info
    DEFAULT_NUM=`egrep "^( *)default=.+$" /boot/grub/grub.conf|awk '{print $1}'|sed "s/^.*default=//g"|awk '{print $1}'` >/dev/null
    BOOT_TILLE=$(($DEFAULT_NUM+1)) >/dev/null
    BOOT_DISK=`egrep "^( *)(root)( *)(\(.+)\)$" /boot/grub/grub.conf|awk "{if (NR==${BOOT_TILLE}) print}"|awk '{print $2}'` >/dev/null
    INITRD_PATH=`egrep "^( *)(initrd).+$" /boot/grub/grub.conf|awk "{if (NR==${BOOT_TILLE}) print}"|awk '{print $2}'` >/dev/null
    BOOT_PATH=${INITRD_PATH%/*}
    NEW_DEFAULT=`egrep "^( *)title.+$" /boot/grub/grub.conf|wc -l|awk '{print $1-1}'` >/dev/null

    # Download vmlinuz & initrd.img
    if [[ $CHOICE == "1" ]]; then
        echo -e "\033[32m Preparing for installing CentOS.5.x86 ...\033[0m"
        OS=centos.5.x86
        KS_VER=v1.6
        rm -rf $OS.vmlinuz $OS.initrd.img
        wget -c -t3 -T3 http://mirror.centos.org/centos/5/os/i386/isolinux/vmlinuz -P $BOOT_PATH -O $OS.vmlinuz > /dev/null 2>&1
        wget -c -t3 -T3 http://mirror.centos.org/centos/5/os/i386/isolinux/initrd.img -P $BOOT_PATH -O $OS.initrd.img > /dev/null 2>&1
        do_source
    elif [[ $CHOICE == "2" ]]; then
        echo -e "\033[32m Preparing for installing CentOS.5.x64 ...\033[0m"
        OS=centos.5.x64
        KS_VER=v1.6
        rm -rf $OS.vmlinuz $OS.initrd.img
        wget -c -t3 -T3 http://mirror.centos.org/centos/5/os/x86_64/isolinux/vmlinuz -P $BOOT_PATH -O $OS.vmlinuz > /dev/null 2>&1
        wget -c -t3 -T3 http://mirror.centos.org/centos/5/os/x86_64/isolinux/initrd.img -P $BOOT_PATH -O $OS.initrd.img > /dev/null 2>&1
        do_source
    elif [[ $CHOICE == "3" ]]; then
        echo -e "\033[32m Preparing for installing CentOS.6.x86 ...\033[0m"
        OS=centos.6.x86
        KS_VER=v1.1
        rm -rf $OS.vmlinuz $OS.initrd.img
        wget -c -t3 -T3 http://mirror.centos.org/centos/6/os/i386/isolinux/vmlinuz -P $BOOT_PATH -O $OS.vmlinuz > /dev/null 2>&1
        wget -c -t3 -T3 http://mirror.centos.org/centos/6/os/i386/isolinux/initrd.img -P $BOOT_PATH -O $OS.initrd.img > /dev/null 2>&1
        do_source
    elif [[ $CHOICE == "4" ]]; then
        echo -e "\033[32m Preparing for installing CentOS.6.x64 ...\033[0m"
        OS=centos.6.x64
        KS_VER=v1.1
        rm -rf $OS.vmlinuz $OS.initrd.img
        wget -c -t3 -T3 http://mirror.centos.org/centos/6/os/x86_64/isolinux/vmlinuz -P $BOOT_PATH -O $OS.vmlinuz > /dev/null 2>&1
        wget -c -t3 -T3 http://mirror.centos.org/centos/6/os/x86_64/isolinux/initrd.img -P $BOOT_PATH -O $OS.initrd.img > /dev/null 2>&1
        do_source
    else
        echo -e "\033[31m An Error Occurred, Please Contact [LazyZhu.com]. \033[0m"
        exit 1
    fi

    # Add New Grub Menu
    echo "title Install $OS" >> /boot/grub/grub.conf
    echo "        root $BOOT_DISK" >> /boot/grub/grub.conf
    echo "        kernel $BOOT_PATH/$OS.vmlinuz ks=http://fzrxefe.googlecode.com/files/$OS.$KS_VER.$SOURCE.ks.cfg" >> \
         /boot/grub/grub.conf
    echo "        initrd $BOOT_PATH/$OS.initrd.img" >> /boot/grub/grub.conf

    # Reboot or not?
    echo -n -e "\033[36m Do you want to reboot and reinstall os immediately? \033[0m"
    read -t 60 -p "(Y/n): " INSTALL_NOW
    if [ "$INSTALL_NOW" == "n" ]; then
        echo -e "\033[32m You can reinstall os from grub boot menu later. \033[0m"
        sleep 1
        exit 0
    else
        sed -i "s/^.*default=.*/default=$NEW_DEFAULT/g" /boot/grub/grub.conf
        sleep 1
        reboot
    fi
}
## Peinstall Debian
function do_debian {
    # Ask Using Which Package Source and Timezone
    echo -e "\033[36m To do ... \033[0m"
    #echo -n -e "\033[36m Which package source and timezone do you want? \033[0m"
    #read -t 60 -p "(en/cn): " SOURCE
    # Check User Input
    #if [ "$SOURCE" != "en" ] && [ "$SOURCE" != "cn" ]; then
    # Execute Function Again
    #    do_source
    #fi
}
# Menu
echo -e "\033[31m Worning: \033[0m"
echo -e "\033[33m Reinstall os will destory all data \033[0m"
echo -e "\033[33m Please backup important data first \033[0m"
echo -e "\033[35m ================================== \033[0m"
echo -e "\033[35m (1) Install CentOS.v5.x86          \033[0m"
echo -e "\033[35m (2) Install CentOS.v5.x64          \033[0m"
echo -e "\033[35m (3) Install CentOS.v6.x86          \033[0m"
echo -e "\033[35m (4) Install CentOS.v6.x64          \033[0m"
echo -e "\033[35m (5) Install Debian.v6.x86(Todo)    \033[0m"
echo -e "\033[35m (6) Install Debian.v6.x64(Todo)    \033[0m"
echo -e "\033[35m (7)  Exit to backup data           \033[0m"
echo -e "\033[35m ---------------------------------- \033[0m"
echo -e "\033[32m    root's password: LazyZhu        \033[0m"
echo -e "\033[32m    Run [passwd] to Change it.      \033[0m"
echo -e "\033[35m ================================== \033[0m"

CHOICE=
echo -n -e "\033[36m Please choise [1-7] \033[0m"
read -t 60 -p ":" CHOICE

case $CHOICE in
  1|2|3|4)
  do_centos
  ;;
  5|6)
  do_debian
  ;;
  7)
  echo "Exit to backup data."
  exit 0
  ;;
  *)
  echo -e "\033[33m Error Input, Please try again. \033[0m"
  exit 1
  ;;

esac

exit 0
