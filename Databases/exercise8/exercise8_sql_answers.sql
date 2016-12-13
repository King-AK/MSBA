/*VJ Davey 
SQL answer sheet for exercise8
10/2/2016*/
use exercise08;
/*problem 1 -- see attached mwb file*/

/*problem 2*/
select prereqID from prereq,course 
	where prereq.courseID= course.courseID  
		and course.courseDesc='FINANCE2';
/*problem 3*/
select courseDesc from course
	where courseID in (
		select prereqID from prereq,course 
			where prereq.courseID= course.courseID  
				and course.courseDesc='FINANCE2'
                );
/*problem 4*/
select courseDesc,courseCredit from course
	where courseID in (
		select prereqID from prereq,course 
			where prereq.courseID= course.courseID  
				and course.courseDesc='FINANCE2'
                );
/*problem 5*/
select dept_name from department
	where deptid not in (
		select deptid from offering
			);
/*problem 6*/
select courseDesc from course
where courseID in(
	select courseID from (select courseID, count(deptid) from offering
		group by courseID
			having count(deptid) > 1
            ) b );
/*problem 7*/
select courseDesc from course,offering,department
	where course.courseID not in (
		select courseID from prereq 
			where courseID in (
				select courseID from offering,department
					where offering.deptid = department.deptid and dept_name = 'Finance' 
                    )
				) and course.courseID=offering.courseid and offering.deptid=department.deptid and dept_name='Finance';
/*problem 8*/
select distinct(course.courseDesc) from prereq,course 
	where prereqID in(
		select courseID from course where courseCredit>3
		) and course.courseID = prereq.courseID;
/*problem 9*/
select count(distinct prereq.courseid)
	from  course, prereq
		where( coursedesc= "FINANCE2" or coursedesc = "FINANCE1") and course.courseID=prereq.prereqID;

