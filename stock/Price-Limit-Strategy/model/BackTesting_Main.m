
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%主函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%回测变量设置
clc, clear, close all
w=windmatlab;
stime = '2016-01-20';                   %回测开始时间
etime = '2017-10-12';                   %回测结束时间
load Data\StockIPODate.mat              %加载股票列表及上市时间
load Data\FinalTradeStatus.mat          %加载所有股票交易状态
load Data\StrategyPeriod.mat            %策略的交易日时间序列
codesSet = ipo_data.Code;               %股票列表
ipo_dateSet = ipo_data.Date;            %股票上市时间
codes_cnt = length(codesSet);           %股票个数
StrategyRec = {};                       %策略1交易记录cell 时间 收盘价 方向
StrategyRecCnt = 0;                     %策略1交易次数
StrategyTwoRec = {};                    %策略2交易记录cell 时间 收盘价 方向
StrategyTwoRecCnt = 0;                  %策略2交易次数
StrategyThreeRec = {};                  %策略3交易记录cell 时间 收盘价 方向
StrategyThreeRecCnt = 0;                %策略3交易次数


%%%回测策略参数选择%%%
Run_Strategy = 1;                       %选择回测哪个策略 1 策略1   2 策略2   3 策略3


tradeDaycnt = w.tdayscount(stime,etime);%策略回测时间（交易日）段长度
returnlimit_cnt = 0;                    %涨停后回调再涨停次数
all_limit_cnt = 0;                      %涨停封死次数


