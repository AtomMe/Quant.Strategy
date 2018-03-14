%% 获取交易数据基本数据

clc, clear, close all
%% 启动Wind数据接口
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
tradeDaycnt = w.tdayscount(stime,etime);
load StockIPODate.mat
codesSet = ipo_data.Code;
codes_cnt = length(codesSet);
%% 获取深市数据
disp('正在获取深市数据');
tic
TradeDayStatus = [];%股票交易状态矩阵
for i=1:codes_cnt % 1:2790
    % 获得股票交易数据
    code = codesSet{i}
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(code,'trade_status',stime,etime);
    status = StatusTransform(w_wsd_data,tradeDaycnt);
    TradeDayStatus = [TradeDayStatus;status];
   
    clear status code w_wsd_data w_wsd_codes w_wsd_fields w_wsd_times w_wsd_errorid w_wsd_reqid
end
% 保存数据
save(['Data\','TradeDayStatus'], 'TradeDayStatus');
t1=toc;
disp(['获取深市数据的时间:' num2str(t1)]);



