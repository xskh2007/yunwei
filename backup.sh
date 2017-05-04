#/bin/bash
db_user="root"
db_pass="123456"
db_host="localhost"
db_port="3306"
src_dir="/var/lib/mysql/"
db_dir="/home/db_backup/"
date=`date +%Y%m%d`
if [ ! -d $db_dir ]; then  
	mkdir -p $db_dir 
fi  
mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "stop slave"
echo "stop slave ok">>/var/log/backup.log
mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "flush tables with read lock;"
echo "flush tables with read lock ok">>/var/log/backup.log
Position=`mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "show master status;"`
echo $Position >${src_dir}backup_Position_${date}.txt
echo "backup Position ok">>/var/log/backup.log
echo "begin to backup">>/var/log/backup.log
tar zcvf ${db_dir}${date}_mysql.tar.gz $src_dir
echo "backup ok">>/var/log/backup.log
mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "start slave"
echo "UNLOCK TABLES ">>/var/log/backup.log
echo "end ">>/var/log/backup.log


cd $db_dir && find $db_dir -mtime +3 -type f | xargs rm -f


