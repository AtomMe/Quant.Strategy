%���Զ��������� method1.����ͻ��ʮ�վ���
%              method2.����ͻ�����վ���
%              method3.��ͣ���ֻ���
%���������code ��Ʊ���� datenum �������������� daylimit �ù�Ʊ����ͣ�� pre_close ǰ���̼� 
%���̼����� Pclose k �ý����ն�Ӧ����
%��������� status ����״̬ 1����δ���� 2��������  stime ������ʱ�� price �����ǵļ۸�

function [status,stime,price] = InStrategy_Two(code,datenum,daylimit,pre_close,Pclose,k)
    M = 10;
    N = 5;
    [mov10,mov5] = movavg2(Pclose,M,N,k,pre_close);
    
    triggeredIndex = 0;%������ͣ����
    index = 0;%��������������ֵ
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    timedata = bardata(:,1);
    
    datalen = length(pricedata);
    
    for i = 1:datalen
        %ͻ�����ջ���ʮ�վ���
        if abs(pricedata(i)-daylimit) < 0.01
            triggeredIndex = i;
        else
            if triggeredIndex ~= 0
                index = i;
                break;
            end
            %����ǰһ�����ӽ��н��� i > 2
            if ((pricedata(i) > mov5) || (pricedata(i) > mov10)) && (i > 2)
                index = i;
                break;
            end
        end
    end
    
    if index == 0
        stime = 0;
        price = 0;
        status = 1;
    else
        stime = timedata(index);
        price = pricedata(index);
        status = 2;
    end
end