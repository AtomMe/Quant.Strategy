%���������µ��������ͳ�Ʒ���
%��� һ��Report��������ͼ1.Ȩ������ͼ2.��ʷ�س�3.����ӯ��ֱ��ͼ��һ�����Ա����xslx���

ResultFile = 'StrategyOneRec';          %�洢�����µ���¼���ļ���
RetuenValue = AnalysisResult(ResultFile);
marketvalue = RetuenValue(:,2);

%% ����ÿ������������
NetMargin = zeros(length(marketvalue),1);
NetMargin(1) = marketvalue(1);
for i=2:length(marketvalue)
    NetMargin(i) = marketvalue(i)-marketvalue(i-1);
end

%% �������س�  û�г�ʼ�ʽ�����س���
MaxDrawD = zeros(length(marketvalue),1);
maxMoney = 1;
for t = 1:length(marketvalue)
    if maxMoney < marketvalue(t)
        MaxDrawD(t) = 0;
        maxMoney = marketvalue(t);
    else
        MaxDrawD(t) = (marketvalue(t)-maxMoney)/maxMoney; 
    end
end
MaxDrawD = abs(MaxDrawD);

%% ͼ��չʾ
dirPath = [cd, '\Report\'];
if ~exist(dirPath)
    mkdir(dirPath);
end
%Ȩ������
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
plot(marketvalue,'r','LineWidth',2);
hold on;
area(marketvalue,'FaceColor','g');
axis([1 length(marketvalue) min(marketvalue) max(marketvalue)]);
xlabel('ʱ��(������)');
ylabel('��̬Ȩ��(Ԫ)');
title('Ȩ������ͼ');
hold off;
saveas(gcf, [dirPath, 'Ȩ������ͼ.png']);

%�س�����
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
plot(MaxDrawD,'b');
axis([1 length(MaxDrawD) min(MaxDrawD) max(MaxDrawD)]);
xlabel('ʱ�䣨�����գ�');
ylabel('�س�����');
title('��ʷ�س�');
saveas(gcf, [dirPath, '��ʷ�س�.png']);

%����ӯ��ֱ��ͼ
RecLength = length(marketvalue);
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
hist(NetMargin(1:RecLength),50);
xlabel('ӯ��');
ylabel('Ƶ��');
title('����ӯ��ֱ��ͼ');
saveas(gcf, [dirPath, '����ӯ��ֱ��ͼ.png']);

%% �Զ��������Ա���(�����excel)
%% ������׻���
TradeSum = cell(25,2);

RowNum = 1;
ColNum = 1;
TradeSum{RowNum,1} = 'ͳ��ָ��';
TradeSum{RowNum,2} = 'ȫ������';
%������
ProfitTotal=sum(NetMargin);
RowNum = 2;
TradeSum{RowNum,1} = '������';
TradeSum{RowNum,2} = ProfitTotal;
%��ӯ��
WinTotal=sum(NetMargin(NetMargin>0));
RowNum = 3;
TradeSum{RowNum,1} = '��ӯ��';
TradeSum{RowNum,2} = WinTotal;
%�ܿ���
LoseTotal=sum(NetMargin(NetMargin<0));
RowNum = 4;
TradeSum{RowNum,1} = '�ܿ���';
TradeSum{RowNum,2} = LoseTotal;
%��ӯ��/�ܿ���
WinTotalDLoseTotal=abs(WinTotal/LoseTotal);
RowNum = 5;
TradeSum{RowNum,1} = '��ӯ��/�ܿ���';
TradeSum{RowNum,2} = WinTotalDLoseTotal;

%���ӯ��
MaxWinTotal=max(NetMargin(NetMargin>0));
RowNum = 7;
TradeSum{RowNum,1} = '���ӯ��';
TradeSum{RowNum,2} = MaxWinTotal;
%������
MaxLoseTotal=min(NetMargin(NetMargin<0));
RowNum = 8;
TradeSum{RowNum,1} = '������';
TradeSum{RowNum,2} = MaxLoseTotal;
%���ӯ��/��ӯ��
RowNum = 9;
TradeSum{RowNum,1} = '���ӯ��/��ӯ��';
TradeSum{RowNum,2} = MaxWinTotal/WinTotal;
%������/�ܿ���
RowNum = 10;
TradeSum{RowNum,1} = '������/�ܿ���';
TradeSum{RowNum,2} = MaxLoseTotal/LoseTotal;
%������/������
RowNum = 11;
TradeSum{RowNum,1} = '������/������';
TradeSum{RowNum,2} = ProfitTotal/MaxLoseTotal;
%���ձ���(������)
RiskLess = 0.035;
RowNum = 12;
TradeSum{RowNum,1} = '���ձ���(�������,%)';
TradeSum{RowNum,2} = (mean(NetMargin)*250-RiskLess)/(std(NetMargin)*sqrt(250));
%���س�����
RowNum = 13;
TradeSum{RowNum,1} = '���س�����(%)';
TradeSum{RowNum,2} = max(MaxDrawD)*100;
%% ���׻�������д��Excel
filename = '���Ա���.xlsx';
filePath = [cd,'\Report\',filename];
if exist(filePath,'file')
    delete(filePath);
end
sheetName = '���׻���';
[status,msg] = xlswrite(filePath,TradeSum,sheetName);

