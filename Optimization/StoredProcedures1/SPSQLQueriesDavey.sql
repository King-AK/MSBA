use classicmodelsopt;
CALL `classicmodelsopt`.`spNewCustomer`();
CALL `classicmodelsopt`.`spCustomerOrders`(103);
CALL `classicmodelsopt`.`spUpdateCustomers`();
select * from customers where customerNumber = 129;
select * from customers where customerNumber = 151;
CALL `classicmodelsopt`.`spDeletePayments`();
select * from payments;
CALL `classicmodelsopt`.`spGetCustomers`('MA');


