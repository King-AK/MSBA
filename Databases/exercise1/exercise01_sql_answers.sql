/*VJ Davey 
SQL answer sheet for exercise01
9/16/2016*/
use exercise01;
select * from customers;
/*problem 1*/
select companyName, city, region, postalcode 
	from customers
		order by region, city;
/*problem 2*/
select companyName, city, region, postalcode
	from customers
		where region = 'OR'
			order by region, city, companyName;
/*problem 3*/
select companyName, city, region, postalcode
	from customers
		where region IN ('OR','WA')
			order by region desc, city asc, companyName asc;
/*problem 4*/
select OrderID, CustomerID, OrderDate
	from orders
		where CustomerID in ('QUICK', 'FRANK', 'RANCH')
			order by CustomerID, OrderDate;
/*problem 5*/
select CustomerID, count(OrderID)
	from orders
		where CustomerID in ('QUICK', 'FRANK', 'RANCH')
			group by CustomerID 
				order by CustomerID;
/*problem 6*/
select CustomerID, count(OrderID) as 'OrdersPlaced'
	from orders
		where CustomerID in ('QUICK', 'FRANK', 'RANCH')
			group by CustomerID 
				order by CustomerID;
/*problem 7*/
select count(distinct(CustomerID)) as 'Num_distinct_customers'
	from orders;
/*problem 8*/
select count(orderID) as 'Orders placed in May 1998'
	from orders
		where OrderDate like '1998-05-%';
/*problem 9*/
select count(distinct(CustomerID)) as 'Distinct customers in May 1998'
	from orders
    where OrderDate like '1998-05-%';
/*problem 10*/
select customerID, count(orderID), concat('$',format(avg(freight),2)) as 'Freight Cost'
	from orders
		group by customerID
			having count(orderID) > 10 and avg(Freight) > 100;
/*problem 11*/
select productID, supplierID, UnitsInStock, Discontinued
	from products
		where supplierID in (2, 12) and (discontinued = 0) and UnitsInStock < 60
			order by supplierID, UnitsInStock desc;