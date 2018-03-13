# -*- coding: utf-8 -*-
'''
Created on 2016/2/14

@author: tang
'''
import csv
import types
import math
import copy as cp
import numpy as np
import DataGet
###########################################################################################################

#    generate the its signal 

############################################################################################

class itsFutSignal:

    def __init__(self,currentDate):
        ####input
        self.currentDate = currentDate
        ####output
        self.vipDict = self.vipDictGet()
        self.sentiSig = self.sentiSigGet()
        self.inforedInvestor = self.inforedInvestorGet()
        self.uninforedInvestor = self.uninforedInvestorGet()
        self.itsSig = self.itsSigGet() 
        self.utsSig = self.utsSigGet()
        self.msdSig = self.msdSigGet()
 
    def list2Dict(self,list):

        keys = list[0]

        values = list[1]
        resultDict = {}
        
        for index in range(len(keys)):
            resultDict[keys[index]] = values[index]
            
        return resultDict
    
    def vipDictGet(self):
        ####get data
        long = DataGet.DataInfo(self.currentDate).longGet()
        short = DataGet.DataInfo(self.currentDate).shortGet()
        vol = DataGet.DataInfo(self.currentDate).volGet()
        longDict = self.list2Dict(long)
        shortDict = self.list2Dict(short)
        volDict = self.list2Dict(vol)
        leftHold = DataGet.DataInfo(self.currentDate).unclearHoldGet()
        leftVol = DataGet.DataInfo(self.currentDate).unclearVolGet() 
        ####get vip list
        vipList = []
        for index in longDict.keys():
            if index in shortDict.keys():
                if index in volDict.keys():
                    vipList.append(index)
        
        #得到剩余的成交持仓量
        for index in vipList:
            hold = int(longDict[index]) + int(shortDict[index])
            vol = int(volDict[index])
            leftHold -= hold
            leftVol -= vol
        
        ####get vip dict
        vipDict = {}
        for index in vipList:
            vipDict[index] = [longDict[index],shortDict[index],volDict[index]]
        #加一个剩余的会员单位
        vipDict['left'] = [str(leftHold/2),str(leftHold/2),str(leftVol)]
        #print(vipDict)
        return vipDict
    
    def sentiSigGet(self):
        sentiSig = {}
       # print(self.vipDict)
        for index in self.vipDict:
            #当个会员hold持仓总量
            hold = int(self.vipDict[index][0]) + int(self.vipDict[index][1])
            vol = int(self.vipDict[index][-1])
            
            sentiSig[index] = hold*1.0/vol
            #print(sentiSig[index])
        return sentiSig
    def sentiAvgGet(self):
        sentiAvg = 0
        sentiHold = 0
        sentiVol = 0
        sentiHold = DataGet.DataInfo(self.currentDate).unclearHoldGet()
        sentiVol = DataGet.DataInfo(self.currentDate).unclearVolGet()
        sentiAvg = sentiHold*1.0/sentiVol
        return sentiAvg
    
    #知情者会员名单
    def inforedInvestorGet(self):
        if len(self.sentiSig) != 0:
            sentiAvg = self.sentiAvgGet()
            inforedInvestor = [index for index in self.sentiSig if self.sentiSig[index] > sentiAvg]
            return inforedInvestor
        else:
            sentiAvg = 0
            return []
     #不知情者会员名单   
    def uninforedInvestorGet(self):
        if len(self.sentiSig) != 0:
            sentiAvg = self.sentiAvgGet()
            uninforedInvestor = [index for index in self.sentiSig if self.sentiSig[index] < sentiAvg]
            return uninforedInvestor
        else:
            sentiAvg = 0
            return []
    def itsSigGet(self):
        totalBuy = 0
        totalSell = 0
        if len(self.inforedInvestor) != 0:
            for index in self.inforedInvestor:
                totalBuy += int(self.vipDict[index][0])
                totalSell += int(self.vipDict[index][1])
            if totalBuy + totalSell != 0:
                return 1.0*(totalBuy - totalSell)/(totalBuy + totalSell)
            else:
                return 'null'
        else:
            return 'null'
    def utsSigGet(self):
        totalBuy = 0
        totalSell = 0
        if len(self.uninforedInvestor) != 0:
            for index in self.uninforedInvestor:
                totalBuy += int(self.vipDict[index][0])
                totalSell += int(self.vipDict[index][1])
            if totalBuy + totalSell != 0:
                return 1.0*(totalBuy - totalSell)/(totalBuy + totalSell)
            else:
                return 'null'
        else:
            return 'null'
    def msdSigGet(self):
        #print(self.itsSig)
        #print(self.utsSig)
        if self.itsSig == 'null':
            return 0
        else:
            return self.itsSig - self.utsSig

