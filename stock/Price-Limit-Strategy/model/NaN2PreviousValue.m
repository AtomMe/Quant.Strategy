%清洗NAN值的数据，原则：NaN取前一分钟数据，如果第一个数据为NaN,令第一个数据为前日收盘价

function [value] = NaN2PreviousValue(data,pre_close)
    index = find(isnan(data)); %返回nan值的行索引
    
    %如果第一个数据都为nan的话，令第一个数据值为前日收盘价
    if isempty(index) == 0 && index(1) == 1
        data(1) = pre_close;
        index(1) = [];
    end
    n = length(index);
    for i = 1:n
        temp = index(i);
        data(temp) = data(temp-1);
    end
    value = data;
end