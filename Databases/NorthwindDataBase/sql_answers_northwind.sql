/*VJ Davey
Northwind SQL Exercise
9/16/2-16*/
/*note use the days function in the slide deck to properly calculate things like age*/
use northwind;
/*problem 1*/
select ProductID,UnitsInStock, UnitPrice ,ceil(UnitPrice*UnitsInStock) as 'Total Price Rounded Up', floor(UnitPrice*UnitsInStock) as 'Total Price Rounded Down'
	from products
		order by ceil(UnitPrice*UnitsInStock) desc;

/*problem 2 - show hireage*/
select (datediff(HireDate, BirthDate))/365 as 'HireAgeAccurate', extract(year from HireDate)-extract(year from Birthdate) as 'HireAgeInnacurate'
	from employees;
/*problem 3*/
select concat(LastName,',',FirstName) as 'Employee', concat(extract(year from birthdate), '/', extract(month from birthdate)) as 'Birth Year and Month', curdate() as 'Current Date', floor(datediff(curdate(),BirthDate)/365) as 'Age this month'
	from employees;
/*problem 4*/
select FirstName, LastName, date_format(BirthDate,'%M') as 'BirthMonth'
	from employees
		order by extract(month from BirthDate) asc;
/*problem 5*/
select concat(FirstName,' ',LastName,' ',date_format(BirthDate,'%M'))
	from employees
		where extract(month from BirthDate) = extract(month from curdate());