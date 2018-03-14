%计算均价+处理数据
function [long,short] = movavg2(Pclose,M,N,k,pre_close)

CloseSet = [];%计算均价价格序列
if (k < M)
    closeSeries = Pclose;
    closeSeries = NaN2PreviousValue(closeSeries,pre_close);
    for i = 1:M
        if i <= M-k
            CloseSet(i) = closeSeries(1);
        else
            CloseSet(i) = closeSeries(i+k-M);
        end
    end
else
    closeSeries = Pclose(k-M+1:k);
    closeSeries = NaN2PreviousValue(closeSeries,pre_close);
    CloseSet = closeSeries;
end

mov5 = sum(CloseSet(end-N+1:end))/N;%五日均线价格
mov10 = sum(CloseSet(:))/M;%十日均线价格
long = mov10;
short = mov5;

end
