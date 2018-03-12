# -*- coding: utf-8 -*-


from datetime import datetime, timedelta
import pymongo
from time import time
from DayMarketDataClass import *
import types
from MongoSetting import loadMongoSetting
import csv
import codecs

##-----插入日级别行情数据----------#
# 读取数据和插入到数据库

#将csv文件中的数据导入数据库中 stockCode为股票代码，csv文件命名方式为stockCode.csv,dbName数据库名字
#一个股票一个Collection
def insertStockDayMData(stockCode,filename,dbName=u'STOCK_DAY_MARKET_DB'):
    
    start = time()
    
    # 锁定集合，并创建索引,数据库连接
    host, port = loadMongoSetting()
    client = pymongo.MongoClient(host, port)    
    collection = client[dbName][stockCode]
    collection.ensure_index([('date', pymongo.ASCENDING)], unique=True)#设置日期为主键

    #fileName = stockCode+'.csv'
    reader = csv.DictReader(codecs.open(filename))
    # 读取数据和插入到数据库
    for d in reader:
        data = StockDayMData()

        data.date = datetime.strptime(d['date'].strip('\t'), '%Y-%m-%d')
        data.code = str(d['code'].encode('utf-8').strip('\t'))      # 代码
        data.open = float(d['open'].strip('\t'))                    # 开盘价
        data.high = float(d['high'].strip('\t'))                    # 最高价
        data.low = float(d['low'].strip('\t'))                      # 最低价
        data.close = float(d['close'].strip('\t'))                  # 收盘价                                            # 交易日期
        data.change = float(d['change'].strip('\t')) 
        data.volume = float(d['volume'].strip('\t'))                # 成交量
        data.money = float(d['money'].strip('\t'))                  # 成交金额

        data.traded_market_value = float(d['traded_market_value'].strip('\t'))
        data.market_value =  float(d['market_value'].strip('\t'))
        data.turnover = float(d['turnover'].strip('\t'))
        data.adjust_price = float(d['adjust_price'].strip('\t'))

        data.report_type = datetime.strptime(d['report_type'].strip('\t'), '%Y-%m-%d') if d['report_type'] else None
        data.report_date = datetime.strptime(d['report_date'].strip('\t'), '%Y-%m-%d') if d['report_date'] else None
        data.PE_TTM = float(d['PE_TTM'].strip('\t')) if d['PE_TTM'] else 0
        #print u'不为空' if d['PS_TTM'] else u'为空'
        
        data.PS_TTM = float(d['PS_TTM'].strip('\t')) if d['PS_TTM'] else 0

        data.PC_TTM = float(d['PC_TTM'].strip('\t')) if d['PC_TTM'] else 0
        data.PB = float(d['PB'].strip('\t')) if d['PB'] else 0

        data.adjust_price_f = float(d['adjust_price_f'].strip('\t'))

        flt = {'date': data.date}
        collection.update_one(flt, {'$set':data.__dict__}, upsert=True) 
    
    print u'插入完毕，耗时：%s' % (time()-start)

