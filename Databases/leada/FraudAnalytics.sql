use Project;
/*how many rows are in each table?*/
select count(*) from Activity;
select count(*) from User;
select count(*) from UserActivity;
/*how many different kinds of activity_type are there? Whats most popular?
*/
select distinct(activity_type), count(activity_type) 
from Activity
group by (activity_type);
/*what is the email of the most active user(s)?*/
select email from User where user_id in (select user_id from UserActivity 
	where activity_time in (select max(activity_time)
		from UserActivity));
/*what state produced the most amount of activities?*/
select state, count(user_activity_id)
	from User join UserActivity on (User.user_id = UserActivity.user_id)
		group by state 
			order by count(user_activity_id) desc;
/*What time did the most activities happen (in 0-23 format)? 
Try building a view and sort it: */
select hour(activity_time), count(user_activity_id)
	from UserActivity
		group by hour(activity_time)
			order by count(user_activity_id) desc;
/*What time did the most activities happen (for minutes)?
Try building a view and sort it: */
select minute(activity_time), count(user_activity_id)
	from UserActivity
		group by minute(activity_time); /*look over and determine what kind of distribution this is--pretty uniform looking*/
/*build hourly activity distribution for 'saunsi_la12@virgilio.it'*/
select hour(activity_time), count(user_activity_id)
	from UserActivity join User on UserActivity.user_id = User.user_id
		where email = 'saunsi_la12@virgilio.it'
		group by hour(activity_time)
			order by count(user_activity_id) desc;
/*Build the same hourly activity distribution for 'dr_abdul.musa01@msn.com'*/
select hour(activity_time), count(user_activity_id)
	from UserActivity join User on UserActivity.user_id = User.user_id
		where email = 'dr_abdul.musa01@msn.com'
		group by hour(activity_time)
			order by count(user_activity_id) desc;
/*lets see who's cheating -- top end cutoff plus take a look at those who have uniform distributions below the top end cutoff*/
select email, count(user_activity_id)
	from UserActivity join User on UserActivity.user_id = User.user_id
		group by email
			order by count(user_activity_id) desc;