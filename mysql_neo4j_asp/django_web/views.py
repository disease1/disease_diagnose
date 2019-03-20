from django.shortcuts import render
from django.db import models


import pymysql

#在views层中调用templates的视图函数
def index(request):
    return render(request,'ZXF_task_display.html')
#数据库数据显示函数
def table(request):
    '''conn = pymysql.connect(host='127.0.0.1', user='root', passwd='jibing', db='diagnose', charset='utf8')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM diagnose.disease_dignose")
    dis_diagnose = cursor.fetchall()
    #dis_diagnose = models.object.all()
    cursor.close()
    conn.close()
    '''
    conclusion = open('./reson_asp/result.lp', 'r', encoding='UTF-8')
    flag = 0
    strx = conclusion.read()
    strx = strx.split('\n')
    #print(strx[4])
    conclusion.close()
    return render(request,'ZXF_task_display.html',{"info_dis":strx[4]})
# Create your views here.

