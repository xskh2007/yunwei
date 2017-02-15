#


#          Welcome to VMware vSphere PowerCLI!
#
#Log in to a vCenter Server or ESX host:              Connect-VIServer
#To find out what commands are available, type:       Get-VICommand
#To show searchable help for all PowerCLI commands:   Get-PowerCLIHelp
#Once you've connected, display all virtual machines: Get-VM
#If you need more help, visit the PowerCLI community: Get-PowerCLICommunity


#需要确保vm里面已经按装了vm tool 并且允许主机往虚拟机里拷贝文件的参数要是yes

$vc = '172.16.1.2'
Connect-VIServer -Server $vc -username "admin" -Password "*******"

$vmhost="172.16.1.10"
$template="172.16.2.12.tomcat_template"
$datastore="datastore2 (2)"
#$datastore="datastore2 (1)"
#$custsysprep = Get-OSCustomizationSpec myCustSpec
$resourcepool="server1"


$wxvm_list="C:\powercli\wxvmlist2.txt"







function MyCopyFile()
{
for($file=[IO.File]::OpenText($wxvm_list);!($file.EndOfStream);$line=$file.ReadLine() )
{
    #$line;
	#New-vm -vmhost $vmhost -Name $line -Template $template -Datastore $datastore -ResourcePool $resourcepool
	#start-vm $line
	CreateEth0($line)
	Copy-VMGuestFile -Source C:\powercli\ifcfg-eth0 -Destination /etc/sysconfig/network-scripts/ -VM $line -LocalToGuest -Force -GuestUser root -GuestPassword Zzjr#2016
	Copy-VMGuestFile -Source C:\powercli\70-persistent-net.rules -Destination /etc/udev/rules.d/ -VM $line -LocalToGuest -Force -GuestUser root -GuestPassword Zzjr#2016
	#stop-vm $line
	#Copy-VMGuestFile -Source $Sourcefile -Destination 
	#Copy-VMGuestFile -Source C:\powercli\vmlist1.txt -Destination /tmp/ -VM 172.17.2.101_weapon  -GuestUser nbj -GuestPassword Zzjr@2016

}
$file.Close()
}

function CreateEth0($vmname)
{
$str = @"
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
NETMASK=255.255.255.0
GATEWAY=172.16.2.1
"@

$ipaddr="IPADDR="
$ip=$vmname -replace "_.*$"
$ip_str=$ipaddr + $ip
$str|Out-File -filepath C:\powercli\ifcfg-eth0 -Encoding ascii 
$ip_str|Out-File  -filepath C:\powercli\ifcfg-eth0 -Encoding ascii -Append
[IO.File]::ReadAllText("C:\powercli\ifcfg-eth0") -replace "`r`n", "`n"|Out-File -filepath C:\powercli\ifcfg-eth0 -Encoding ascii
$rules="#create by qiantu"
$rules|Out-File  -filepath C:\powercli\70-persistent-net.rules -Encoding ascii
}


function stop_vm()
{
for($file=[IO.File]::OpenText($wxvm_list);!($file.EndOfStream);$line=$file.ReadLine() )
{
    $line;
	stop-vm $line
}
$file.Close()
}


function del_vm()
{
for($file=[IO.File]::OpenText($wxvm_list);!($file.EndOfStream);$line=$file.ReadLine() )
{
    $line;
    Remove-VM $line -DeletePermanently -Confirm

}
$file.Close()
}


#MyCopyFile
#stop_vm
del_vm

