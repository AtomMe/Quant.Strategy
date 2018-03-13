# The Cobwebs Trend Strategy of Index Futures
## Idea
The Cobwebs Trend Strategy belongs to the field of behavior finance. The main idea is to follow the informed institutional investors who we apply a quantitative method to define. If you need more details,please refer to this report [蜘蛛网策略](./蜘蛛网策略.pdf) 
## Model
I use three kinds of index future's daily market data including Settlement membership turnover data. I crawl these data from the Website of [China Financial Futures Exchange](http://www.cffex.com.cn/). Python crawl packages are requried, such as,[requests](https://github.com/requests/requests). The output of the strategy is a binary value,1 or -1. It predict that the underlying asset will go up in the next day if its vaule equals to 1. Otherwise, vice versa.

