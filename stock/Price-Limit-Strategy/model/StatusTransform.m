%������״̬����ת��Ϊ0 1���� 1��ʾ���� 0�޽���
function [Status] = StatusTransform(status_data,n)
status_array = zeros(1,n);
for i = 1:n
    status_array(i) = isequal(status_data{i},'����');
end
Status = status_array;
end