#VJ Davey
#CTBA 9/6/16
#JSON Assignment
import requests

search_url = 'http://peterbeshai.com/buckets/api/?player=201939&season=2015'
response = requests.get(search_url, headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"})
total_shots=0
made_shots=0
for i in response.json():
	if i["ACTION_TYPE"]=="Jump Shot":
		total_shots+=1
		if i["EVENT_TYPE"]=="Made Shot":
			made_shots+=1
print "\n2015 Jump Shot Statistics for Stephen Curry\n\nTotal Jump Shots Attempted: %d\nTotal Jump Shots Made: %d\nPercentage of Jump Shots Made: %.4f\n" %(total_shots, made_shots, (float(made_shots)/float(total_shots)))