#!/opt/py3/bin/python
# Create your tests here.

from jenkinsapi.jenkins import Jenkins as Jenkins2
import jenkins
import time

jks_url='http://111.111.111.111:8080/'
#中间过nginx会有问题
username="qiantu"
password="11111111"
job_name_str="_yousong_b_"
#查询jobname包含 _yousong_b_ 的所有项目，判断发布SUCCESS后继续发布下一个


def mycl_deploy():
    server = jenkins.Jenkins(jks_url, username, password)
    server2 = Jenkins2(jks_url, username, password)
    jobnames=[]
    joblists=server2.get_jobs()
    for i in joblists:
        if i[0].find(job_name_str)>=0:
            jobnames.append(i[0])
    for i in jobnames:
        server2.build_job(i,params={"env":"all"})
        # job_lastBuild_number = server.get_job_info(i)['lastBuild']['number']
        # print(server.get_build_info(i, job_lastBuild_number)['building'])
        while True:
            job_lastBuild_number=server.get_job_info(i)['lastBuild']['number']
            building=server.get_build_info(i, job_lastBuild_number)['building']
            if building is True:
                print(i,"is building")
                time.sleep(10)
            if building is False:
                result=server.get_build_info(i, job_lastBuild_number)['result']
                if result=="SUCCESS":
                    print("build ",i,result)
                    break
                else:
                    # result=="FAILURE"
                    print(result)
                    exit(1000)
                print (i,result)
    print (jobnames)

mycl_deploy()

