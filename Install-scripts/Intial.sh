#### #### #### #### #### #### #### #### #### #### #### #### #### 
#### At first, run this scriot on both Master and Worker nodes. #### 
#### #### #### #### #### #### #### #### #### #### #### #### #### 

#!/bin/bash

yum update -y
yum install -y epel-release vim git screen ntp curl wget yum-utils 

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


# Disable Swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a


init 6
