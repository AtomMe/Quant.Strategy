# encoding: UTF-8

EMPTY_STRING = ''
EMPTY_FLOAT = 0.0
EMPTY_INT = 0

#日级别行情数据结构体
class StockDayMData(object):
    """K线数据"""

    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        self.code = EMPTY_STRING           # 代码
        self.date = None                   # 交易日期
        self.open = EMPTY_FLOAT            # 开盘价
        self.high = EMPTY_FLOAT            # 最高价
        self.low = EMPTY_FLOAT             # 最低价
        self.close = EMPTY_FLOAT           # 收盘价
        self.change = EMPTY_FLOAT          # 涨跌幅
        self.volume = EMPTY_FLOAT          # 成交量
        self.money = EMPTY_FLOAT           # 成交金额
        
        self.traded_market_value = EMPTY_FLOAT
        self.market_value =  EMPTY_FLOAT
        self.turnover = EMPTY_FLOAT
        self.adjust_price = EMPTY_FLOAT
        self.report_type = None
        self.report_date = None
        self.PE_TTM = EMPTY_FLOAT
        self.PS_TTM = EMPTY_FLOAT
        self.PC_TTM = EMPTY_FLOAT
        self.PB = EMPTY_FLOAT
        self.adjust_price_f = EMPTY_FLOAT

#z指数日级别行情数据结构体
class IndexDayMData(object):
    """K线数据"""

    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        self.code = EMPTY_STRING           # 代码
        self.date = None                   # 交易日期
        self.open = EMPTY_FLOAT            # 开盘价
        self.high = EMPTY_FLOAT            # 最高价
        self.low = EMPTY_FLOAT             # 最低价
        self.close = EMPTY_FLOAT           # 收盘价
        self.change = EMPTY_FLOAT          # 涨跌幅
        self.volume = EMPTY_FLOAT          # 成交量
        self.money = EMPTY_FLOAT           # 成交金额
        