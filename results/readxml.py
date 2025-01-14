import os
import xml.etree.ElementTree as ET

# 获取当前文件夹路径
current_folder = os.getcwd()

# XML文件路径
xml_file = os.path.join(current_folder, 'results/variables.xml')

# 解析XML文件
tree = ET.parse(xml_file)
root = tree.getroot()

# 遍历所有variable节点
variables = {}
for variable in root.findall('.//variable'):
    name = variable.get('name')
    value = variable.text
    variables[name] = value

# 打印所有变量及其值
for name, value in variables.items():
    print(f'{name}: {value}')