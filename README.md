# Quant.Strategy
I will upload and update my quant strategies which include CTA strategy, stock strategy etc. Not only `Python` is the Programming language, but also `MATLAB` and `VBA`.
## Database
I use [**MongoDB**](https://www.mongodb.com/) as my developed database to store the re-structral data. The data is mainly from Wind and other free data sourse such as [**tushare**](https://github.com/waditu/tushare). In the file [database](./database), There are several works I have done.

   * a document([DatabaseAPI](./database/DatabaseAPI.pdf)) which tell you how to use the Database API using python and how to configure.
   * tool functions tell you [how to extract data from wind](./database/DataReaderFromWind.py) and [store data into MongoDB](./database/insertData2Mongo.py)
   * there are three kinds of data,stock, index and futures.
   * there are two level of data.day level for stock and index, and bar level for future(commodity futures and index futures).
## Strategy Set
### CTA Strategy

* [Low-lag Trendline &  Timing Strategy on Futures](./CTA/Low-lag-Trendline)
* [Turtle Trading Strategy](./CTA/Turtle-Trading-Strategy)

### Stock Strategy

* [Price Limit Strategy on Stocks of A Share](./stock/Price-Limit-Strategy)

### Others

* [The Cobwebs Trend Strategy of Index Futures](./OTHERS/Cobwebs-Trend-Strategy)