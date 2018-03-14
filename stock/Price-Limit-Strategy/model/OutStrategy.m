%�˳����� ������ڶ����˳� method1.���۵Ϳ�һ�����������볡
%method2.���̺�10:30�볡
%method3.�����̺������ͣ������һ���������˳�
%���������code ��Ʊ���� datenum �������������� Pclose �ù�Ʊ�����̼����� Plimit �ù�Ʊ����ͣ������
%index �������Ӧ����������ֵ
%��������� stime �˳���ʱ�� price �˳��ǵļ۸� status 0�볡 2���й�Ʊ

function [status,stime,price] = OutStrategy(code,datenum,Pclose,Plimit,index)
timestamp = 0.4375;     %10:30��ʱ������
OpenlowRate = 0.035;    %���̾��۵Ϳ�����
pre_close = Pclose(index-1);
bardata = ReadBarData(code,datenum,pre_close);
pricedata = bardata(:,2);
timedata = bardata(:,1);
bidPrice = pricedata(1);%����ǰ���ۼ۸�

if  (bidPrice <= (1-OpenlowRate)*pre_close)
    stime = timedata(1);
    price = bidPrice;
    status = 0;
else
    timeindex = find((timedata>= datenum)&(timedata<=datenum+timestamp)); %���̵�10:30����������
    
    %10:30������ͣ����ȴ�����ͣ����������������ͣ��������
    if(abs(pricedata(timeindex(end)) - Plimit(index))) < 0.01
        leftdata = pricedata(length(timeindex):end);
        lefttime = timedata(length(timeindex):end);
        unlimitindex = find(abs(leftdata-Plimit(index)) > 0.01);%δ��ͣ��������
        if isempty(unlimitindex) == 1
            price = 0;
            stime = 0;
            status = 2;
        else
            price = leftdata(unlimitindex(1));
            stime = lefttime(unlimitindex(1));
            status = 0;
        end
    %��10:30δ��ֱͣ������
    else
        price = pricedata(timeindex(end));
        stime = timedata(timeindex(end));
        status = 0;
    end
end
end