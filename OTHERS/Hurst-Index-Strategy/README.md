# Hurst Exponent Estimation on Chinese A Share Market
## Idea
The Hurst exponent[[Wikipedia](https://en.wikipedia.org/wiki/Hurst_exponent)] is used as a measure of long-term memory of time series. H=0.5  indicates  a  random  series, while  H>0.5  indicates  a  trend  reinforcing  series.    The  larger the H value is, the stronger trend. for more information about Hurst exponent and R/S analysis, you can check the [reference](./reference).

## Model
I use Shanghai 300 Index to caculate the H. The result may not be resonable, Because the value of H, totally,3000 samples,is greater than 0.8, which means that it has a long-term memory of time series on Chinese market. In the future, I will update my [model and code](./model).

