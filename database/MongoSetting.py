# encoding: UTF-8
def loadMongoSetting():
    """载入MongoDB数据库的配置"""
    host = 'localhost'   #数据库服务器IP地址
    port = 27017         #mongdb端口号，默认27017
        
    return host, port