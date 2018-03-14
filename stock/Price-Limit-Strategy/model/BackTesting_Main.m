
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%�ز��������
clc, clear, close all
w=windmatlab;
stime = '2016-01-20';                   %�ز⿪ʼʱ��
etime = '2017-10-12';                   %�ز����ʱ��
load Data\StockIPODate.mat              %���ع�Ʊ�б�����ʱ��
load Data\FinalTradeStatus.mat          %�������й�Ʊ����״̬
load Data\StrategyPeriod.mat            %���ԵĽ�����ʱ������
codesSet = ipo_data.Code;               %��Ʊ�б�
ipo_dateSet = ipo_data.Date;            %��Ʊ����ʱ��
codes_cnt = length(codesSet);           %��Ʊ����
StrategyRec = {};                       %����1���׼�¼cell ʱ�� ���̼� ����
StrategyRecCnt = 0;                     %����1���״���
StrategyTwoRec = {};                    %����2���׼�¼cell ʱ�� ���̼� ����
StrategyTwoRecCnt = 0;                  %����2���״���
StrategyThreeRec = {};                  %����3���׼�¼cell ʱ�� ���̼� ����
StrategyThreeRecCnt = 0;                %����3���״���


%%%�ز���Բ���ѡ��%%%
Run_Strategy = 1;                       %ѡ��ز��ĸ����� 1 ����1   2 ����2   3 ����3


tradeDaycnt = w.tdayscount(stime,etime);%���Իز�ʱ�䣨�����գ��γ���
returnlimit_cnt = 0;                    %��ͣ��ص�����ͣ����
all_limit_cnt = 0;                      %��ͣ��������


