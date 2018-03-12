# encoding: UTF-8
from datetime import datetime, timedelta
import pymongo
from time import time
from DayMarketDataClass import *
from MongoSetting import loadMongoSetting
import pandas as pd


#----------------------------------------------------------------------
def dbQuery(dbName, collectionName, d):

    """从MongoDB中读取数据，d是查询要求，返回的是数据库查询的指针"""
    # 读取MongoDB的设置
    host, port = loadMongoSetting()
    # 设置MongoDB操作的超时时间为0.5秒
    client = pymongo.MongoClient(host, port)        
    # 调用server_info查询服务器状态，防止服务器异常并未连接成功
    if client:
        db = client[dbName]
        collection = db[collectionName]
        cursor = collection.find(d)
        return cursor
    else:
        return None
    

#----------------------------------------------------------------------
def loadStockDayM(collectionName,field,startDate,endDate,dbName=u'STOCK_DAY_MARKET_DB'):
    """从数据库中读取日级别数据，startDate是datetime对象"""
    
    d = {'date':{'$gte':startDate,'$lte':endDate}}
    cursor = dbQuery(dbName, collectionName, d)    
    l = []
    if cursor:
        for d in cursor:
            data = StockDayMData()
            data.__dict__ = d
            if field == 'close':
                l.append(data.close)
            elif field == 'open':
                l.append(data.open)
            elif field == 'high':
                l.append(data.high)
            elif field == 'low':
                l.append(data.low)
            elif field == 'volume':
                l.append(data.volume)
            elif field == 'date':
                l.append(data.date)
            elif field == 'money':
			    l.append(data.money)
            elif field == 'code':
                l.append(data.code)
            elif field == 'change':
                l.append(data.change)
            elif field == 'traded_market_value':
                l.append(data.traded_market_value)
            elif field == 'market_value':
                l.append(data.market_value)
            elif field == 'turnover':
                l.append(data.turnover)
            elif field == 'adjust_price':
                l.append(data.adjust_price)
            elif field == 'report_type':
                l.append(data.report_type)
            elif field == 'report_date':
                l.append(data.report_date)
            elif field == 'PE_TTM':
                l.append(data.PE_TTM)
            elif field == 'PS_TTM':
                l.append(data.PS_TTM)
            elif field == 'PC_TTM':
                l.append(data.PC_TTM)
            elif field == 'PB':
                l.append(data.PB)
            elif field == 'adjust_price_f':
                l.append(data.adjust_price_f)
            else:
                print u'输入参数格式不对'
                return ''
    return l

#----------------------------------------------------------------------
def loadStockDayAllM(collectionName,startDate,endDate,dbName=u'STOCK_DAY_MARKET_DB'):
    """从数据库中读取日级别数据，startDate是datetime对象"""
    
    code = loadStockDayM(collectionName,'code',startDate,endDate) # 代码
    date = loadStockDayM(collectionName,'date',startDate,endDate)                   # 交易日期
    open = loadStockDayM(collectionName,'open',startDate,endDate)            # 开盘价
    high = loadStockDayM(collectionName,'high',startDate,endDate)            # 最高价
    low = loadStockDayM(collectionName,'low',startDate,endDate)             # 最低价
    close = loadStockDayM(collectionName,'close',startDate,endDate)           # 收盘价
    change = loadStockDayM(collectionName,'change',startDate,endDate)          # 涨跌幅
    volume = loadStockDayM(collectionName,'volume',startDate,endDate)          # 成交量
    money = loadStockDayM(collectionName,'money',startDate,endDate)           # 成交金额
        
    traded_market_value = loadStockDayM(collectionName,'traded_market_value',startDate,endDate)
    market_value =  loadStockDayM(collectionName,'market_value',startDate,endDate)
    turnover = loadStockDayM(collectionName,'turnover',startDate,endDate)
    adjust_price = loadStockDayM(collectionName,'adjust_price',startDate,endDate)
    report_type = loadStockDayM(collectionName,'report_type',startDate,endDate)
    report_date = loadStockDayM(collectionName,'report_date',startDate,endDate)
    PE_TTM = loadStockDayM(collectionName,'PE_TTM',startDate,endDate)
    PS_TTM = loadStockDayM(collectionName,'PS_TTM',startDate,endDate)
    PC_TTM = loadStockDayM(collectionName,'PC_TTM',startDate,endDate)
    PB = loadStockDayM(collectionName,'PB',startDate,endDate)
    adjust_price_f = loadStockDayM(collectionName,'adjust_price_f',startDate,endDate)
    
    df = {'code':code,'date':date,'open':open,'high':high,
          'low':low,'close':close,'change':change,'volume':volume,
          'traded_market_value':traded_market_value,'market_value':market_value,
          'turnover':turnover,'adjust_price':adjust_price,'report_type':report_type,
          'report_date':report_date,'PE_TTM':PE_TTM,'PS_TTM':PS_TTM,'PC_TTM':PC_TTM,
          'PB':PB,'adjust_price_f':adjust_price_f}

    return pd.DataFrame(df)

