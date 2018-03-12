

# coding: utf-8

# In[6]:


from WindPy import w
from datetime import date

w.start()    


# In[ ]:

import pandas as pd
import numpy as np
from datetime import date
import math


def py_wsi(tickers,fields,startDt,endDt, name="", options=""):
    # If tickers is an array, only the first field will be returned.
    #print type(tickers)
    if type(tickers) <> type([]):
        temp = w.wsi(tickers,fields,startDt,endDt,options)
        dataMat = np.array(temp.Data).T
        result = pd.DataFrame(dataMat,index=temp.Times,columns=temp.Fields)
        return result
    
    if type(tickers) == type([]):
        temp = w.wsi(tickers,fields,startDt,endDt,options)
        dataMat = np.array(temp.Data).T
        result = pd.DataFrame(dataMat,index=temp.Times,columns=temp.Codes)
        return result


def my_wsi(tickers,fields,startDt,endDt):
    data_all = py_wsi(tickers,fields,startDt,endDt)

    data_all['time'] = data_all.index
    data_all.index = np.arange(len(data_all))
    del_index = [] 
    for i in data_all.index:
        if math.isnan(data_all.iloc[i,0]):  
            del_index.append(i)

    data_all =  data_all.drop(del_index)
    data_all.index = np.arange(len(data_all))
    
    return data_all
	