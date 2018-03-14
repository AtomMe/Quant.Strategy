%分析策略下单结果，并统计分析
%输出 一个Report包括三幅图1.权益曲线图2.历史回撤3.交易盈亏直方图，一个测试报告的xslx表格

ResultFile = 'StrategyOneRec';          %存储策略下单记录的文件名
RetuenValue = AnalysisResult(ResultFile);
marketvalue = RetuenValue(:,2);

%% 计算每个交易日收益
NetMargin = zeros(length(marketvalue),1);
NetMargin(1) = marketvalue(1);
for i=2:length(marketvalue)
    NetMargin(i) = marketvalue(i)-marketvalue(i-1);
end

%% 计算最大回撤  没有初始资金的最大回撤率
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

%% 图形展示
dirPath = [cd, '\Report\'];
if ~exist(dirPath)
    mkdir(dirPath);
end
%权益曲线
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
plot(marketvalue,'r','LineWidth',2);
hold on;
area(marketvalue,'FaceColor','g');
axis([1 length(marketvalue) min(marketvalue) max(marketvalue)]);
xlabel('时间(交易日)');
ylabel('动态权益(元)');
title('权益曲线图');
hold off;
saveas(gcf, [dirPath, '权益曲线图.png']);

%回撤曲线
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
plot(MaxDrawD,'b');
axis([1 length(MaxDrawD) min(MaxDrawD) max(MaxDrawD)]);
xlabel('时间（交易日）');
ylabel('回撤比例');
title('历史回撤');
saveas(gcf, [dirPath, '历史回撤.png']);

%交易盈亏直方图
RecLength = length(marketvalue);
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
hist(NetMargin(1:RecLength),50);
xlabel('盈亏');
ylabel('频率');
title('交易盈亏直方图');
saveas(gcf, [dirPath, '交易盈亏直方图.png']);

%% 自动创建测试报告(输出到excel)
%% 输出交易汇总
TradeSum = cell(25,2);

RowNum = 1;
ColNum = 1;
TradeSum{RowNum,1} = '统计指标';
TradeSum{RowNum,2} = '全部交易';
%净利润
ProfitTotal=sum(NetMargin);
RowNum = 2;
TradeSum{RowNum,1} = '净利润';
TradeSum{RowNum,2} = ProfitTotal;
%总盈利
WinTotal=sum(NetMargin(NetMargin>0));
RowNum = 3;
TradeSum{RowNum,1} = '总盈利';
TradeSum{RowNum,2} = WinTotal;
%总亏损
LoseTotal=sum(NetMargin(NetMargin<0));
RowNum = 4;
TradeSum{RowNum,1} = '总亏损';
TradeSum{RowNum,2} = LoseTotal;
%总盈利/总亏损
WinTotalDLoseTotal=abs(WinTotal/LoseTotal);
RowNum = 5;
TradeSum{RowNum,1} = '总盈利/总亏损';
TradeSum{RowNum,2} = WinTotalDLoseTotal;

%最大盈利
MaxWinTotal=max(NetMargin(NetMargin>0));
RowNum = 7;
TradeSum{RowNum,1} = '最大盈利';
TradeSum{RowNum,2} = MaxWinTotal;
%最大亏损
MaxLoseTotal=min(NetMargin(NetMargin<0));
RowNum = 8;
TradeSum{RowNum,1} = '最大亏损';
TradeSum{RowNum,2} = MaxLoseTotal;
%最大盈利/总盈利
RowNum = 9;
TradeSum{RowNum,1} = '最大盈利/总盈利';
TradeSum{RowNum,2} = MaxWinTotal/WinTotal;
%最大亏损/总亏损
RowNum = 10;
TradeSum{RowNum,1} = '最大亏损/总亏损';
TradeSum{RowNum,2} = MaxLoseTotal/LoseTotal;
%净利润/最大亏损
RowNum = 11;
TradeSum{RowNum,1} = '净利润/最大亏损';
TradeSum{RowNum,2} = ProfitTotal/MaxLoseTotal;
%夏普比率(按年算)
RiskLess = 0.035;
RowNum = 12;
TradeSum{RowNum,1} = '夏普比率(按年度算,%)';
TradeSum{RowNum,2} = (mean(NetMargin)*250-RiskLess)/(std(NetMargin)*sqrt(250));
%最大回撤比例
RowNum = 13;
TradeSum{RowNum,1} = '最大回撤比例(%)';
TradeSum{RowNum,2} = max(MaxDrawD)*100;
%% 交易汇总整体写入Excel
filename = '测试报告.xlsx';
filePath = [cd,'\Report\',filename];
if exist(filePath,'file')
    delete(filePath);
end
sheetName = '交易汇总';
[status,msg] = xlswrite(filePath,TradeSum,sheetName);

