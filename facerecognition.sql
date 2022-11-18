-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 17, 2020 at 09:41 PM
-- Server version: 5.7.28-0ubuntu0.18.04.4
-- PHP Version: 7.2.24-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facerecognition`
--

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

DROP TABLE IF EXISTS `ClassTime`;
DROP TABLE IF EXISTS `CourseNote`;
DROP TABLE IF EXISTS `Enrol`;
DROP TABLE IF EXISTS `TakePlace`;
DROP TABLE IF EXISTS `Student`;
DROP TABLE IF EXISTS `Course`;
DROP TABLE IF EXISTS `Classroom`;

# Create TABLE 'Student'
CREATE TABLE `Student` (
  `student_id` int NOT NULL PRIMARY KEY,
  `name` varchar(50) NOT NULL,
  `login_time` time NOT NULL,
  `login_date` date NOT NULL,
  `email_address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Student` WRITE;
/*!40000 ALTER TABLE `Student` DISABLE KEYS */;
INSERT INTO `Student` VALUES (1, "Jack", NOW(), '2022-11-19', "shar@sharmail.sharcom.shar");
INSERT INTO `Student` VALUES (2, "Gigi", NOW(), '2022-11-19', "gigilee421@gmail.com");
INSERT INTO `Student` VALUES (3, "York", NOW(), '2022-11-19', "yyorkchan@gmail.com");
/*!40000 ALTER TABLE `Student` ENABLE KEYS */;
UNLOCK TABLES;


# Create TABLE 'Course'
CREATE TABLE `Course` (
  `course_id` varchar(25) NOT NULL PRIMARY KEY,
  `zoom_link` varchar(500) NOT NULL,
  `teacher_msg` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Course` WRITE;
INSERT INTO `Course` VALUES ("COMP3230", "https://hku.zoom.us/j/95846973790?pwd=SmduZjhjVEZlQTZnbVVLblZEQXRwUT09", "Please finish your asm");
INSERT INTO `Course` VALUES ("COMP3278", "https://hku.zoom.us/j/95846973790?pwd=SmduZjhjVEZlQTZnbVVLblZEQXRwUT09", "Please finish your report");
INSERT INTO `Course` VALUES ("COMP3340", "https://hku.zoom.us/j/95846973790?pwd=SmduZjhjVEZlQTZnbVVLblZEQXRwUT09", "Please finish your training");
INSERT INTO `Course` VALUES ("CCHU9021", "https://hku.zoom.us/j/95846973790?pwd=SmduZjhjVEZlQTZnbVVLblZEQXRwUT09", "Please correct your mistakes");
INSERT INTO `Course` VALUES ("CENG9001", "https://hku.zoom.us/j/95846973790?pwd=SmduZjhjVEZlQTZnbVVLblZEQXRwUT09", "Please finish your presentation");
UNLOCK TABLES;

# Create TABLE 'Classroom'
CREATE TABLE `Classroom` (
  `room_id` varchar(25) NOT NULL PRIMARY KEY,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Classroom` WRITE;
INSERT INTO `Classroom` VALUES ("MTW2", "Ming Wah Complex 2");
INSERT INTO `Classroom` VALUES ("CPD1.19", "Central Podium Level 1 Room 19");
INSERT INTO `Classroom` VALUES ("CPDLG.01", "Central Podium Level LG Grand Hall");
INSERT INTO `Classroom` VALUES ("KKLG109", "K. K. Leung Building Level LG Room 109");
INSERT INTO `Classroom` VALUES ("CYCC501", "Yuet Ming Auditorium");
INSERT INTO `Classroom` VALUES ("CYPP2", "Chong Yuet Ming Physics Building P2");
UNLOCK TABLES;

CREATE TABLE `Enrol` (
  `student_id` int NOT NULL,
  `course_id` varchar(25) NOT NULL,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES Student (student_id),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Enrol` WRITE;
INSERT INTO `Enrol` VALUES (1, "COMP3278");
INSERT INTO `Enrol` VALUES (2, "COMP3230");
INSERT INTO `Enrol` VALUES (2, "COMP3340");
INSERT INTO `Enrol` VALUES (2, "CCHU9021");
INSERT INTO `Enrol` VALUES (2, "CENG9001");
INSERT INTO `Enrol` VALUES (3, "COMP3278");
INSERT INTO `Enrol` VALUES (3, "COMP3340");
INSERT INTO `Enrol` VALUES (3, "CCHU9021");
INSERT INTO `Enrol` VALUES (3, "CENG9001");
UNLOCK TABLES;

CREATE TABLE `TakePlace` (
  `room_id` varchar(25) NOT NULL,
  `course_id` varchar(25) NOT NULL,
  PRIMARY KEY (room_id, course_id),
  FOREIGN KEY (room_id) REFERENCES Classroom (room_id),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TakePlace` WRITE;
INSERT INTO `TakePlace` VALUES ("CYPP2", "COMP3230");
INSERT INTO `TakePlace` VALUES ("MTW2", "COMP3278");
INSERT INTO `TakePlace` VALUES ("KKLG109", "COMP3340");
INSERT INTO `TakePlace` VALUES ("CYCC501", "CCHU9021");
INSERT INTO `TakePlace` VALUES ("MTW2", "CENG9001");
UNLOCK TABLES;

CREATE TABLE `ClassTime` (
  `course_id` varchar(25) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `day_of_week` char(3) NOT NULL,
  PRIMARY KEY (course_id, start_time, end_time, day_of_week),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `ClassTime` WRITE;
INSERT INTO `ClassTime` VALUES ("COMP3230", "12:30", "14:20", "TUE");
INSERT INTO `ClassTime` VALUES ("COMP3230", "10:30", "12:20", "THU");
INSERT INTO `ClassTime` VALUES ("COMP3278", "14:30", "15:20", "MON");
INSERT INTO `ClassTime` VALUES ("COMP3278", "13:30", "15:20", "THU");
INSERT INTO `ClassTime` VALUES ("COMP3340", "16:30", "18:20", "TUE");
INSERT INTO `ClassTime` VALUES ("COMP3340", "17:30", "18:20", "FRI");
INSERT INTO `ClassTime` VALUES ("CCHU9021", "14:30", "16:20", "WED");
INSERT INTO `ClassTime` VALUES ("CENG9001", "10:30", "12:20", "TUE");
UNLOCK TABLES;

CREATE TABLE `CourseNote` (
  `course_id` varchar(25) NOT NULL,
  `note_link` varchar(100) NOT NULL,
  PRIMARY KEY (course_id, note_link),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `CourseNote` WRITE;
INSERT INTO `CourseNote` VALUES ("COMP3230", "lecture1_note.com");
INSERT INTO `CourseNote` VALUES ("COMP3278", "lecture1_note.com");
INSERT INTO `CourseNote` VALUES ("COMP3340", "lecture1_note.com");
INSERT INTO `CourseNote` VALUES ("CCHU9021", "lecture1_note.com");
INSERT INTO `CourseNote` VALUES ("CENG9001", "lecture1_note.com");
UNLOCK TABLES;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
