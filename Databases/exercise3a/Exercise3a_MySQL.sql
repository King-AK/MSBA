CREATE DATABASE IF NOT EXISTS Exercise3a;
USE `Exercise3a`;

#
# Table structure for table 'ASSIGNMENT'
#

DROP TABLE IF EXISTS `ASSIGNMENT`;

CREATE TABLE `ASSIGNMENT` (
  `worker_id` VARCHAR(4) NOT NULL, 
  `bldg_id` VARCHAR(3) NOT NULL, 
  `start_date` DATETIME, 
  `num_days` INTEGER DEFAULT 0, 
  INDEX (`bldg_id`), 
  INDEX (`num_days`), 
  PRIMARY KEY (`worker_id`, `bldg_id`), 
  INDEX (`worker_id`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'ASSIGNMENT'
#

INSERT INTO `ASSIGNMENT` (`worker_id`, `bldg_id`, `start_date`, `num_days`) VALUES ('1235', '321', '2001-08-10 00:00:00', 5);
INSERT INTO `ASSIGNMENT` (`worker_id`, `bldg_id`, `start_date`, `num_days`) VALUES ('1412', '321', '2001-08-01 00:00:00', 10);
INSERT INTO `ASSIGNMENT` (`worker_id`, `bldg_id`, `start_date`, `num_days`) VALUES ('1235', '515', '2001-05-17 00:00:00', 22);
INSERT INTO `ASSIGNMENT` (`worker_id`, `bldg_id`, `start_date`, `num_days`) VALUES ('2920', '460', '2001-09-15 00:00:00', 18);
# 4 records

#
# Table structure for table 'BUILDING'
#

DROP TABLE IF EXISTS `BUILDING`;

CREATE TABLE `BUILDING` (
  `BLDG_ID` VARCHAR(3) NOT NULL, 
  `BLDG_ADDRESS` VARCHAR(50), 
  `BLDG_TYPE` VARCHAR(10), 
  `BLDG_QLTY_LV` VARCHAR(2), 
  INDEX (`BLDG_ID`), 
  PRIMARY KEY (`BLDG_ID`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'BUILDING'
#

INSERT INTO `BUILDING` (`BLDG_ID`, `BLDG_ADDRESS`, `BLDG_TYPE`, `BLDG_QLTY_LV`) VALUES ('321', '123 Elm', 'Office', '2A');
INSERT INTO `BUILDING` (`BLDG_ID`, `BLDG_ADDRESS`, `BLDG_TYPE`, `BLDG_QLTY_LV`) VALUES ('435', '456 Maple', 'Retail', '1B');
INSERT INTO `BUILDING` (`BLDG_ID`, `BLDG_ADDRESS`, `BLDG_TYPE`, `BLDG_QLTY_LV`) VALUES ('515', '789 Oak', 'Residence', '3A');
INSERT INTO `BUILDING` (`BLDG_ID`, `BLDG_ADDRESS`, `BLDG_TYPE`, `BLDG_QLTY_LV`) VALUES ('460', '1011 Birch', 'Office', '2A');
# 4 records

#
# Table structure for table 'WORKER'
#

DROP TABLE IF EXISTS `WORKER`;

CREATE TABLE `WORKER` (
  `Worker_id` VARCHAR(4) NOT NULL, 
  `Worker_name` VARCHAR(15), 
  `Hrly_rate` DECIMAL(18,2) DEFAULT 0, 
  `Skill_type` VARCHAR(12), 
  PRIMARY KEY (`Worker_id`), 
  INDEX (`Worker_id`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'WORKER'
#

INSERT INTO `WORKER` (`Worker_id`, `Worker_name`, `Hrly_rate`, `Skill_type`) VALUES ('1235', 'Faraday', 12.5, 'Electric');
INSERT INTO `WORKER` (`Worker_id`, `Worker_name`, `Hrly_rate`, `Skill_type`) VALUES ('1412', 'Nemo', 13.75, 'Plumbing');
INSERT INTO `WORKER` (`Worker_id`, `Worker_name`, `Hrly_rate`, `Skill_type`) VALUES ('2920', 'Garret', 10, 'Roofing');
INSERT INTO `WORKER` (`Worker_id`, `Worker_name`, `Hrly_rate`, `Skill_type`) VALUES ('3231', 'Mason', 17.4, 'Framing');
INSERT INTO `WORKER` (`Worker_id`, `Worker_name`, `Hrly_rate`, `Skill_type`) VALUES ('9909', 'Smith', 15, 'Electric');
# 5 records

