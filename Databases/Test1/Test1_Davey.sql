/*VJ Davey 
SQL answer sheet for Test 1
10/10/2016*/
use test1_msba16;
/*problem 5*/
select prereqID 
	from prereq,course
		where prereq.courseID = course.courseID and course.courseDesc = "Management of Virtual Organizations";
        
/*problem 6*/
select courseDesc, courseCredit
	from course,prereq
		where prereq.courseID = course.courseID 
			and prereq.prereqID  in (
				select courseID from course
					where courseDesc like 'E%1'
                    );
/*problem 8*/
select avg(36*Hrly_rate) as 'Supervisors Average Weekly Salary'
	from worker 
		where worker_id in (
			select BLDG_SUP
				from building
					where BLDG_TYPE='Office'
                    );
/*problem 9*/
select Worker_name
	from worker
		where Hrly_rate > 15 and (Skill_type ='Electric' or Skill_type = 'Roofing' or Skill_type = 'Framing')
        order by Worker_name desc;
/*problem 10*/
select BLDG_TYPE, count(worker_id) as 'Total Number of Assigned Workers'
	from building,assignment
		where building.BLDG_ID = assignment.bldg_id
			group by BLDG_TYPE
				having count(worker_id) = 3;
/*problem 11*/
select worker_id, Worker_name 
	from worker
		where worker_id in (select bldg_sup from building)
			and worker_id not in (
				select worker_id 
					from assignment
						);
/*problem 12*/
select customerName, avg(datediff(shippedDate, orderDate))
	from customers, orders
		where customers.customerNumber = orders.customerNumber
			group by customerName
				order by avg(datediff(shippedDate, orderDate)) desc;
/*problem 13*/
select a.lastName, a.firstName, a.reportsTo, a.lastName, a.firstName, a.jobTitle
	from employees a left join employees b
		on a.reportsTo = b.employeeNumber;
/*problem 14*/
select products.productline as 'Category', textDescription as 'Promo', productName, buyPrice,
	CASE
		WHEN buyPrice > (select avg(buyPrice) from products) THEN 'Priced above average buy price'
		WHEN buyPrice < (select avg(buyPrice) from products) THEN 'Priced below average buy price'
		ELSE 'Priced at average buy price'
	END AS 'Comment'
from products, productlines
	where products.productLine = productlines.productLine;
/*problem 15
	--not actually hardcoded in here as specified in the test .doc file*/
/*problem 16*/
SELECT IFNULL(c.salesRepEmployeeNumber, 'Grand Total') 'Employee', 
    IFNULL(c.customerNumber, 'Employee Total') 'Customer', 
    IFNULL(o.orderNumber,'Customer Total') 'Order',
    ROUND(SUM(od.priceEach*od.quantityOrdered),2) 'Order Total'         
 FROM orderdetails od JOIN orders o ON (od.orderNumber =  o.orderNumber) 
          JOIN customers c ON (c.customerNumber = o.customerNumber)      
     GROUP BY c.salesRepEmployeeNumber, c.customerNumber,o.ordernumber WITH ROLLUP;
   
/*problem 17*/
select concat(employees.firstName, ' ' ,employees.lastName) as 'Name', round(sum(0.05 *(quantityOrdered * priceEach)),0) as 'Commission'
	from orderdetails join orders 
		on (orderdetails.orderNumber = orders.orderNumber)
        join customers
        on (orders.customerNumber = customers.customerNumber)
        join employees
        on (customers.salesRepEmployeeNumber = employees.employeeNumber)
        group by (employees.lastName)
		;
/*problem 18*/
CREATE VIEW totalpaid (customerNumber, totalpaid) 
	AS 
	select customerNumber, sum(amount)
		from payments
			where year(paymentDate) = 2004
				group by customerNumber;
CREATE VIEW totalordered (customerNumber, totalordered)
	AS
	select customerNumber, sum(priceEach*quantityOrdered)
		from orderdetails od join orders o on od.orderNumber = o.orderNumber
			where year(orderDate) = 2004
				group by customerNumber;

select c.customerName 'customer', round(totalpaid,2) 'payments', round(totalordered,2) 'orders', round((totalpaid - totalordered),2) 'difference'
	from totalpaid tp join totalordered tor on tp.customerNumber = tor.customerNumber
		join customers c on tor.customerNumber = c.customerNumber
			where abs(totalpaid - totalordered) > 100
            order by c.customerName;
/*problem 19-1*/
select customerName, city
	from customers 
		where st_x(customerLocation) < (select st_x(officeLocation)
											from offices
												where city = 'NYC'
										) AND
			  st_y(customerLocation) < (select st_y(officeLocation)
											from offices
												where city = 'NYC'
										);
/*problem 19-2*/
select c.customerName, c.city
	from customers c, offices o
		where o.city = 'Tokyo'
			and (st_length(linestring(c.customerLocation, o.officeLocation))) < 50;
            
/*extra credit query*/
SELECT month(paymentDate) AS Month, round(sum(amount),2) AS Sum 
        FROM Payments 
WHERE year(paymentDate) = 2004 
GROUP BY month(paymentDate);