def updateStockDayMData(stockCode,filename,dbName=u'STOCK_DAY_MARKET_DB'):
    
    start = time()
    
    # 锁定集合，并创建索引,数据库连接
    host, port = loadMongoSetting()
    client = pymongo.MongoClient(host, port)    
    collection = client[dbName][stockCode]
    collection.ensure_index([('date', pymongo.ASCENDING)], unique=True)#设置日期为主键

    #fileName = stockCode+'.csv'
    reader = csv.DictReader(codecs.open(filename))
    # 读取数据和插入到数据库
    for d in reader:
        data = StockDayMData()

        data.date = datetime.strptime(d['date'].strip('\t'), '%Y-%m-%d')
        data.code = str(d['code'].encode('utf-8').strip('\t'))      # 代码
        data.open = float(d['open'].strip('\t'))                    # 开盘价
        data.high = float(d['high'].strip('\t'))                    # 最高价
        data.low = float(d['low'].strip('\t'))                      # 最低价
        data.close = float(d['close'].strip('\t'))                  # 收盘价                                            # 交易日期
        data.change = float(d['change'].strip('\t')) 
        data.volume = float(d['volume'].strip('\t'))                # 成交量
        data.money = float(d['money'].strip('\t'))                  # 成交金额

        data.traded_market_value = float(d['traded_market_value'].strip('\t'))
        data.market_value =  float(d['market_value'].strip('\t'))
        data.turnover = float(d['turnover'].strip('\t'))
        data.adjust_price = float(d['adjust_price'].strip('\t'))

        data.report_type = datetime.strptime(d['report_type'].strip('\t'), '%Y-%m-%d') if d['report_type'] else None
        data.report_date = datetime.strptime(d['report_date'].strip('\t'), '%Y-%m-%d') if d['report_date'] else None
        data.PE_TTM = float(d['PE_TTM'].strip('\t')) if d['PE_TTM'] else 0
        #print u'不为空' if d['PS_TTM'] else u'为空'
        
        data.PS_TTM = float(d['PS_TTM'].strip('\t')) if d['PS_TTM'] else 0

        data.PC_TTM = float(d['PC_TTM'].strip('\t')) if d['PC_TTM'] else 0
        data.PB = float(d['PB'].strip('\t')) if d['PB'] else 0

        data.adjust_price_f = float(d['adjust_price_f'].strip('\t'))

        flt = {'date': data.date}
        collection.update_one(flt, {'$set':data.__dict__}, upsert=True) 
    
    print u'插入完毕，耗时：%s' % (time()-start)

def insertIndexDayMData(indexCode,filename,dbName=u'INDEX_DAY_MARKET_DB'):
    
    start = time()
    
    # 锁定集合，并创建索引,数据库连接
    host, port = loadMongoSetting()
    client = pymongo.MongoClient(host, port)    
    collection = client[dbName][indexCode]
    collection.ensure_index([('date', pymongo.ASCENDING)], unique=True)#设置日期为主键

    #fileName = stockCode+'.csv'
    reader = csv.DictReader(codecs.open(filename))
    # 读取数据和插入到数据库
    for d in reader:
        data = IndexDayMData()

        data.date = datetime.strptime(d['date'].strip('\t'), '%Y-%m-%d')
        data.code = str(d['index_code'].encode('utf-8').strip('\t'))# 代码
        data.open = float(d['open'].strip('\t'))                    # 开盘价
        data.high = float(d['high'].strip('\t'))                    # 最高价
        data.low = float(d['low'].strip('\t'))                      # 最低价
        data.close = float(d['close'].strip('\t'))                  # 收盘价                                            # 交易日期
        data.change = float(d['change'].strip('\t')) if d['change'] else 0
        data.volume = float(d['volume'].strip('\t'))                # 成交量
        data.money = float(d['money'].strip('\t'))                  # 成交金额

        flt = {'date': data.date}
        collection.update_one(flt, {'$set':data.__dict__}, upsert=True) 
    
    print u'插入完毕，耗时：%s' % (time()-start)

def GetFileList(dirs, fileList):
    import os
    newDir = dirs
    if os.path.isfile(dirs):
        fileList.append(dirs.decode('gbk'))
    elif os.path.isdir(dirs):  
        for s in os.listdir(dirs):
            newDir=os.path.join(dirs,s)
            GetFileList(newDir, fileList)  
    return fileList

if __name__ == '__main__':
    #code = '000001'
    #insertDayMData(code)
    Filelist = GetFileList('Data\index data', [])
    i = 0
    #f = 'Data\stock data\sh600009.csv'
    #reader = csv.DictReader(codecs.open(f))

    for e in Filelist:
        #print(e[-12:-4])
        code = e[-12:-4]
        print code
        #print e
        insertIndexDayMData(code,e)
        #print reader
        
        i = i+1
        if i > 4:
            break

    
 


