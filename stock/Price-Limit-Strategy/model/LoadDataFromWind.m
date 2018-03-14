%% 获取交易数据基本数据

clc, clear, close all
%% 启动Wind数据接口
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
load setDiff.mat
codesSet = inter;
codes_cnt = length(codesSet);
%% 获取深市数据
disp('正在获取深市数据');
tic
for i=1:codes_cnt % 1:2790
    % 获得股票交易数据
    code = codesSet{i}
    [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(code,'open,high,low,close,pre_close,volume', stime,etime);
    cdata=wdata;
    limit_price = cdata(:,end-1)*(1+0.1);
    cdata = [cdata,limit_price];
    % 保存数据
    table_name=Code2Filename(code);
    save(['Data\Daily\',table_name], 'cdata');
    clear code wdata wcodes wfields wtimes werrorid wreqidd1 name_t table_name
end

t1=toc;
disp(['获取深市数据的时间:' num2str(t1)]);



