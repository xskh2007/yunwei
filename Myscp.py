#!/usr/bin/python
import paramiko,datetime,os
def qt_sftp(ip,local_dir,remote_dir):
    hostname=ip
    username='nbj'
    password='Zzjr@2016'
    port=22
    t=paramiko.Transport((hostname,port))
    t.connect(username=username,password=password)
    sftp=paramiko.SFTPClient.from_transport(t)
    files=os.listdir(local_dir)
    for f in files:
        #sftp.get(os.path.join(remote_dir,f),os.path.join(local_dir,f))
        sftp.put(os.path.join(local_dir,f),os.path.join(remote_dir,f))
        #print "upload %s ok" % os.path.join(remote_dir,f)
        t.close()

for line in open("wxgray.list"): 
        ip=line.strip('\n').split('_')[2]
	print ip,"-----------------------"
        #vmname=line.strip('\n').split('_')[1]
	#print ip,"kkkkkkkkkk",vmname
	qt_sftp(ip,"/root/script/local_dir/","/home/nbj/.ssh/")

