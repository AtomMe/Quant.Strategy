%1.�����Ʊ�������ڲ�����Ϊmat���ݸ�ʽ��һ������޳��¹�
[~,ipo_date,~] =  xlsread('stock data.xlsx');
ipo_data.Code = {ipo_date{2:end,1}};
ipo_data.Date = {ipo_date{2:end,2}};
save StockIPODate ipo_data