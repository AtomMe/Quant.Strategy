%����һ�������� �ﵽ��ͣ��ص���׷��
%���������code ��Ʊ���� datenum �������������� daylimit �ù�Ʊ����ͣ�� pre_close ǰ���̼�   
%��������� status ����״̬ 1����δ���� 2��������  stime ������ʱ�� price �����ǵļ۸�

function [status,stime,price] = InStrategy_One(code,datenum,daylimit,pre_close)
    triggeredIndex = 0; %������ͣ����
    index = 0;          %��������������ֵ
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    timedata = bardata(:,1);
    
    datalen = length(pricedata);
    
    %׷������
    for i = 1:datalen
        %��һ�δ�����ͣ
        if abs(pricedata(i)-daylimit) < 0.01
            triggeredIndex = i;
        else
            if triggeredIndex ~= 0
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