%�ж���ͣ���ͣ�0Ϊ������ͣ�壬1Ϊ������ͣ
%�������� bardata ��������  Pclose�������̼�
%������� ��ͣ����
function [result] = LimitStatus(bardata,Pclose)
    barlen = length(bardata);
    Limit_Seq = find(bardata == Pclose);%��ͣʱ������
    Seq_N = length(Limit_Seq);
    Diff = zeros(Seq_N-1,1); %��֮ͣ���ʱ�����в�ֵ����
    
    for i = 1:Seq_N-1
        Diff = Limit_Seq(i+1) - Limit_Seq(i);%������֮ͣ���ʱ�����в�
    end
    if (ismember(0,Diff == 1) == 1)
        result = 1;
    else
        result = 0;
    end
end