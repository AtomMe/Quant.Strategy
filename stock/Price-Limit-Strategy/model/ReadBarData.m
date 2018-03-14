%��ȡ�ض����ڵ��ض���Ʊ�����������
%������� code��Ʊ���� datenum�������� pre_close ǰ���������̼�
%�������� bardata��ʱ�����к����̼���ɵ�n*2�ľ���

function [bardata] = ReadBarData(code,datenum,pre_close)
    %��ȡ������Ʊ������
    codeFilename = Code2Filename(code);
    filename = fullfile('Data','Bar',strcat(codeFilename,'.mat'));
    load(filename);
    timedata =  bar(:,1);       %.mat�����У��洢�ı�������Ϊbar
    index = find((timedata>= datenum)&(timedata<datenum+1)); %����datenum�����յ�������
    time_data = bar(index,1);
    price_data = bar(index,2);
    data = NaN2PreviousValue(price_data,pre_close); %����NaN������
    bardata = [time_data,data];
end