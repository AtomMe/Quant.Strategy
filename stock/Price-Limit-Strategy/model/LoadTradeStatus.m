%% ��ȡ�������ݻ�������

clc, clear, close all
%% ����Wind���ݽӿ�
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
tradeDaycnt = w.tdayscount(stime,etime);
load StockIPODate.mat
codesSet = ipo_data.Code;
codes_cnt = length(codesSet);
%% ��ȡ��������
disp('���ڻ�ȡ��������');
tic
TradeDayStatus = [];%��Ʊ����״̬����
for i=1:codes_cnt % 1:2790
    % ��ù�Ʊ��������
    code = codesSet{i}
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(code,'trade_status',stime,etime);
    status = StatusTransform(w_wsd_data,tradeDaycnt);
    TradeDayStatus = [TradeDayStatus;status];
   
    clear status code w_wsd_data w_wsd_codes w_wsd_fields w_wsd_times w_wsd_errorid w_wsd_reqid
end
% ��������
save(['Data\','TradeDayStatus'], 'TradeDayStatus');
t1=toc;
disp(['��ȡ�������ݵ�ʱ��:' num2str(t1)]);