#----------------------------------------------------------------------
def saveStock2csv(collectionName,savefilename,startDate,endDate):
    df = loadStockDayAllM(collectionName,startDate,endDate)
    df.to_csv(savefilename)
    print u'saving finished !'

#----------------------------------------------------------------------
def loadIndexDayM(collectionName,field,startDate,endDate,dbName=u'INDEX_DAY_MARKET_DB'):
    """从数据库中读取日级别数据，startDate是datetime对象"""
    
    d = {'date':{'$gte':startDate,'$lte':endDate}}
    cursor = dbQuery(dbName, collectionName, d)    
    l = []
    if cursor:
        for d in cursor:
            data = IndexDayMData()
            data.__dict__ = d
            if field == 'close':
                l.append(data.close)
            elif field == 'open':
                l.append(data.open)
            elif field == 'high':
                l.append(data.high)
            elif field == 'low':
                l.append(data.low)
            elif field == 'volume':
                l.append(data.volume)
            elif field == 'date':
                l.append(data.date)
            elif field == 'money':
                l.append(data.money)
            elif field == 'code':
                l.append(data.code)
            elif field == 'change':
                l.append(data.change)
            else:
                print u'输入参数格式不对'
                return ''
    return l
#----------------------------------------------------------------------
def loadIndexDayAllM(collectionName,startDate,endDate,dbName=u'INDEX_DAY_MARKET_DB'):
    """从数据库中读取日级别数据，startDate是datetime对象"""
    import pandas as pd
    code = loadIndexDayM(collectionName,'code',startDate,endDate) # 代码
    date = loadIndexDayM(collectionName,'date',startDate,endDate)                   # 交易日期
    open = loadIndexDayM(collectionName,'open',startDate,endDate)            # 开盘价
    high = loadIndexDayM(collectionName,'high',startDate,endDate)            # 最高价
    low = loadIndexDayM(collectionName,'low',startDate,endDate)             # 最低价
    close = loadIndexDayM(collectionName,'close',startDate,endDate)           # 收盘价
    change = loadIndexDayM(collectionName,'change',startDate,endDate)          # 涨跌幅
    volume = loadIndexDayM(collectionName,'volume',startDate,endDate)          # 成交量
    money = loadIndexDayM(collectionName,'money',startDate,endDate)           # 成交金额
        
    df = {'code':code,'date':date,'open':open,'high':high,
          'low':low,'close':close,'change':change,'volume':volume}
    return pd.DataFrame(df)

#----------------------------------------------------------------------
def saveIndex2csv(collectionName,savefilename,startDate,endDate):
    df = loadIndexDayAllM(collectionName,startDate,endDate)
    df.to_csv(savefilename)
    print u'saving finished !'

if __name__ == '__main__':
    start = time()
    startDate =  datetime(2012, 8, 22)
    endDate =  datetime(2013, 9, 25)
    code = 'sh000001'
    code1 = 'sh000001.csv'
    #d = loadIndexDayAllM(code,startDate,endDate)
    saveIndex2csv(code,code1,startDate,endDate)
    #print d
    #for i in range(len(datetimeData)):
        #print datetimeData[i]
    #print len(datetimeData)

       

        