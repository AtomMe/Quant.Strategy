%将交易状态矩阵转换为0 1矩阵 1表示交易 0无交易
function [Status] = StatusTransform(status_data,n)
status_array = zeros(1,n);
for i = 1:n
    status_array(i) = isequal(status_data{i},'交易');
end
Status = status_array;
end