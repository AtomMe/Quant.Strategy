%获取特定日期的特定股票当天分钟数据
%传入参数 code股票代码 datenum日期数字 pre_close 前交易日收盘价
%返回数据 bardata由时间序列和收盘价组成的n*2的矩阵

function [bardata] = ReadBarData(code,datenum,pre_close)
    %获取单个股票日数据
    codeFilename = Code2Filename(code);
    filename = fullfile('Data','Bar',strcat(codeFilename,'.mat'));
    load(filename);
    timedata =  bar(:,1);       %.mat数据中，存储的变量命名为bar
    index = find((timedata>= datenum)&(timedata<datenum+1)); %返回datenum交易日的行索引
    time_data = bar(index,1);
    price_data = bar(index,2);
    data = NaN2PreviousValue(price_data,pre_close); %处理NaN的数据
    bardata = [time_data,data];
end