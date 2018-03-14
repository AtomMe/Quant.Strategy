%�Բ����µ���¼���з�����������pnl
%�������� ResultFile �����µ���¼�ļ���
%������� RetuenValue ������ʱ�����к��ۼ��������� 2*n�ľ���
function [RetuenValue] = AnalysisResult(ResultFile)
load(ResultFile);
Rec = StrategyRec;  %�洢�ı�����
n = length(Rec);
pnl_array = [];
sum_value = 0;
date_seq = 0;
buycost = 0.0003;    %����������
sellcost = 0.0013;   %������������
slip = 0.001;        %����

for i = 1:2:n
    if(isstruct(Rec{i+1})==0)
        continue
    else
        pnl = (Rec{i+1}.Price-Rec{i}.Price)-Rec{i}.Price*(buycost+slip)-Rec{i+1}.Price*(sellcost+slip);
        %�޳�ϡ�͵Ĺ�Ʊ,�ɱ����ӣ��ɼ��½�
        if(pnl/Rec{i}.Price < -0.2)
            continue
        end
        sum_value = sum_value + pnl;
        pnl_array = [pnl_array,sum_value];
        date_seq = date_seq + 1;
        data(date_seq,1) = Rec{i+1}.Datenum;
        data(date_seq,2) = pnl;
    end
end

%��ͬһ���ڲ�ͬ��Ʊ���������ݽ��кϲ�
data(:,1) = floor(data(:,1));
[C,IA,IC] = unique(data(:,1),'sorted');
len = length(C);
pnldata = zeros(len,2);
for i = 1:len
    d = find(data(:,1)==C(i));
    pnldata(i,1) = C(i);
    %Ȼ����Ӷ�Ӧ�ڶ��е���ֵ
    pnldata(i,2) = sum(data(d,2));
end

accpnl = cumsum(pnldata(:,2));
result = [pnldata(:,1),accpnl];
RetuenValue = result;
end


