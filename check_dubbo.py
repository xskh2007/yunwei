# -*- coding: utf-8 -*-
import requests
from bs4 import BeautifulSoup



def checkdubbo(dubbo1,dubbo2):
    dubbodict1 = {}
    dubbodict2 = {}
    res=requests.get(dubbo1)
    res.encoding='utf-8'
    # print res.text
    soup = BeautifulSoup(res.text, "html.parser")
    trs=soup.find_all("tbody")[1].select("tr")
    for tr in trs:
        Application_Name=tr.select("td")[0].string
        Providers=tr.select("td")[2].string
        Consumers = tr.select("td")[3].string
        dubbodict1[Application_Name]= Providers+"_"+Consumers

    res2=requests.get(dubbo2)
    res2.encoding='utf-8'
    # print res.text
    soup2 = BeautifulSoup(res2.text, "html.parser")
    trs=soup2.find_all("tbody")[1].select("tr")
    for tr in trs:
        Application_Name=tr.select("td")[0].string
        Providers=tr.select("td")[2].string
        Consumers = tr.select("td")[3].string
        dubbodict2[Application_Name]= Providers+"_"+Consumers

    # print dubbodict1,"a环境"
    # print dubbodict2,"b环境"
    for i in dubbodict1.keys():
        # if dubbodict1[i]==dubbodict2[i]:
        #     print "a环境和b环境都有，切数量相同的服务:"
        #     print i,dubbodict1[i],"----",dubbodict2[i]
        if dubbodict1[i]!=dubbodict2[i]:
            print "数量不同的服务"
            print i,dubbodict1[i],"----",dubbodict2[i]

    for i in dubbodict2.keys():
        # if dubbodict2[i]==dubbodict1[i]:
        #     print "a环境和b环境都有，切数量相同的服务:"
        #     print i,dubbodict1[i],"----",dubbodict2[i]
        if dubbodict2[i]!=dubbodict1[i]:
            print "数量不同的服务"
            print i,dubbodict1[i],"----",dubbodict2[i]





checkdubbo("http://dubbo-a.juban.com/applications.html","http://dubbo-b.juban.com/applications.html")


