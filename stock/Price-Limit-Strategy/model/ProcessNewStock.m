%% ��ȡ�������ݻ�������

clc, clear, close all
%% ����Wind���ݽӿ�
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
stimenum = datenum(stime);
tradeDaycnt = w.tdayscount(stime,etime);
load StockIPODate.mat
codesSet = ipo_data.Date;
codes_cnt = length(codesSet);
%% ��ȡ��������
disp('���ڻ�ȡ��������');
tic
NewStockTradeDayStatus = ones(codes_cnt,tradeDaycnt);%��Ʊ����״̬����
for i=1:codes_cnt % 1:2790
    % ��ù�Ʊ��������
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
% ��������
t1=toc;
disp(['��ȡ�������ݵ�ʱ��:' num2str(t1)]);



