%退场函数 进场后第二天退出 method1.竞价低开一定比率马上离场
%method2.开盘后10:30离场
%method3.若开盘后封死涨停，则下一个交易日退场
%输入变量：code 股票代码 datenum 交易日日期数字 Pclose 该股票日收盘价序列 Plimit 该股票日涨停价序列
%index 该日相对应序列中索引值
%输出变量： stime 退场的时间 price 退场是的价格 status 0离场 2持有股票

function [status,stime,price] = OutStrategy(code,datenum,Pclose,Plimit,index)
timestamp = 0.4375;     %10:30的时间数字
OpenlowRate = 0.035;    %开盘竞价低开比率
pre_close = Pclose(index-1);
bardata = ReadBarData(code,datenum,pre_close);
pricedata = bardata(:,2);
timedata = bardata(:,1);
bidPrice = pricedata(1);%开盘前竞价价格

if  (bidPrice <= (1-OpenlowRate)*pre_close)
    stime = timedata(1);
    price = bidPrice;
    status = 0;
else
    timeindex = find((timedata>= datenum)&(timedata<=datenum+timestamp)); %开盘到10:30的数据索引
    
    %10:30后若涨停，则等待打开涨停板后卖出，或封死涨停继续持有
    if(abs(pricedata(timeindex(end)) - Plimit(index))) < 0.01
        leftdata = pricedata(length(timeindex):end);
        lefttime = timedata(length(timeindex):end);
        unlimitindex = find(abs(leftdata-Plimit(index)) > 0.01);%未涨停索引序列
        if isempty(unlimitindex) == 1
            price = 0;
            stime = 0;
            status = 2;
        else
            price = leftdata(unlimitindex(1));
            stime = lefttime(unlimitindex(1));
            status = 0;
        end
    %若10:30未涨停直接卖出
    else
        price = pricedata(timeindex(end));
        stime = timedata(timeindex(end));
        status = 0;
    end
end
end