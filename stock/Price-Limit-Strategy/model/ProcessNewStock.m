%% 获取交易数据基本数据

clc, clear, close all
%% 启动Wind数据接口
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
stimenum = datenum(stime);
tradeDaycnt = w.tdayscount(stime,etime);
load StockIPODate.mat
codesSet = ipo_data.Date;
codes_cnt = length(codesSet);
%% 获取深市数据
disp('正在获取深市数据');
tic
NewStockTradeDayStatus = ones(codes_cnt,tradeDaycnt);%股票交易状态矩阵
for i=1:codes_cnt % 1:2790
    % 获得股票交易数据
    code = codesSet{i};
    date = datenum(code);
    if date > stimenum
        index = w.tdayscount(stime,code) + 30;
        if index > tradeDaycnt
            index = tradeDaycnt;
        end
    else
        index = -w.tdayscount(code,stime) + 30;
    end
    if index > 0
        NewStockTradeDayStatus(i,1:index) = 0;
    else
        continue
    end
    clear index code date
end
% 保存数据
t1=toc;
disp(['获取深市数据的时间:' num2str(t1)]);



