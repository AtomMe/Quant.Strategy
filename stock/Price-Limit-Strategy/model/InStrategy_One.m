%策略一进场函数 达到涨停后回调再追涨
%输入变量：code 股票代码 datenum 交易日日期数字 daylimit 该股票日涨停价 pre_close 前收盘价   
%输出变量： status 交易状态 1该日未交易 2进场交易  stime 进场的时间 price 进场是的价格

function [status,stime,price] = InStrategy_One(code,datenum,daylimit,pre_close)
    triggeredIndex = 0; %触发涨停索引
    index = 0;          %进场的数据索引值
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    timedata = bardata(:,1);
    
    datalen = length(pricedata);
    
    %追涨买入
    for i = 1:datalen
        %第一次触发涨停
        if abs(pricedata(i)-daylimit) < 0.01
            triggeredIndex = i;
        else
            if triggeredIndex ~= 0
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