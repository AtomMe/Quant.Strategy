
''' urllib2
print "downloading with urllib2"

url = 'http://www.cffex.com.cn/fzjy/ccpm/201604/07/IF_1.csv' 
f = urllib2.urlopen(url) 
data = f.read() 
with open("demo2.csv", "wb") as code:     
    code.write(data)
'''	
import urllib2
import datetime
begin = datetime.date(2016,3,1)  
end = datetime.date(2016,4,26)
for i in range((end - begin).days+1):
	day = begin + datetime.timedelta(days=i)
	num = day.weekday()
	if (num != 6) and (num != 5):
		splitday = str(day).split('-')
		fileformat = splitday[0]+splitday[1] + '/' + splitday[-1]
		fileurl = 'http://www.cffex.com.cn/fzjy/ccpm/' + fileformat + '/IF_1.csv'
		print fileurl
		f = urllib2.urlopen(fileurl)
		data = f.read()
		filename = splitday[0]+splitday[1]+ splitday[-1]+'.csv'
		with open(filename, "wb") as code:     
			code.write(data)
	