CREATE DATABASE IF NOT EXISTS `Exercise08`;
USE `Exercise08`;

#
# Table structure for table 'course'
#

DROP TABLE IF EXISTS `course`;

CREATE TABLE `course` (
  `courseID` VARCHAR(50) NOT NULL, 
  `courseDesc` VARCHAR(50), 
  `courseCredit` INTEGER, 
  INDEX (`courseID`), 
  PRIMARY KEY (`courseID`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'course'
#

INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('CSCI1111', 'Intro to Computers', 4);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('EC101', 'Intro to Electronic Commerce', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('EC205', 'Management of Virtual Organizations', 6);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('ENG1111', 'English1', 2);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FIN1111', 'FINANCE1', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FIN3333', 'FINANCE2', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FIN4444', 'Corporate Fin', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FIN5555', 'Real Estate', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FIN6666', 'Investments', 3);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('FR101', 'French 1', 2);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('MA1111', 'College Algebra', 4);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('MA2222', 'Calculus1', 4);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('112233', 'chon\'s class', 6);
INSERT INTO `course` (`courseID`, `courseDesc`, `courseCredit`) VALUES ('134567', 'dnlnf', 6);
# 14 records

#
# Table structure for table 'department'
#

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `deptid` VARCHAR(50) NOT NULL, 
  `dept_name` VARCHAR(50), 
  PRIMARY KEY (`deptid`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'department'
#

INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('ACCT', 'Accounting');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('CS', 'Computer Science');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('FIN', 'Finance');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('HIST', 'History');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('LG', 'Language');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('MATH', 'Mathematics');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('MGMT', 'Management');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('MIS', 'Management Information Systems');
INSERT INTO `department` (`deptid`, `dept_name`) VALUES ('MKT', 'Marketing');
# 9 records

#
# Table structure for table 'offering'
#

DROP TABLE IF EXISTS `offering`;

CREATE TABLE `offering` (
  `deptid` VARCHAR(50) NOT NULL, 
  `courseid` VARCHAR(50) NOT NULL, 
  INDEX (`courseid`), 
  INDEX (`deptid`), 
  PRIMARY KEY (`deptid`, `courseid`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'offering'
#

INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('CS', 'CSCI1111');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('FIN', 'FIN1111');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('FIN', 'FIN3333');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('FIN', 'FIN4444');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('FIN', 'FIN5555');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('FIN', 'FIN6666');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('LG', 'ENG1111');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('LG', 'FR101');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MATH', 'MA1111');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MATH', 'MA2222');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MGMT', 'EC205');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MIS', 'CSCI1111');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MIS', 'EC101');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MIS', 'EC205');
INSERT INTO `offering` (`deptid`, `courseid`) VALUES ('MKT', 'EC101');
# 15 records

#
# Table structure for table 'prereq'
#

DROP TABLE IF EXISTS `prereq`;

CREATE TABLE `prereq` (
  `courseID` VARCHAR(50) NOT NULL, 
  `prereqID` VARCHAR(50) NOT NULL, 
  `duration-validity` INTEGER, 
  INDEX (`courseID`), 
  INDEX (`prereqID`), 
  PRIMARY KEY (`courseID`, `prereqID`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'prereq'
#

INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('EC205', 'EC101', 3);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN3333', 'CSCI1111', 9);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN3333', 'ENG1111', NULL);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN3333', 'FIN1111', 9);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN3333', 'MA1111', 15);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN3333', 'MA2222', 15);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN4444', 'FIN3333', 6);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN5555', 'FIN3333', 6);
INSERT INTO `prereq` (`courseID`, `prereqID`, `duration-validity`) VALUES ('FIN6666', 'FIN3333', 6);
# 9 records

