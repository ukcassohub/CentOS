#!/bin/sh
echo "http is going to make..."
sleep 5
yum -y install libjpeg* libpng* freetype* gd-* gcc gcc-c++ gdbm-devel libtermcap-devel
yum -y install httpd

echo "MariaDB repo is going to make..."
sleep 5
echo "# MariaDB 10.1 CentOS repository list" >> /etc/yum.repos.d/MariaDB.repo
echo "# http://downloads.mariadb.org/mariadb/repositories/# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.1/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum -y install MariaDB-server MariaDB-client

echo "php is going to install..."
sleep 5
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php70w
yum -y install php70w-mysql php70w-pdo php70w-pgsql php70w-odbc php70w-mbstring php70w-mcrypt php70w-gd
yum -y install php70w-pear php70w-pdo_dblib php70w-pecl-imagick php70w-pecl-imagick-devel php70w-xml php70w-xmlrpc