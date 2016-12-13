/*VJ Davey 
SQL answer sheet for exercise3a
9/23/2016*/
use exercise3a;
/*problem 1*/
select Worker_name, Hrly_rate*36 as 'Weekly Pay' from worker;
/*problem 2*/
select Worker_name, Skill_type 
	from worker, assignment 
		where worker.Worker_id = assignment.worker_id and bldg_id = 321
			order by Hrly_rate desc;
/*problem 3*/
select Worker_name, Hrly_rate
	from worker 
	where Hrly_rate in (select max(Hrly_rate) from worker) or Hrly_rate in (select min(Hrly_rate) from worker);
/*problem 4*/
select Worker_name, assignment.worker_id, assignment.bldg_id
	from assignment, building, worker 
		where assignment.bldg_id = building.BLDG_ID and assignment.worker_id = worker.Worker_id and BLDG_TYPE = 'Office' and DATE(start_date) > DATE('2001-09-10');
/*problem 5*/
select BLDG_QLTY_LV, count(assignment.bldg_id) as 'Workers_assigned'
	from assignment, building
		where assignment.bldg_id = building.BLDG_ID
			group by BLDG_QLTY_LV
				having count(assignment.bldg_id) > 1;
/*TODO problem 6 - redo with a divide possibly--employee has either plumbing or electric skill*/
select distinct bldg_address
	from worker w, assignment a, building b
		where w.worker_id = a.Worker_id and b.bldg_id=a.bldg_id and Skill_type = 'Electric' or Skill_type = 'Plumbing';

/*problem 7*/
select Worker_name, Hrly_rate
	from worker w, assignment a, building b
		where w.worker_id = a.worker_id and b.bldg_id=a.bldg_id and b.bldg_type = 'Office';
/*problem 8*/
select worker_id, start_date, num_days, BLDG_ADDRESS, building.bldg_id, BLDG_TYPE
	from (assignment right join building on assignment.bldg_id = building.BLDG_ID)
		order by building.BLDG_ID;  
/*problem 9*/
/*restrictions with the current data model would include:
	-inclusion of fields which would be likely to change often like Num_Days in Assignment
    -Inclusion of skill type, or at least not making a seprate table for skill type. It is not shown in this table, but employees could have multiple skills, or change their skills
    -having the assignment table rely on the primary keys of building and worker locks assignment in. One worker cannot work on multiple projects to the same building with the current set up. 
    