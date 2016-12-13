/*VJ Davey 
SQL answer sheet for JOIN Exercise
9/28/2016*/
use northwind;
/*1) Create a report that shows the number of employees and customers from each city that has employees in it. */
select count(distinct employeeID) as numEmployees, count(distinct customerID) as numcustomers, employees.city
	from employees, customers
		where employees.city=customers.city
			group by employees.city
				order by numcustomers desc;
/*2) Create a report that shows the number of employees and customers from each city that has employees in it
 but also show results for employees even if there are no customers in that city*/
select count(distinct employeeID) as numEmployees, count(distinct customerID) as numcustomers, employees.city
	from employees left join customers
		on employees.city=customers.city
			group by employees.city
				order by numcustomers desc;
/*3) Create a report that shows the number of employees and customers from each city that has customers in it
 but also show the cities without any assigned employees.*/
 select count(distinct employeeID) as numEmployees, count(distinct customerID) as numcustomers, employees.city, customers.city
	from employees right join customers
		on employees.city=customers.city
			group by customers.city
				order by numEmployees desc, numcustomers desc;
use new_accounts;
/*4) List order information in a query that should retrieve invoice number, name of person who placed the order, 
product IDs, and quantities.*/
select order_header.invoice_number, lastname, firstname, product_id,quantity
	from order_header join order_item 
		on order_header.invoice_number = order_item.invoice_number
			join person
				on person.id = order_header.customer_id;
/*5) Modify the query above to include the product description of each item*/
select order_header.invoice_number, lastname, firstname, description,quantity
	from order_header join order_item 
		on order_header.invoice_number = order_item.invoice_number
			join person
				on person.id = order_header.customer_id
					join product
						on product.product_id = order_item.product_id;
/*6) Modify the above query to include the total price to the customer (i.e., 
(quantity * (price * (1- discount)) for each item, don’t try subtotaling these!*/
select order_header.invoice_number, lastname, firstname, description,quantity, (quantity*(price*1-discount)) as 'price'
	from order_header join order_item 
		on order_header.invoice_number = order_item.invoice_number
			join person
				on person.id = order_header.customer_id
					join product
						on product.product_id = order_item.product_id;
/*7) List the first and last name, along with the supervisor’s id and title of each employee and show even those employees
 without supervisors, ordered by the employees with supervisors then those not have supervisors.*/
 select lastname, firstname, e1.supervisor_id,e2.title
	from employee e1 left join person
		on e1.id=person.id
			left join employee e2
				on e1.supervisor_id = e2.id
					order by e1.supervisor_id desc,lastname;