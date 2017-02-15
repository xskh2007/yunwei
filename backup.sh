#/bin/bash
db_user="root"
db_pass="12345"
db_host="127.0.0.1"
db_port="3306"
src_dir="/var/lib/mysql/"
db_dir="/home/db_backup/"
date=`date +%Y%m%d`
if [ ! -d $db_dir ]; then  
	mkdir -p $db_dir 
fi  

mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "stop slave"
Position=`mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "show master status;"`
echo $Position >${src_dir}backup_Position.txt
tar zcvf ${db_dir}${date}_mysql.tar.gz $src_dir
mysql -u$db_user -h$db_host -P$db_port -p$db_pass -e "start slave"


cd $db_dir && find $db_dir -mtime +7 -type f | xargs rm -f

