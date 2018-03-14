%% ��ȡ�������ݻ�������

clc, clear, close all
%% ����Wind���ݽӿ�
w=windmatlab;
w.menu;
stime = '2016-01-20';
etime = '2017-10-12';
load setDiff.mat
codesSet = inter;
codes_cnt = length(codesSet);
%% ��ȡ��������
disp('���ڻ�ȡ��������');
tic
for i=1:codes_cnt % 1:2790
    % ��ù�Ʊ��������
    code = codesSet{i}
    [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(code,'open,high,low,close,pre_close,volume', stime,etime);
    cdata=wdata;
    limit_price = cdata(:,end-1)*(1+0.1);
    cdata = [cdata,limit_price];
    % ��������
    table_name=Code2Filename(code);
    save(['Data\Daily\',table_name], 'cdata');
    clear code wdata wcodes wfields wtimes werrorid wreqidd1 name_t table_name
end

t1=toc;
disp(['��ȡ�������ݵ�ʱ��:' num2str(t1)]);



