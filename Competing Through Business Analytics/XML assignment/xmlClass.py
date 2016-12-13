import requests
from lxml import objectify
from lxml import etree

response=requests.get("http://w1.weather.gov/xml/current_obs/KJGG.xml").content
#print response
root = objectify.fromstring(response)
#print root.tag
print 
print etree.tostring(root,pretty_print=True)
print "\n\nTemp: %s \nWind: %s \nHeat Index: %s \nDew Point: %s \nLast Updated: %s \n" %(root["temperature_string"], root["wind_string"], root["heat_index_string"], root["dewpoint_string"], root["observation_time"])

#additons to print out lat, long, url tage within image tages

print "Bonus stuff asked for in class:\n"
print "Latitude: %s \nLongitude: %s \nImage/URL: %s \nIcon URL Base: %s \nIcon URL Name: %s\n" %(root["latitude"], root["longitude"], root["image"]["url"], root["icon_url_base"],root["icon_url_name"])