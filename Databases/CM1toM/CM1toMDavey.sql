/*VJ Davey 
SQL answer sheet for ClassicModels1toM Exercise
9/28/2016*/
use classicmodels;


/*1) Report the account representative for each customer.*/
SELECT customerName, firstName, lastName
	FROM Customers,Employees
		WHERE Employees.employeeNumber = Customers.salesRepEmployeeNumber;
/*2) Report total payments for Atelier graphique.*/
SELECT SUM(amount) as 'Total Payments'
	FROM Payments, Customers
		WHERE Customers.customerNumber = Payments.customerNumber and customerName = 'Atelier graphique';
/*3) Report the total payments by date*/
SELECT paymentDate, SUM(amount)
	FROM Payments
		GROUP BY paymentDate;
/*4) Report the products that have not been sold.*/
SELECT productName, Products.productCode
	FROM Products
		WHERE NOT EXISTS (
			SELECT * FROM OrderDetails 
				WHERE OrderDetails.productCode = Products.productCode
		);
/*5) List the amount paid by each customer.*/
SELECT customerName, SUM(amount)
	FROM Payments, Customers
		WHERE Payments.customerNumber = Customers.customerNumber
			GROUP BY customerName;
/*6) How many orders have been placed by Herkku Gifts?*/
SELECT COUNT(orderNumber)
	FROM Orders, Customers
		WHERE Orders.customerNumber = Customers.customerNumber AND customerName = 'Herkku Gifts';
/*7) Who are the employees in Boston?*/
SELECT firstName, lastName
	FROM Employees, Offices
		WHERE Employees.officeCode = Offices.officeCode AND city = 'Boston';
/*8) Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.*/
SELECT customerNumber, amount
	FROM Payments
		WHERE amount > 100000
			ORDER BY amount DESC;
/*9) List the value of 'On Hold' orders.*/
SELECT SUM(quantityOrdered * priceEach) AS Value
	FROM OrderDetails, Orders
		WHERE Orders.orderNumber = OrderDetails.orderNumber AND status = 'On Hold';

/*10) Report the number of orders 'On Hold' for each customer.*/
SELECT customerName, COUNT(orderNumber)
	FROM Orders, Customers
		WHERE Orders.customerNumber = Customers.customerNumber AND status = 'On Hold'
			GROUP BY customerName;
