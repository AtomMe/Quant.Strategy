# encoding: UTF-8
from loadDataFromMongo import *
from datetime import datetime

startDate =  datetime(2013, 9, 1) #开始时间
endDate =  datetime(2015, 9, 1)   #结束时间
code = '000001' 				  #要查询的股票代码
DbName = 'DAY_MARKET_DB'          #查询的数据库
field = 'close'                   #查询的数据指标

closeData = loadDayM(DbName,code,field,startDate,endDate) #返回list数组

for i in range(len(closeData)):
    print closeData[i]

print 'done! ',len(closeData),u'记录'