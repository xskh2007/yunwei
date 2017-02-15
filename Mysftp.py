#!/usr/bin/python
import paramiko,datetime,os
def qt_sftp(ip,local_dir,remote_dir):
 hostname=ip
 username='admin'
 password='******'
 port=22
 try:
  t=paramiko.Transport((hostname,port))
  print 1111
  t.connect(username=username,password=password)
  print 2222
  sftp=paramiko.SFTPClient.from_transport(t)
  print 333
  files=os.listdir(local_dir)
  print 4444
  #files=sftp.listdir(remote_dir)
  for f in files:
   print ""
   print "##########################"
   print "beginning to upload file form %s %s" % (hostname,datetime.datetime.now())
   print 'uploading file:',os.path.join(remote_dir,f)
   #sftp.get(os.path.join(remote_dir,f),os.path.join(local_dir,f))
   sftp.put(os.path.join(local_dir,f),os.path.join(remote_dir,f))
   print "upload %s ok" % os.path.join(remote_dir,f)
  t.close()
 except Exception:
  print  Exception.strerror 

for line in open("wx_vm1.list"): 
        ip=line.strip('\n').split('_')[3]
        #vmname=line.strip('\n').split('_')[1]
	#print ip,"kkkkkkkkkk",vmname
	qt_sftp(ip,"/root/script/local_dir/","/home/nbj/")

