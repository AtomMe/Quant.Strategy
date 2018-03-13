import csv
f = open('20160202.csv', 'rb')
reader = csv.reader(f)
arr = []
index = 0
for row in reader:
	index = index+1
	arr.append(row)
	if not row:
		print index
index = 0
		
for i in arr:
	index = index + 1
	if not i:
		flag = index
		print flag
flag += 2
for row in range(flag,flag+20):
            print arr[row][3]