for i = 1:codes_cnt
    code = codesSet{i}                 %股票代码
    
    code_trade_status = FinalTradeStatus(i,:);%股票回测时间内交易状态 1为可交易
    
    %判断股票在回测交易日内是否都不可交易
    if ismember(1,code_trade_status) == 0
        continue
    end
    
    %获取股票日数据
    codeFilename = Code2Filename(code);
    filename = fullfile('Data','Daily',strcat(codeFilename,'.mat'));
    load(filename);
    Pclose = cdata(:,4);    %每日收盘价
    PLimit  = cdata(:,7);   %每日涨停价

    strade = find(code_trade_status == 1);
    strade = strade(1);                     %第一个合法交易日（去除新股、ST股票以及停牌股票）
    
    Strategy_one_status = 0;                %策略1的状态 1准备进场 2已经进场 0离场
    Strategy_two_status = 0;                %策略2的状态 1准备进场 2已经进场 0离场
    Strategy_two_continue_limit = 0;        %策略2连续涨停次数
    Strategy_two_continue_date = 0;         %策略2上次涨停日期
    Strategy_three_status = 0;              %策略3的状态 1准备进场 2已经进场 0离场
    Strategy_three_continue_limit = 0;      %策略3连续触发涨停次数
    Strategy_three_continue_date = 0;       %策略3上次触发涨停日期

    for k = strade:tradeDaycnt
        
        %前收盘价
        if k == 1
            pre_close = Pclose(1);
        else
            pre_close = Pclose(k-1);
        end
        
        %% 策略1实现
        %策略1进场
        if Strategy_one_status == 1 && Run_Strategy == 1
            trade_date = w_tdays_data{k};       %交易日日期
            trade_datenum = w_tdays_times(k);   %交易日日期数字
            [Strategy_one_status,trade_time,trade_price] = InStrategy_One(code,trade_datenum,PLimit(k),pre_close);
            if Strategy_one_status == 2
                StrategyRecCnt = StrategyRecCnt + 1;
                %如果当前为偶数，说明上个股票最后多头仓位未平
                if mod(StrategyRecCnt,2) == 0
                    StrategyRecCnt = StrategyRecCnt + 1;
                end
                %下单记录
                StrategyRec{StrategyRecCnt}.Code = code;
                StrategyRec{StrategyRecCnt}.Datenum = trade_time;
                StrategyRec{StrategyRecCnt}.Datestr = datestr(trade_time);
                StrategyRec{StrategyRecCnt}.Price = trade_price;
                StrategyRec{StrategyRecCnt}.Direction = 'long';
                
            end
            continue
        end
        %策略1离场
        if Strategy_one_status == 2 && Run_Strategy == 1
            trade_date = w_tdays_data{k};       %交易日日期
            trade_datenum = w_tdays_times(k);   %交易日日期数字
            [Strategy_one_status,trade_time,trade_price] = OutStrategy(code,trade_datenum,Pclose,PLimit,k);
            if Strategy_one_status == 0
                StrategyRecCnt = StrategyRecCnt + 1;
                StrategyRec{StrategyRecCnt}.Code = code;
                StrategyRec{StrategyRecCnt}.Datenum = trade_time;
                StrategyRec{StrategyRecCnt}.Datestr = datestr(trade_time);
                StrategyRec{StrategyRecCnt}.Price = trade_price;
                StrategyRec{StrategyRecCnt}.Direction = 'short';
                
            end
            continue
        end
        
        
        %% 策略2实现
        if Strategy_two_status == 1 && Run_Strategy == 2
            trade_date = w_tdays_data{k};       %交易日日期
            trade_datenum = w_tdays_times(k);   %交易日日期数字
            [Strategy_two_status,trade_time,trade_price] = InStrategy_Two(code,trade_datenum,PLimit(k),pre_close,Pclose,k);
            if Strategy_two_status == 2
                StrategyTwoRecCnt = StrategyTwoRecCnt + 1;
                %如果当前为偶数，说明上个股票最后一个仓位未平
                if mod(StrategyTwoRecCnt,2) == 0
                    StrategyTwoRecCnt = StrategyTwoRecCnt + 1;
                end
                StrategyTwoRec{StrategyTwoRecCnt}.Code = code;
                StrategyTwoRec{StrategyTwoRecCnt}.Datenum = trade_time;
                StrategyTwoRec{StrategyTwoRecCnt}.Datestr = datestr(trade_time);
                StrategyTwoRec{StrategyTwoRecCnt}.Price = trade_price;
                StrategyTwoRec{StrategyTwoRecCnt}.Direction = 'long';
                
            end
            continue
        end
        
        if Strategy_two_status == 2 && Run_Strategy ==2 
            trade_date = w_tdays_data{k};       %交易日日期
            trade_datenum = w_tdays_times(k);   %交易日日期数字
            [Strategy_two_status,trade_time,trade_price] = OutStrategy(code,trade_datenum,Pclose,PLimit,k);
            if Strategy_two_status == 0
                StrategyTwoRecCnt = StrategyTwoRecCnt + 1;
                StrategyTwoRec{StrategyTwoRecCnt}.Code = code;
                StrategyTwoRec{StrategyTwoRecCnt}.Datenum = trade_time;
                StrategyTwoRec{StrategyTwoRecCnt}.Datestr = datestr(trade_time);
                StrategyTwoRec{StrategyTwoRecCnt}.Price = trade_price;
                StrategyTwoRec{StrategyTwoRecCnt}.Direction = 'short';
                Strategy_two_continue_limit = 0; %连续涨停次数归零
                
            end
            continue
        end
        
         %% 策略3实现
        if Strategy_three_status == 1 && Run_Strategy == 3
            trade_date = w_tdays_data{k};       %涨停交易日日期
            trade_datenum = w_tdays_times(k);   %涨停交易日日期数字
            [Strategy_three_status,trade_time,trade_price] = InStrategy_Three(code,trade_datenum,PLimit(k),pre_close,Pclose,k);
            if Strategy_three_status == 2
                StrategyThreeRecCnt = StrategyThreeRecCnt + 1;
                %如果当前为偶数，说明上个股票最后一个仓位未平
                if mod(StrategyThreeRecCnt,2) == 0
                    StrategyThreeRecCnt = StrategyThreeRecCnt + 1;
                end
                StrategyThreeRec{StrategyThreeRecCnt}.Code = code;
                StrategyThreeRec{StrategyThreeRecCnt}.Datenum = trade_time;
                StrategyThreeRec{StrategyThreeRecCnt}.Datestr = datestr(trade_time);
                StrategyThreeRec{StrategyThreeRecCnt}.Price = trade_price;
                StrategyThreeRec{StrategyThreeRecCnt}.Direction = 'long';
                
            end
            continue
        end
        
        if Strategy_three_status == 2 && Run_Strategy ==3 
            trade_date = w_tdays_data{k};       %交易日日期
            trade_datenum = w_tdays_times(k);   %交易日日期数字
            [Strategy_three_status,trade_time,trade_price] = OutStrategy(code,trade_datenum,Pclose,PLimit,k);
            if Strategy_three_status == 0
                StrategyThreeRecCnt = StrategyThreeRecCnt + 1;
                StrategyThreeRec{StrategyThreeRecCnt}.Code = code;
                StrategyThreeRec{StrategyThreeRecCnt}.Datenum = trade_time;
                StrategyThreeRec{StrategyThreeRecCnt}.Datestr = datestr(trade_time);
                StrategyThreeRec{StrategyThreeRecCnt}.Price = trade_price;
                StrategyThreeRec{StrategyThreeRecCnt}.Direction = 'short';
                Strategy_three_continue_limit = 0; %连续触发涨停次数归零
               
            end
            continue
        end
        
        
       %% 策略实现主体部分
        
        %绝对值小于0.01是由于涨停价用10%算出来的，理论涨停价和涨停板收盘价可能有些许差别
        %以下情况都为收盘涨停情况
        if abs(Pclose(k)-PLimit(k)) < 0.01
           limit_date = w_tdays_data{k};                        %涨停交易日日期
           limit_datenum = w_tdays_times(k);                    %涨停交易日日期数字
           bardata = ReadBarData(code,limit_datenum,pre_close); %获取股票当日分钟级别数据
           if(isempty(bardata))
               continue
           end
           limitStatus = LimitStatus(bardata(:,2),Pclose(k));   %判断涨停类型 0封死涨停 1涨停后回落再涨停
           
           %涨停后回落再涨停
           if limitStatus == 1
               returnlimit_cnt = returnlimit_cnt + 1;
           %封死涨停
           else
               Strategy_one_status = 1;         %策略1 准备进场
               all_limit_cnt = all_limit_cnt + 1;
           end
           
           %判断策略2的连续涨停次数
           Strategy_two_continue_limit_times = 3;%连续涨停次数
           if (Strategy_two_continue_limit > 0) && Run_Strategy ==2 && (Strategy_two_continue_date == datenum(w.tdaysoffset(-1,limit_datenum)))
                Strategy_two_continue_limit = Strategy_two_continue_limit+1;
                Strategy_two_continue_date = limit_datenum;
                if(Strategy_two_continue_limit == Strategy_two_continue_limit_times)
                    Strategy_two_status = 1;
                end
           else
               Strategy_two_continue_limit = 1;
               Strategy_two_continue_date = limit_datenum;
           end
        end
        
        %以下情况为触发涨停情况
        daynum = w_tdays_times(k);
        Strategy_three_continue_limit_times = 3;%连续触发涨停次数
        triggeredLimitStatus = triggeredLimit(code,daynum,PLimit(k),pre_close);
        if(triggeredLimitStatus == 1) && Run_Strategy ==3
            if (Strategy_three_continue_limit > 0) && (Strategy_three_continue_date == datenum(w.tdaysoffset(-1,daynum)))
                Strategy_three_continue_limit = Strategy_three_continue_limit+1;
                Strategy_three_continue_date = daynum;
                if(Strategy_three_continue_limit == Strategy_three_continue_limit_times)
                    Strategy_three_status = 1;
                end
            else
                Strategy_three_continue_limit = 1;
                Strategy_three_continue_date = daynum;
            end
        end
    end
end
