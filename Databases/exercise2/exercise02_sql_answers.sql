/*VJ Davey 
SQL answer sheet for exercise02
9/21/2016*/
use exercise02;
/*problem 1*/
select MG_NUMBER,MG_NAME
	from manager
		where MG_NUMBER like '%0%'
			order by MG_NAME desc;
/*problem 2*/
select distinct P_MANAGER
	from project
		where ACTUAL_COST > EXPECTED_COST;
/*problem 3*/
	/*see attached diagram*/
/*problem 4*/
select MG_NAME,MG_NUMBER
	from manager
		where MG_DEPARTMENT = "Finance"
			order by MG_NAME desc;
/*problem 5*/
select P_NAME, EXPECTED_COST
	from project
		where EXPECTED_COST > (select avg(EXPECTED_COST) from project);
/*problem 6*/
select avg(EXPECTED_COST) as 'Average Expected for Yates'
	from project,manager
		where MG_NUMBER=P_MANAGER and MG_NAME='Yates';
/*problem 7*/
select sum(ACTUAL_COST) as 'Sum cost for projects not over budget for Kanter'
	from project,manager
		where MG_NUMBER=P_MANAGER and MG_NAME='Kanter' and ACTUAL_COST <= EXPECTED_COST;
/*problem 8*/
select P_NUMBER, P_NAME 
	from project
		where ACTUAL_COST >= 1.25*EXPECTED_COST;
/*problem 9*/
select MG_NAME, sum(EXPECTED_COST)
	from project, manager
		where MG_NUMBER = P_MANAGER
			group by MG_NAME
				having sum(EXPECTED_COST) > 5000;
/*problem 10*/
select manager.*, project.p_name
	from project right join manager 
		on MG_NUMBER = P_MANAGER;