#!/bin/sh
######################
#  centos7.7 1908    #
#  Oracle12C install #
#  by dsdata.Co.Ltd  #
#  2020-02-10        #
#  Author JJ         #
######################
. /etc/profile    #.은 이 환경변수 파일을 적용시키겠다 라는 뜻 .=source랑 같은 명령어
mkdir /home/work  #mkdir 디렉토리 생성
echo "work directory is ready!" #echo 출력
sleep 2 #sleep 2초동안 쉬어라
######################
#  sysinfo writed    #
######################
cd /home/work #cd 체인지 디렉토리
echo "now" `pwd` #echo "문자열 출력" `pwd를 수행하면 그 아웃풋 출력해달라`
sleep 2 #sleep 2초 쉬어라
/sbin/hwclock --systohc #--systohc sys는 운영체제하드웨어의 BIOS시간
/sbin/hwclock -r >> /home/work/work_history.txt
uname -a >> /home/work/work_history.txt
grep . /etc/*-release >> /home/work/work_history.txt
ifconfig >> /home/work/work_history.txt
df -Th >> /home/work/work_history.txt
free -m >> /home/work/work_history.txt
cat /proc/cpuinfo >> /home/work/work_history.txt
dmidecode -t 17 >> /home/work/work_history.txt
echo "sysinfo writed"
sleep 2
######################
#  selinux disabled  #
######################
#sed -i "7s/#SELINUX/SELINUX/" /etc/selinux/config
#sed -i "7s/enforcing/disabled/" /etc/selinux/config
cd /etc/selinux
echo "now" `pwd`
sleep 2
cp -p config config.bak #-p는 전부다 복사(권한부터 모든 것), 백업으로 설정파일 바꾼다
sed -i '/SELINUX=enforcing/ c\SELINUX=disabled' /etc/selinux/config #config파일에서 selinux=enforcing/에서 disabeld로 바꿔주세요 문자열바꿔주세요
cd /home/work
echo "now" `pwd`
cat /etc/selinux/config >> /home/work/work_history.txt #바뀐거 넣어줘라
echo "selinux disabled"
sleep 2
######################
#  PermitRootLogin   #
######################
cd /etc/ssh 
echo "now" `pwd`
sleep 2
cp -p sshd_config sshd_config.bak 
sed -i '/#PermitRootLogin yes/ c\PermitRootLogin yes' /etc/ssh/sshd_config 
cd /home/work
cat /etc/ssh/sshd_config >> /home/work/work_history.txt
echo "ssh root login permitted"
sleep 2
######################
#  firewalld disable #
######################
cd /home/work
echo "now" `pwd`
sleep 2
systemctl stop firewalld >> /home/work/work_history.txt 
systemctl disable firewalld >> /home/work/work_history.txt
echo "firewalld disabeld"
sleep 2
######################
#  bluetooth disable #
######################
cd /home/work
echo "now" `pwd`
sleep 2
systemctl stop bluetooth.service >> /home/work/work_history.txt
systemctl disable bluetooth.service >> /home/work/work_history.txt
echo "bluetooth disabeld"
sleep 2
######################
# libvirtd disable   #
######################
#cd /home/work
#echo "now" `pwd`
#sleep 2
#chkconfig libvirtd off >> /home/work/work_history.txt
#systemctl disable libvirtd.service >> /home/work/work_history.txt
#echo "libvirtd disabeld"
#sleep 2
######################
#  update yum.conf   # conf는 설정파일 대부분 /etc 밑에 다 있다.
######################
cd /etc
echo "now" `pwd`
sleep 2
sed -i '2 i\exclude=kernel*' yum.conf #  i는 이 구문을 삽입 시켜주세요 2번째 줄에
echo "insert exlude=kernel* to yum.conf 2line"
sleep 2
######################
#  yum install       #
######################
cd /home/work
echo "now" `pwd`
echo "yum install and update started"
sleep 2
yum install -y cmake *gcc* cvs telnet ypbind compat*
sleep 1
yum install -y glibc.i686 glibc*
sleep 1
yum install -y redhat-lsb-core libcurl* libxslt*
sleep 1
yum install -y pcre*
sleep 1
yum install -y libz* bzip2-devel* readline-devel*
sleep 1
yum -y install binutils compat-libcap1 gcc gcc-c++ glibc glibc.i686
yum -y install glibc-devel glibc.i686 ksh libaio libaio.i686 libaio-devel
yum -y install libaio-devel.i686 libgcc libgcc.i686 libstdc++
yum -y install libstdc++l7.i686 libstdc++-devel libstdc++-devel.i686
yum -y install compat-libstdc++-33 compat-libstdc++-33.i686 libXi libXi.i686
yum -y install libXtst libXtst.i686 make sysstat xorg-x11-apps
######################
#  yum update        #
######################
cd /home/work
echo "now" `pwd`
echo "yum will be updated"
sleep 2
yum -y update
echo "yum updated"
sleep 2
######################
#  SET sysctl.conf   #
######################
echo "SET sysctl.conf Started..."
sleep 2
MEMTOTAL=$(free -b | sed -n '2p' | awk '{print $2}') #free는 메모리의 현재 상황보여주는 명령어 -b바이트 단위 '2p'
SHMMAX=$(expr $MEMTOTAL / 2) # $는 변수 SHMMAX 공유메모리 최대치
SHMMNI=4096 #SHMMNI 공유메모리 최소치
PAGESIZE=$(getconf PAGE_SIZE) # 메모리 관리 페이지 getconf가져오겠다 PAGE_SIZE에서
cat >> /etc/sysctl.conf << EOF #/etc/sysctl.conf 에 써주겠다.
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmmax = $SHMMAX
kernel.shmall = $(expr \( $SHMMAX / $PAGESIZE \) \* \( $SHMMNI / 16 \))
kernel.shmmni = $SHMMNI
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
EOF
echo "SET sysctl.conf end..."
cat /etc/sysctl.conf >> /home/work/work_history.txt
sysctl -p
echo "SET sysctl.conf Committed..."
sleep 2

#######################################이하는 수동으로 할것 !!!!!!!!!!#######################
####make group user##
##단순 설치 시##
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
passwd oracle

##자주쓰는 그룹 설치시##
#i=200; for group in oinstall dba backupdba oper dgdba kmdba; do
#groupadd -g $i $group; i=$(expr $i + 1)
#done
#useradd -u 441 -g oinstall -G dba,oper,backupdba,dgdba,kmdba -d /home/oracle oracle
#passwd oracle

###Oracle install path##
cd /home/oracle
mkdir db
chown -R oracle:oinstall db
chmod -R 775 db
chmod g+s db

###SET limit##
vi /etc/pam.d/login
session    required     pam_selinux.so open
session    required     pam_namespace.so
#add start
session    required     pam_limits.so
#add end
session    optional     pam_keyinit.so force revoke
session    include      system-auth

vi /etc/security/limits.conf
oracle  soft  nproc   2047
oracle  hard  nproc   16384
oracle  soft  nofile  1024
oracle  hard  nofile  65536
oracle  soft  stack   10240
oracle  hard  stack   32768

##설치파일이동 root 로 해도 oracle 권한 생김
scp ./linuxx64_12201_database.zip oracle@localhost:/home/oracle

##oracle 계정 profile 설정
su oracle
vi ~/.bash_profile
umask 022
export TMP=/tmp
export TMPDIR=/tmp
export ORACLE_BASE=/home/oracle/db
export ORACLE_SID=orcl
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/dbhome_1
export ORACLE_HOME_LISTNER=$ORACLE_HOME/bin/lsnrctl
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH=$ORACLE_HOME/bin:$PATH
export NLS_LANG=KOREAN_KOREA.AL32UTF8


database/runInstaller

##리스너 설정 oracle 계정에서 수행
netca
/home/oracle/db/product/12.1.0/dbhome_1/bin/lsnrctl start LISTENER

##데이터베이스 설정 oracle 계정에서 수행
dbca
orcl  #전역 / SID


####################################################################
#################
#       #       #
#  자동 스크립트 작성  #
#       #       #
#################
#!/bin/sh
echo "/etc/oratab"
sleep 2
touch /etc/oratab
echo "orcl:/home/oracle/db/product/12.1.0/dbhome_1:Y" >> /etc/oratab

echo "/etc/sysconfig/orcl.oracledb"
sleep 2
touch /etc/sysconfig/orcl.oracledb
cat >> /etc/sysconfig/orcl.oracledb <<EOF
"ORACLE_BASE=/home/oracle/db
ORACLE_HOME=/home/oracle/db/product/12.1.0/dbhome_1
ORACLE_SID=orcl
EOF

echo "/usr/lib/systemd/system/orcl@lsnrctl.service"
sleep 2
touch /usr/lib/systemd/system/orcl@lsnrctl.service
cat >> /usr/lib/systemd/system/orcl@lsnrctl.service <<EOF
[Unit]
Description=Oracle Net Listener
After=network.target
 
[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/orcl.oracledb
ExecStart=/home/oracle/db/product/12.1.0/dbhome_1/bin/lsnrctl start
ExecStop=/home/oracle/db/product/12.1.0/dbhome_1/bin/lsnrctl stop
User=oracle
 
[Install]
WantedBy=multi-user.target
EOF

echo "/usr/lib/systemd/system/orcl@oracledb.service"
sleep 2
touch /usr/lib/systemd/system/orcl@oracledb.service
cat >> /usr/lib/systemd/system/orcl@oracledb.service <<EOF
[Unit]
Description=Oracle Database service
After=network.target lsnrctl.service
 
[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/orcl.oracledb
ExecStart=/home/oracle/db/product/12.1.0/dbhome_1/bin/dbstart $ORACLE_HOME
ExecStop=/home/oracle/db//product/12.1.0/dbhome_1/bin/dbshut $ORACLE_HOME
User=oracle
 
[Install]
WantedBy=multi-user.target
EOF

echo "/usr/lib/systemd/system/orcl@oracledb.service"
sleep 2
systemctl daemon-reload
sleep 1
systemctl enable orcl@lsnrctl
sleep 1
systemctl enable orcl@oracledb
sleep 2
echo "making oracle init script done!!!!!!!!!!!!!"

#################################### TIP ##########################################
##create user
ALTER SESSION SET "_ORACLE_SCRIPT"=true; ## c## 붙이기 싫으면 이걸로하기
create user c##dsdata identified by chakra20;
grant connect, resource, dba to  c##dsdata;

##쿼리모음
select sequence_name, increment_by from user_sequences;
select * from all_users;
select username, user_id from dba_users;
select * from dba_roles;
select grantee, privilege from dba_sys_privs where grantee='connect';
select * from tab;
#현재 릴리즈 번호 알아내기
select * from product_component_version;
#테이블스페이스 정보 조회
select tablespace_name, status, contents from dba_tablespaces;
#암호 바꾸기
alter user sys identified by 123;
