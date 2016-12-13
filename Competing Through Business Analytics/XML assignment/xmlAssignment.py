#VJ Davey 
#8/31/2016
#XML webscraping assignment for CTBA class w/ Prof Bradley
import requests
from lxml import objectify
from lxml import etree

print "Average Temperature Data for Virginia..."
#ask user for period, month, and year as variables to substitute into query string
period_options=["1","2","3","4","5","6","7","8","9","10","11","12","18","24","36","48","60","Year to Date"]
month_options=["January","February","March","April","May","June","July","August","September","October","November","December"]

#collect user input
print"\nPlease select a period to examine from the choices below (type in the corresponding number)..."
for i in range(len(period_options)):
	print "\t(%d)\t%s" %(i, period_options[i])
period_choice = raw_input("...")
#check to make sure user input is a number within the range of period_options, exit program otherwise
if((period_choice.isdigit()==False) or (int(period_choice)<0) or (int(period_choice)>len(period_options)-1)):
	print("You did not enter a valid period! Exiting program!")
	exit(1)

print"\nPlease select a month to examine from the choices below (type in the corresponding number)..."
for i in range(len(month_options)):
	print "\t(%d)\t%s" %(i, month_options[i])
month_choice = raw_input("...")
#check to make sure user input is a number within the range of month_options, exit otherwise
if((month_choice.isdigit()==False) or (int(month_choice)<0) or (int(month_choice)>12)):
	print("You did not enter a valid month! Exiting program!")
	exit(1)

year_choice = raw_input("\nPlease enter a year (1895-present)\n...")
#check to make sure user input is a number between 1895 and 2016
if((year_choice.isdigit()==False) or (int(year_choice)<1895) or (int(year_choice)>2016)):
	print("You did not enter a valid year! Exiting program!")
	exit(1)
#use string substitution to dynamically generate query links that are usable with noaa website
print "period choice was: %s" % (period_choice)
query = "http://www.ncdc.noaa.gov/temp-and-precip/climatological-rankings/download.xml?parameter=tavg&state=44&div=0&month=%d&periods[]=%s&year=%s"%(int(month_choice)+1, period_options[int(period_choice)], year_choice)
#in the event the user queries for a year to date period, override the previously generated query:
if period_choice=="17":
	query = "http://www.ncdc.noaa.gov/temp-and-precip/climatological-rankings/download.xml?parameter=tavg&state=44&div=0&month=%d&periods[]=ytd&year=%s"%(int(month_choice)+1, year_choice)	

response=requests.get(query).content
root = objectify.fromstring(response)
print "\n\nValue: %s \ntwentiethCenturyMean: %s \nhighRank: %s \n" %(root["data"]["value"], root["data"]["twentiethCenturyMean"],root["data"]["highRank"])