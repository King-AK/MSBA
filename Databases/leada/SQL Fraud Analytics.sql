USE Project;
SELECT * FROM Activity;
SELECT * FROM User;
SELECT * FROM UserActivity;

#How many different kinds of activity_type are there?
SELECT DISTINCT(activity_type) FROM Activity;

#What is the most popular activity_type?
SELECT activity_type,COUNT(activity_type) FROM Activity
	GROUP BY activity_type;
    
#What is the email of the most active user?
SELECT email, User.user_id, SUM(activity_time),COUNT(user_activity_id) FROM UserActivity 
	JOIN User ON UserActivity.user_id = User.user_id
    GROUP BY email
    ORDER BY SUM(activity_time) DESC;
    
#What time did the most activities happen (in 0-23 format)? Try building a view like the following and sort it: hour | activities_count 
SELECT HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
	GROUP BY HOUR(activity_time)
    ORDER BY COUNT(user_activity_id) DESC;
    
#What does the activity distribution for each minute look like? Try building the following table and gauge it: min | activities_count 
SELECT MINUTE(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
	GROUP BY MINUTE(activity_time);
    
#Build the same hourly activity distribution for 'saunsi_la12@virgilio.it': 
SELECT HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
	JOIN User ON UserActivity.user_id = User.user_id
    WHERE email = 'saunsi_la12@virgilio.it'
    GROUP BY HOUR(activity_time);
    
#Build the same hourly activity distribution for 'dr_abdul.musa01@msn.com': 
SELECT HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
	JOIN User ON UserActivity.user_id = User.user_id
    WHERE email = 'dr_abdul.musa01@msn.com'
    GROUP BY HOUR(activity_time);
    
#CODE FOR ANALYSIS
SELECT user_id, activity_time, COUNT(user_acitivity_id) FROM Project.UserActivity
	GROUP BY user_id, activity_time
	ORDER BY user_id, activity_time;
SELECT user_id, activity_time, MINUTE(activity_time_), COUNT(user_activity_id) FROM Project.UserActivity
	GROUP BY user_id, activity_time
	ORDER BY user_id, activity_time;
#Sample User Distribution
SELECT email, HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
			JOIN User ON UserActivity.user_id = User.user_id
            WHERE email = 'aa802200@yahoo.co.jp'
			GROUP BY HOUR(activity_time);
            
#Average Activity per Hour by User, and SD of that Activity
SELECT email, ROUND(SUM(activities_count)/COUNT(activities_count),2) AS 'Average Hourly Activity', 
	ROUND(STDDEV(activities_count),2) AS 'SD of Hourly Activity Count' 
		FROM (SELECT email, HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
			JOIN User ON UserActivity.user_id = User.user_id
			GROUP BY email, HOUR(activity_time)) AS user_act_hour
					GROUP BY email
						#HAVING ROUND(STDDEV(activities_count),2) <= 6.00
                        HAVING COUNT(activities_count) = 24;
						ORDER BY ROUND(STDDEV(activities_count),2) DESC;
                                
#Mode of SDs and associate frequencies
SELECT St_Dev_Act_Per_Hour, COUNT(St_Dev_Act_Per_Hour) AS Mode_SD_Act_Hrly_Overall
	FROM (SELECT email, ROUND(SUM(activities_count)/24,2) AS Avg_Act_Per_Hour, 
		ROUND(STDDEV(activities_count),2) AS St_Dev_Act_Per_Hour 
			FROM (SELECT email, HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
				JOIN User ON UserActivity.user_id = User.user_id
				GROUP BY email, HOUR(activity_time)) AS user_act_hour
					GROUP BY email) AS Avgs_And_SDs
						GROUP BY St_Dev_Act_Per_Hour 
                        ORDER BY Mode_SD_Act_Hrly_Overall DESC;
                        LIMIT 5;
                        
#Overall Average Hrly Activity and Overall Average SD
#SELECT ROUND(SUM(Avg_Act_Per_Hour)/COUNT(email),2) AS Avg_Act_Hrly_Overall, 
	#ROUND(SUM(St_Dev_Act_Per_Hour)/COUNT(email),2) AS SD_Act_Hrly_Overall
	#FROM (SELECT email, ROUND(SUM(activities_count)/COUNT(24),2) AS Avg_Act_Per_Hour, 
		#ROUND(STDDEV(activities_count),2) AS St_Dev_Act_Per_Hour 
			#FROM (SELECT email, HOUR(activity_time) AS 'hour', COUNT(user_activity_id) AS 'activities_count' FROM UserActivity
				#JOIN User ON UserActivity.user_id = User.user_id
				#GROUP BY email, HOUR(activity_time)) AS user_act_hour
					#GROUP BY email) AS Avgs_And_SDs;