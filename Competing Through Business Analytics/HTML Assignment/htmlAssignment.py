#VJ Davey
#HTML Assignment - CTBA 
#9/4/16
import os
import re
import requests
import urllib
from bs4 import BeautifulSoup

#program will work with a saved html page for Amazon's Green Eggs and Ham
url = 'file:{}'.format(urllib.pathname2url(os.path.abspath('GEAH.htm')))
page = urllib.urlopen(url).read()
parsed_html = BeautifulSoup(str(page),"html.parser")
strings=[]
for string in parsed_html.stripped_strings:
	result = repr(string.encode('utf-8'))
	strings.append(result)
book_title=None
book_price=None
num_pages=None
isbn_no=None

for i in strings:
	if "ISBN:" in i:
		isbn_no = strings[strings.index(i)+1].strip('"\'')
	if "Number Of Pages" in i:
		num_pages = strings[strings.index(i)+1].strip('"\'')
	if "Price:" in i:
		book_price = strings[strings.index(i)+1].strip('"\'')
	if "Details about" in i and book_title==None:
		 book_title = strings[strings.index(i)+1].strip('"\'')
		 book_title = book_title[:book_title.index('[')]

#print information to console Window
print "\nNote: This program will parse the local html file GEAH.htm\n\n"
print "Book Title\t: %s\nBook Price\t: %s\nNum of Pages\t: %s\nISBN\t\t: %s\n"%(book_title,book_price,num_pages,isbn_no)