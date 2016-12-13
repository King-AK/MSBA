CREATE DATABASE IF NOT EXISTS Exercise02;
USE `Exercise02`;

#
# Table structure for table 'MANAGER'
#

DROP TABLE IF EXISTS `MANAGER`;

CREATE TABLE `MANAGER` (
  `MG_NAME` VARCHAR(20), 
  `MG_NUMBER` VARCHAR(4) NOT NULL, 
  `MG_DEPARTMENT` VARCHAR(25), 
  PRIMARY KEY (`MG_NUMBER`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'MANAGER'
#

INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Adams               ', '1001', 'Finance                  ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Baker               ', '1002', 'Finance                  ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Clarke              ', '1003', 'Accounting               ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Dexter              ', '1004', 'Finance                  ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Early               ', '1005', 'Accounting               ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Kanter              ', '1111', 'Finance                  ');
INSERT INTO `MANAGER` (`MG_NAME`, `MG_NUMBER`, `MG_DEPARTMENT`) VALUES ('Yates               ', '1112', 'Accounting               ');
# 7 records

#
# Table structure for table 'PROJECT'
#

DROP TABLE IF EXISTS `PROJECT`;

CREATE TABLE `PROJECT` (
  `P_NAME` VARCHAR(20), 
  `P_NUMBER` VARCHAR(5) NOT NULL, 
  `P_MANAGER` VARCHAR(4), 
  `ACTUAL_COST` DOUBLE NULL, 
  `EXPECTED_COST` DOUBLE NULL, 
  PRIMARY KEY (`P_NUMBER`)
) ENGINE=innodb DEFAULT CHARSET=utf8;

SET autocommit=1;

#
# Dumping data for table 'PROJECT'
#

INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('New billing system  ', '23760', '1112', 1000, 10000);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('Common stock issue  ', '28765', '1001', 3000, 4000);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('Resolve bad debts   ', '26713', '1111', 2000, 1500);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('New office lease    ', '26511', '1112', 5000, 5000);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('Revise documentation', '34054', '1111', 100, 3000);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('Entertain new client', '87108', '1112', 5000, 2000);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('New database        ', '99203', '1112', 2300, 800);
INSERT INTO `PROJECT` (`P_NAME`, `P_NUMBER`, `P_MANAGER`, `ACTUAL_COST`, `EXPECTED_COST`) VALUES ('New TV commercial   ', '85005', '1002', 10000, 8000);
# 8 records

