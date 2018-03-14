%������ͣ���� 
%���������code ��Ʊ���� datenum �������������� daylimit �ù�Ʊ����ͣ�� pre_close ǰ���̼� 
%��������� status 0��������ͣ 1������ͣ

function [status] = triggeredLimit(code,datenum,daylimit,pre_close)
    bardata = ReadBarData(code,datenum,pre_close);
    pricedata = bardata(:,2);
    data = pricedata - daylimit;
    data = abs(data);
    thresh = 0.01;      %�۸�����ͣ�۵����ֵ
    index = find(data < thresh);
    if(isempty(index) == 1)
        status = 0;
    else
        status = 1;
    end
end
