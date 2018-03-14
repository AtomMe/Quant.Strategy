%�������+��������
function [long,short] = movavg2(Pclose,M,N,k,pre_close)

CloseSet = [];%������ۼ۸�����
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

mov5 = sum(CloseSet(end-N+1:end))/N;%���վ��߼۸�
mov10 = sum(CloseSet(:))/M;%ʮ�վ��߼۸�
long = mov10;
short = mov5;

end
