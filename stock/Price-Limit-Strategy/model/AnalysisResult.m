%对策略下单记录进行分析，并计算pnl
%输入数据 ResultFile 策略下单记录文件名
%输出数据 RetuenValue 交易日时间序列和累计收益数据 2*n的矩阵
function [RetuenValue] = AnalysisResult(ResultFile)
load(ResultFile);
Rec = StrategyRec;  %存储的变量名
n = length(Rec);
pnl_array = [];
sum_value = 0;
date_seq = 0;
buycost = 0.0003;    %买入手续费
sellcost = 0.0013;   %卖出手续费率
slip = 0.001;        %滑点

for i = 1:2:n
    if(isstruct(Rec{i+1})==0)
        continue
    else
        pnl = (Rec{i+1}.Price-Rec{i}.Price)-Rec{i}.Price*(buycost+slip)-Rec{i+1}.Price*(sellcost+slip);
        %剔除稀释的股票,股本增加，股价下降
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

%对同一日期不同股票的收益数据进行合并
data(:,1) = floor(data(:,1));
[C,IA,IC] = unique(data(:,1),'sorted');
len = length(C);
pnldata = zeros(len,2);
for i = 1:len
    d = find(data(:,1)==C(i));
    pnldata(i,1) = C(i);
    %然后相加对应第二列的数值
    pnldata(i,2) = sum(data(d,2));
end

accpnl = cumsum(pnldata(:,2));
result = [pnldata(:,1),accpnl];
RetuenValue = result;
end


