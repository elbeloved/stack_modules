#!/bin/bash -xe

mkfs -t ext4 /dev/sdf  # Format the EBS volume
mkdir -p /u01          # Create directory for first volume
mount /dev/sdf /u01   # Mount first volume
echo "/dev/sdf /u01 ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab  # Add entry to /etc/fstab for automatic mounting on boot

mkfs -t ext4 /dev/sdg  # Format the second EBS volume
mkdir -p /u02         # Create directory for second volume
mount /dev/sdg /u02   # Mount second volume
echo "/dev/sdg /u02 ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab  # Add entry to /etc/fstab for automatic mounting on boot

mkfs -t ext4 /dev/sdh  # Format the second EBS volume
mkdir -p /u03         # Create directory for second volume
mount /dev/sdh /u03   # Mount second volume
echo "/dev/sdh /u03 ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab  # Add entry to /etc/fstab for automatic mounting on boot
            
mkfs -t ext4 /dev/sdi  # Format the second EBS volume
mkdir -p /u04         # Create directory for second volume
mount /dev/sdi /u04   # Mount second volume
echo "/dev/sdi /u04 ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab  # Add entry to /etc/fstab for automatic mounting on boot

mkfs -t ext4 /dev/sdj  # Format the second EBS volume
mkdir -p /backup         # Create directory for second volume
mount /dev/sdj /backup   # Mount second volume
echo "/dev/sdj /backup ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab  # Add entry to /etc/fstab for automatic mounting on boot

#install packages
sudo su -
yum update -y
yum install git -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server
systemctl start httpd
systemctl enable httpd
systemctl is-enabled httpd

if [ ! -d "${MOUNT_POINT}" ]; then
    mkdir -p ${MOUNT_POINT}
    chown ec2-user:ec2-user ${MOUNT_POINT}
fi

echo ${EFS_DNS}:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 | sudo tee -a /etc/fstab
sudo mount -a

##add user to Apache group and grant permissions to /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd ${MOUNT_POINT}
sudo chmod -R 755 ${MOUNT_POINT}

if ! [ -e /var/www/html/CliXX_Retail_Repository ]; then
    git clone ${GIT_REPO}
    cp -r CliXX_Retail_Repository/* ${MOUNT_POINT}

else
    echo "Directory 'CliXX_Retail_Repository' already exists."

fi

DB_HOST=$(echo "${DB_HOST_NEW}" | sed 's/':3306'//g')

#replace DB Hostname in configuration file
sed -i "s/'wordpress-db.cc5iigzknvxd.us-east-1.rds.amazonaws.com'/'$${DB_HOST}'/g" /var/www/html/wp-config.php

#grant file ownership of /var/www & its contents to apache user
chown -R apache /var/www

#grant group ownership of /var/www & contents to apache group
chgrp -R apache /var/www

#change directory permissions
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;

#recursively change file permission of /var/www & subdir to add group write perm
find /var/www -type f -exec sudo chmod 0664 {} \;
 
mysql -h "$${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" <<EOF
    use wordpressdb;
    Update wp_options SET option_value="${LB_DNS}" WHERE option_value like '%ELB%';
EOF

#restart Apache
systemctl restart httpd
service httpd restart

#enable httpd
systemctl enable httpd
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5


