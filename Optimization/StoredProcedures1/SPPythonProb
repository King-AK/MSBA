#VJ Davey
#10/24/2016
#SP Assignment Python Prob

import MySQLdb as mySQL


print 'Setting up DB connection'
user = str(raw_input("please enter your user name: "))
passwd = str(raw_input("please enter your password: "))
cnx = mySQL.connect(user= user, passwd= passwd,
                    host='127.0.0.1', db='classicmodelsopt')                              
states = ['CT', 'DE', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VT']

query_base = "CALL `spGetCustomers`(\"%s\");"
    
#print '1st query'
for i in states:
	cursor = cnx.cursor()
	query = query_base % (i)
	print query
	cursor.execute(query)
	query_results = cursor.fetchall()
	print("results for state %s" % (i))
	print query_results
	print "\n"
	cursor.close()

cnx.close()