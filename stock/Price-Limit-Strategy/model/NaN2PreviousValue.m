%��ϴNANֵ�����ݣ�ԭ��NaNȡǰһ�������ݣ������һ������ΪNaN,���һ������Ϊǰ�����̼�

function [value] = NaN2PreviousValue(data,pre_close)
    index = find(isnan(data)); %����nanֵ��������
    
    %�����һ�����ݶ�Ϊnan�Ļ������һ������ֵΪǰ�����̼�
    if isempty(index) == 0 && index(1) == 1
        data(1) = pre_close;
        index(1) = [];
    end
    n = length(index);
    for i = 1:n
        temp = index(i);
        data(temp) = data(temp-1);
    end
    value = data;
end