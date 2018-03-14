%1.处理股票发行日期并保存为mat数据格式，一遍后续剔除新股
[~,ipo_date,~] =  xlsread('stock data.xlsx');
ipo_data.Code = {ipo_date{2:end,1}};
ipo_data.Date = {ipo_date{2:end,2}};
save StockIPODate ipo_data