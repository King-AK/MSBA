USE Project;


select temp_table.user_id, max(per_second), User.email
from (SELECT user_id, count(user_activity_id) AS per_second FROM UserActivity GROUP BY user_id, activity_time having count(user_activity_id) >= 3) AS temp_table
JOIN User
	ON temp_table.user_id = User.user_id
GROUP BY temp_table.user_id
HAVING count(temp_table.user_id) >= 3
ORDER BY max(per_second) DESC;
