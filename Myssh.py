#!/usr/bin/env python
import paramiko
def ss(ip,cmd):
        hostname=ip
        username='nbj'
        password='Zzjr@2016'
        port=22
        paramiko.util.log_to_file('paramiko.log')
        s=paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(hostname=hostname,port=port,username=username,password=password)
        stdin,stdout,stderr=s.exec_command(cmd,get_pty=True)
        print stdout.read()
        s.close()

#file=open("./vmlist1.txt")
#iplist=file.readline().strip('\n')
#while iplist:
#        
#        print iplist
#        iplist=file.readline().strip('\n')

for line in open("wx_vm2.list"): 
        ip=line.strip('\n').split('_')[3]
	#gray_ip=line.strip('\n').split('_')[2]
        #vmname=line.strip('\n').split('_')[1]
	#hostname=line.strip('\n').split('_')[0]+"_"+line.strip('\n').split('_')[1]+"_"+line.strip('\n').split('_')[2]
	#hostname=line.strip('\n').split('_')[0]+"_"+line.strip('\n').split('_')[1]
	#hostname1=line.strip('\n').split('_')[1]+"_01"
	#hostname2=line.strip('\n').split('_')[1]+"_02"

	#host="127.0.0.1"+"    "+line.strip('\n').split('_')[1]+"_"+line.strip('\n').split('_')[2]+"_"+line.strip('\n').split('_')[3]
        #cmd= "sudo bash -c \"echo "  +host+              " >> /etc/hosts\""
        cmd= "sudo sed -i 's/172.16.1.230/192.168.2.90/g' /etc/resolv.conf"
        #cmd= "sudo sed -i 's/template/"+hostname+"/g' /etc/hosts"
	#cmd= "sudo sed -i 's/HOSTNAME=template/HOSTNAME="+hostname+"/g' /etc/sysconfig/network"
	#cmd= "sudo sed -i 's/"+hostname1+"/"+hostname2+"/g' /etc/sysconfig/network"
	#cmd2= "cat /etc/hosts"
	#cmd= "sudo sed -i 's/template/"+hostname+"/g' /etc/hosts"
	#cmd= "\cp /home/nbj/.ssh/authorized_keys{,_bak}"
	#cmd= "cat /tmp/id_rsa.pub >>/home/nbj/.ssh/authorized_keys"
        #cmd= "sudo yum update -y"
        #cmd= "sudo reboot"
        print ip,"---------------------------"
	#ss(gray_ip,cmd)
	ss(ip,cmd)
	#ss(gray_ip,"mkdir -p /home/nbj/.ssh/")
	#ss(gray_ip,"chown -R nbj:nbj /home/nbj/.ssh/")
	#ss(gray_ip,"chmod 700 /home/nbj/.ssh/")
	#ss(gray_ip,"chmod 600 /home/nbj/.ssh/authorized_keys")
	#ss(ip,"sudo \cp /etc/resolv.conf{,_bak}" )
	#ss(ip," sudo chown nbj:nbj /etc/resolv.conf" )
	#ss(ip," sudo chown root:root /etc/resolv.conf" )
	#ss(ip," sudo sed -i 's/192.168.1.33/192.168.2.90/g' /etc/resolv.conf" )
	#ss(ip,"chmod 600 /home/nbj/.ssh/authorized_keys")
