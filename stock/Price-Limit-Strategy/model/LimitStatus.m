%判断涨停类型，0为封死涨停板，1为正常涨停
%输入数据 bardata 分钟数据  Pclose今日收盘价
%输出数据 涨停类型
function [result] = LimitStatus(bardata,Pclose)
    barlen = length(bardata);
    Limit_Seq = find(bardata == Pclose);%涨停时间序列
    Seq_N = length(Limit_Seq);
    Diff = zeros(Seq_N-1,1); %涨停之间的时间序列差值集合
    
    for i = 1:Seq_N-1
        Diff = Limit_Seq(i+1) - Limit_Seq(i);%两个涨停之间的时间序列差
    end
    if (ismember(0,Diff == 1) == 1)
        result = 1;
    else
        result = 0;
    end
end