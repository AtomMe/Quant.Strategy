# -*- coding: utf-8 -*-
'''
Created on 2016/2/14

@author: tang
'''
import csv

class DataInfo:
    def __init__(self,currentDate):
        ####input
        self.currentDate = currentDate
        ####output
        self.csvArr = self.csvArrGet()
    
    #  
    def csvArrGet(self):
        f = open(self.currentDate, 'rb')
        reader = csv.reader(f)
        arr = []

        for row in reader:
            arr.append(row)
             
        return arr
     
   
    def volGet(self):
        listVolName = []
        listVol = []
        for i in range(6,26):
            print self.csvArr[i][3]
            listVolName.append(self.csvArr[i][3])
            listVol.append(self.csvArr[i][4])
             
        Vol = []
        Vol.append(listVolName)
        Vol.append(listVol)
        return Vol
     
      
    def longGet(self):
        listlongName = []
        listlong = []
        for i in range(6,26):
            listlongName.append(self.csvArr[i][6])
            listlong.append(self.csvArr[i][7])
             
        Long = []
        Long.append(listlongName)
        Long.append(listlong)
        return Long
     
  
    def shortGet(self):
        listshortName = []
        listshort = []
        for i in range(6,26):
            listshortName.append(self.csvArr[i][9])
            listshort.append(self.csvArr[i][10])
             
        Short = []
        Short.append(listshortName)
        Short.append(listshort)
        return Short
    
     #当天持仓量
    def unclearVolGet(self):
        unclearVol = 0
        unclearVol = int(self.csvArr[1][3])
        return unclearVol
     #当天成交量
    def unclearHoldGet(self):
        unclearHold = 0
        unclearHold = int(self.csvArr[1][5])*2
        return unclearHold