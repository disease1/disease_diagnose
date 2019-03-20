from py2neo import Graph
import os
import ast
import pymysql

pro_file = open('./Neo4j_pro1.lp', 'wb+')
sent = []
sent2 = []

#连接neo4j数据库
def neo4j_nodes():
    graph = Graph('http://localhost:7474',username='neo4j',password='1257515964')
    result = str(graph.run("MATCH(n) RETURN  properties(n),labels(n)").data())
    result = result.split('}, {')
    #print(result)
    return result

#读出neo4j边数据信息
def neo4j_relate():
    graph = Graph('http://localhost:7474',username='neo4j',password='1257515964')
    result = str(graph.run("MATCH(a)-[r]->(b) RETURN  a.id,r.name,b.id").data())
    result = result.split('}, {')
    #print(result)
    return result
#处理关系信息
def procline2(line):
    line = line.replace('\'a.id\'','').replace('\'r.name\'','').replace('\'b.id\'','')
    line = line.replace(' ','').replace(':','')
    line = line.replace('\'','')
    line = line.replace('[','').replace(']','').replace('{','').replace('}','')
    strx = str(line)
    return strx

#对导出数据进行处理
def procline(line):
    #line = line.replace('\'properties(n)\': {\'','').replace('\'labels(n)\'','labels').replace('{\'','').replace('}','').replace('\': \'',':"').replace('\', \'','",').replace('\': [\'',':"').replace(']','"')
    line = line.replace('[','').replace(']','').replace('{','').replace('}','').replace(' ','')
    line = line.replace('\',\'','","').replace('\':\'','":"')
    line = line.replace('\'','"')
    line = line.replace('"properties(n)":','')
    strx = '{'
    strx += str(line)
    strx += '}'
    return str(strx)
def procline1(line):
    line = line.replace('"','')
    return line

#匹配每个诊断要素
def find_key(key_str,strx):
    if key_str in strx.keys():
        '''
        if (key_str == 'id'):
            asp_line = 'term(' + str(strx[key_str]) + ')'
        else:
            asp_line = 'term(' + str(strx[key_str]) + ')'
        asp_line = bytes(asp_line + '\r\n', encoding="UTF-8")
        pro_file.write(asp_line)
        '''
        return '"' + str(strx[key_str]) + '"'
    else:
        return 'null'

def disease_diagnose(asp_line,strx):
    factor = ['id','name','icd10','guiline_text']
    asp_line += '('
    flag = 0
    for line in factor:
        if flag:
            asp_line += ','
        asp_line += find_key(line, strx)
        if (flag == 0):
            asp_line = procline1(asp_line)
            sent2.append(find_key(line, strx))#保存疾病id
        flag = 1
    asp_line += ').'
    return str(asp_line)

#匹配所见要素节点
def factor_observation(asp_line,strx):
    factor = ['id','name','part','degree','trend','state','duration_min','duration_max']
    asp_line += '('
    flag = 0
    for line in factor:
        if flag:
            asp_line += ','
        asp_line += find_key(line, strx)
        if (flag == 0):
            asp_line = procline1(asp_line)
            sent.append(find_key(line, strx))#加入疾病id
        flag = 1
    asp_line += ').'
    return asp_line

#处理检查数据要素
def factor_inspection_data(asp_line,strx):
    factor = ['id','name','value_min','value_max','unit','state']
    asp_line += '('
    flag = 0
    for line in factor:
        if flag:
            asp_line += ','
        asp_line += find_key(line, strx)
        if (flag == 0):
            asp_line = procline1(asp_line)
            sent.append(find_key(line, strx))#加入疾病id
        flag = 1
    asp_line += ').'
    return str(asp_line)

#匹配检查结果要素
def factor_inspectionConclusion(asp_line,strx):
    factor = ['id','name','conclusion','part','degree','trend','state']
    asp_line += '('
    flag = 0
    for line in factor:
        if flag:
            asp_line += ','
        asp_line += find_key(line, strx)
        if (flag == 0):
            asp_line = procline1(asp_line)
            sent.append(find_key(line, strx))  # 加入疾病id
        flag = 1
    asp_line += ').'
    return str(asp_line)

#处理逻辑或节点
def logic_or(asp_line,strx):
    asp_line += '('
    asp_line += find_key('id', strx)
    asp_line += ').'
    asp_line = procline1(asp_line)
    return str(asp_line)

#处理逻辑AND节点
def logic_and(asp_line,strx):
    asp_line += '('
    asp_line += find_key('id', strx)
    asp_line += ').'
    asp_line = procline1(asp_line)
    return str(asp_line)

#处理逻辑item节点
def logic_item(asp_line,strx):
    asp_line += '('
    asp_line += find_key('name', strx)
    asp_line += ').'
    asp_line = procline1(asp_line)
    return str(asp_line)

#处理节点关系信息
def sove_relate():
    result = neo4j_relate()
    for line in result:
        line = procline2(line)
        #print(line)
        strx = line.split(",")
        asp_line = strx[1] + '(' + strx[0] +',' + strx[2] + ').'
        asp_line = bytes(str(asp_line) + '\r\n', encoding="UTF-8")
        pro_file.write(asp_line)

#处理要素和边
def sove_asp():
    result = neo4j_nodes()

    for line in result:
        line = procline(line)
        strx = ast.literal_eval(line)
        #print(strx)
        asp_index = str(strx['labels(n)'])
        asp_line = str(strx['labels(n)'])
        asp_line = eval(asp_index)(asp_line,strx)
        #print(asp_line)
        asp_line = bytes(str(asp_line) + '\r\n', encoding="UTF-8")
        pro_file.write(asp_line)

    for line in sent:
        asp_line = 'factor('
        asp_line  = asp_line + sent2[0] + ',' + line + '' + ',' + line +').'
        asp_line = procline1(asp_line)
        #print(asp_line)
        asp_line = bytes(str(asp_line) + '\r\n', encoding="UTF-8")
        pro_file.write(asp_line)
        #print(asp_line)

os.system("neo4j.bat console")
sove_relate()
sove_asp()
pro_file.close()
os.system('clingo Neo4j_pro1.lp 医学术语.lp 推理规则.lp 病历1分析.lp 0 > result.lp')

