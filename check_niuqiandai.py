#!/usr/bin/python
# -*- coding: utf-8 -*-
import urllib
import urllib2
import time
import MySQLdb
import os

phone1="1875801111"


interval=60
niuqiandai_cmd1="SELECT * FROM zzjr_prod.prod_base WHERE deposit_type=71 AND prod_status=1"
niubaofen_80000_cmd="SELECT * FROM zzjr_prod.prod_base WHERE deposit_type=51 AND prod_status=1 AND annual_rate=80000 AND gmt_online<=NOW()"
niubaofen_90000_cmd="SELECT * FROM zzjr_prod.prod_base WHERE deposit_type=51 AND prod_status=1 AND annual_rate=90000 AND gmt_online<=NOW()"
niubaofen_100000_cmd="SELECT * FROM zzjr_prod.prod_base WHERE deposit_type=51 AND prod_status=1 AND annual_rate=100000 AND gmt_online<=NOW()"

def check_qiandai(cmd,sms_content,filename):
    send_sms1="curl -d \"phone="+phone1+"&password=12345&message="+sms_content+"\" 192.168.2.168:11111/sms "
    # print send_sms
    # db = MySQLdb.connect(host="192.168.1.23", user="zzjr", passwd="123", db="zzjr_server", port=3306)
    cursor = db.cursor()
    cursor.execute(cmd)
    data = cursor.rowcount
    cursor.close()
    db.close()
    lockstr = open(filename, 'r')
    a=lockstr.read().strip('\n')
    lockstr.close()
    b=time.strftime('%Y-%m-%d',time.localtime(time.time())).strip('\n')
    # print a==b
    if data<1 and a!=b:
        os.system(send_sms1)
        f1 = open(filename, 'w')
        f1.write(time.strftime('%Y-%m-%d',time.localtime(time.time())))
        f1.close()
        print "send sms ok"
        return sms_content
    elif data<1 and a==b:
        print "has locked"
        return "has locked"
    else:
        print "nothing"
        f2 = open(filename, 'w')
        f2.write("open sms")
        f2.close()
        return "没有已售完的产品"



while 1:
    check_qiandai(niuqiandai_cmd1,"牛钱袋已售完","file1")
    check_qiandai(niubaofen_80000_cmd,"牛宝丰-基础利率8%已售完","file2")
    check_qiandai(niubaofen_90000_cmd,"牛宝丰-基础利率9%已售完","file3")
    check_qiandai(niubaofen_100000_cmd,"牛宝丰-基础利率10%已售完","file4")

    time.sleep(interval)