for i = 1:codes_cnt
    code = codesSet{i}                 %��Ʊ����
    
    code_trade_status = FinalTradeStatus(i,:);%��Ʊ�ز�ʱ���ڽ���״̬ 1Ϊ�ɽ���
    
    %�жϹ�Ʊ�ڻز⽻�������Ƿ񶼲��ɽ���
    if ismember(1,code_trade_status) == 0
        continue
    end
    
    %��ȡ��Ʊ������
    codeFilename = Code2Filename(code);
    filename = fullfile('Data','Daily',strcat(codeFilename,'.mat'));
    load(filename);
    Pclose = cdata(:,4);    %ÿ�����̼�
    PLimit  = cdata(:,7);   %ÿ����ͣ��

    strade = find(code_trade_status == 1);
    strade = strade(1);                     %��һ���Ϸ������գ�ȥ���¹ɡ�ST��Ʊ�Լ�ͣ�ƹ�Ʊ��
    
    Strategy_one_status = 0;                %����1��״̬ 1׼������ 2�Ѿ����� 0�볡
    Strategy_two_status = 0;                %����2��״̬ 1׼������ 2�Ѿ����� 0�볡
    Strategy_two_continue_limit = 0;        %����2������ͣ����
    Strategy_two_continue_date = 0;         %����2�ϴ���ͣ����
    Strategy_three_status = 0;              %����3��״̬ 1׼������ 2�Ѿ����� 0�볡
    Strategy_three_continue_limit = 0;      %����3����������ͣ����
    Strategy_three_continue_date = 0;       %����3�ϴδ�����ͣ����

    for k = strade:tradeDaycnt
        
        %ǰ���̼�
        if k == 1
            pre_close = Pclose(1);
        else
            pre_close = Pclose(k-1);
        end
        
        %% ����1ʵ��
        %����1����
        if Strategy_one_status == 1 && Run_Strategy == 1
            trade_date = w_tdays_data{k};       %����������
            trade_datenum = w_tdays_times(k);   %��������������
            [Strategy_one_status,trade_time,trade_price] = InStrategy_One(code,trade_datenum,PLimit(k),pre_close);
            if Strategy_one_status == 2
                StrategyRecCnt = StrategyRecCnt + 1;
                %�����ǰΪż����˵���ϸ���Ʊ����ͷ��λδƽ
                if mod(StrategyRecCnt,2) == 0
                    StrategyRecCnt = StrategyRecCnt + 1;
                end
                %�µ���¼
                StrategyRec{StrategyRecCnt}.Code = code;
                StrategyRec{StrategyRecCnt}.Datenum = trade_time;
                StrategyRec{StrategyRecCnt}.Datestr = datestr(trade_time);
                StrategyRec{StrategyRecCnt}.Price = trade_price;
                StrategyRec{StrategyRecCnt}.Direction = 'long';
                
            end
            continue
        end
        %����1�볡
        if Strategy_one_status == 2 && Run_Strategy == 1
            trade_date = w_tdays_data{k};       %����������
            trade_datenum = w_tdays_times(k);   %��������������
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
        
        
        %% ����2ʵ��
        if Strategy_two_status == 1 && Run_Strategy == 2
            trade_date = w_tdays_data{k};       %����������
            trade_datenum = w_tdays_times(k);   %��������������
            [Strategy_two_status,trade_time,trade_price] = InStrategy_Two(code,trade_datenum,PLimit(k),pre_close,Pclose,k);
            if Strategy_two_status == 2
                StrategyTwoRecCnt = StrategyTwoRecCnt + 1;
                %�����ǰΪż����˵���ϸ���Ʊ���һ����λδƽ
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
            trade_date = w_tdays_data{k};       %����������
            trade_datenum = w_tdays_times(k);   %��������������
            [Strategy_two_status,trade_time,trade_price] = OutStrategy(code,trade_datenum,Pclose,PLimit,k);
            if Strategy_two_status == 0
                StrategyTwoRecCnt = StrategyTwoRecCnt + 1;
                StrategyTwoRec{StrategyTwoRecCnt}.Code = code;
                StrategyTwoRec{StrategyTwoRecCnt}.Datenum = trade_time;
                StrategyTwoRec{StrategyTwoRecCnt}.Datestr = datestr(trade_time);
                StrategyTwoRec{StrategyTwoRecCnt}.Price = trade_price;
                StrategyTwoRec{StrategyTwoRecCnt}.Direction = 'short';
                Strategy_two_continue_limit = 0; %������ͣ��������
                
            end
            continue
        end
        
         %% ����3ʵ��
        if Strategy_three_status == 1 && Run_Strategy == 3
            trade_date = w_tdays_data{k};       %��ͣ����������
            trade_datenum = w_tdays_times(k);   %��ͣ��������������
            [Strategy_three_status,trade_time,trade_price] = InStrategy_Three(code,trade_datenum,PLimit(k),pre_close,Pclose,k);
            if Strategy_three_status == 2
                StrategyThreeRecCnt = StrategyThreeRecCnt + 1;
                %�����ǰΪż����˵���ϸ���Ʊ���һ����λδƽ
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
            trade_date = w_tdays_data{k};       %����������
            trade_datenum = w_tdays_times(k);   %��������������
            [Strategy_three_status,trade_time,trade_price] = OutStrategy(code,trade_datenum,Pclose,PLimit,k);
            if Strategy_three_status == 0
                StrategyThreeRecCnt = StrategyThreeRecCnt + 1;
                StrategyThreeRec{StrategyThreeRecCnt}.Code = code;
                StrategyThreeRec{StrategyThreeRecCnt}.Datenum = trade_time;
                StrategyThreeRec{StrategyThreeRecCnt}.Datestr = datestr(trade_time);
                StrategyThreeRec{StrategyThreeRecCnt}.Price = trade_price;
                StrategyThreeRec{StrategyThreeRecCnt}.Direction = 'short';
                Strategy_three_continue_limit = 0; %����������ͣ��������
               
            end
            continue
        end
        
        
       %% ����ʵ�����岿��
        
        %����ֵС��0.01��������ͣ����10%������ģ�������ͣ�ۺ���ͣ�����̼ۿ�����Щ����
        %���������Ϊ������ͣ���
        if abs(Pclose(k)-PLimit(k)) < 0.01
           limit_date = w_tdays_data{k};                        %��ͣ����������
           limit_datenum = w_tdays_times(k);                    %��ͣ��������������
           bardata = ReadBarData(code,limit_datenum,pre_close); %��ȡ��Ʊ���շ��Ӽ�������
           if(isempty(bardata))
               continue
           end
           limitStatus = LimitStatus(bardata(:,2),Pclose(k));   %�ж���ͣ���� 0������ͣ 1��ͣ���������ͣ
           
           %��ͣ���������ͣ
           if limitStatus == 1
               returnlimit_cnt = returnlimit_cnt + 1;
           %������ͣ
           else
               Strategy_one_status = 1;         %����1 ׼������
               all_limit_cnt = all_limit_cnt + 1;
           end
           
           %�жϲ���2��������ͣ����
           Strategy_two_continue_limit_times = 3;%������ͣ����
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
        
        %�������Ϊ������ͣ���
        daynum = w_tdays_times(k);
        Strategy_three_continue_limit_times = 3;%����������ͣ����
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
