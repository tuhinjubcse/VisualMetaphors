import json

m = {"DALLE": 0,"DALLE_CoT":0,"SD":0,"SD_CoT":0,"Struct_CoT":0}

for i in range(0,100):
	folder = 'metaphor'+str(i)
	with open(folder+'.json') as f1:
		data1 = json.load(f1)
	with open("../../static/"+folder+'/metadata.json') as f2:
		data2 = json.load(f2)
	ranking = data1['ranking'].split(',')
	for i in range(1,6):
		pos = ranking[i-1]
		m[data2[pos]]=m[data2[pos]]+i


for elem in m:
	print(elem, m[elem]/100.0)

