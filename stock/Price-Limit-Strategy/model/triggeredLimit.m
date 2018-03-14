%触发涨停函数 
%输入变量：code 股票代码 datenum 交易日日期数字 daylimit 该股票日涨停价 pre_close 前收盘价 
%输出变量： status 0不触发涨停 1触发涨停

function [status] = triggeredLimit(code,datenum,daylimit,pre_close)
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    data = pricedata - daylimit;
    data = abs(data);
    thresh = 0.01;      %价格与涨停价的误差值
    index = find(data < thresh);
    if(isempty(index) == 1)
        status = 0;
    else
        status = 1;
    end
end
