# encoding: UTF-8
from insertData2Mongo import *
from datetime import datetime

#将对应的股票csv文件命名为代码名字,便于后续的数据库的读写。
code = '000001' 
insertDayMData(code)