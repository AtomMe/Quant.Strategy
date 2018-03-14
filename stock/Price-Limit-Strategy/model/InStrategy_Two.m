%策略二进场函数 method1.盘中突破十日均线
%              method2.盘中突破五日均线
%              method3.涨停后又回落
%输入变量：code 股票代码 datenum 交易日日期数字 daylimit 该股票日涨停价 pre_close 前收盘价 
%收盘价序列 Pclose k 该交易日对应索引
%输出变量： status 交易状态 1该日未交易 2进场交易  stime 进场的时间 price 进场是的价格

function [status,stime,price] = InStrategy_Two(code,datenum,daylimit,pre_close,Pclose,k)
    M = 10;
    N = 5;
    [mov10,mov5] = movavg2(Pclose,M,N,k,pre_close);
    
    triggeredIndex = 0;%触发涨停索引
    index = 0;%进场的数据索引值
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    timedata = bardata(:,1);
    
    datalen = length(pricedata);
    
    for i = 1:datalen
        %突破五日或者十日均线
        if abs(pricedata(i)-daylimit) < 0.01
            triggeredIndex = i;
        else
            if triggeredIndex ~= 0
                index = i;
                break;
            end
            %不在前一两分钟进行交易 i > 2
            if ((pricedata(i) > mov5) || (pricedata(i) > mov10)) && (i > 2)
                index = i;
                break;
            end
        end
    end
    
    if index == 0
        stime = 0;
        price = 0;
        status = 1;
    else
        stime = timedata(index);
        price = pricedata(index);
        status = 2;
    end
end