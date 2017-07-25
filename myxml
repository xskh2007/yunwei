#!/usr/bin/env python
# -*- coding:utf-8 -*- 
#Author: qiantu
#qq 261767353


import xml.etree.cElementTree as ET



tree = ET.ElementTree(file="jenkins_job.xml")


root = tree.getroot()

# print root[0][1].attrib


# for ele in tree.iter():
#     print ele.tag, ele.attrib


for ele in tree.iterfind("properties/hudson.model.ParametersDefinitionProperty/parameterDefinitions/hudson.model.StringParameterDefinition/defaultValue"):
    ele.text="mycms"
    ele.set("updated","up")

tree.write("jenkins_job2.xml")

print root
