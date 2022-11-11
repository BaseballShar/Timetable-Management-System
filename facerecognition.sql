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
INSERT INTO `Student` VALUES (1, "JACK", NOW(), '2021-01-20', "shar@sharmail.sharcom.shar");
/*!40000 ALTER TABLE `Student` ENABLE KEYS */;
UNLOCK TABLES;


# Create TABLE 'Course'
CREATE TABLE `Course` (
  `course_id` varchar(25) NOT NULL PRIMARY KEY,
  `zoom_link` varchar(100) NOT NULL,
  `teacher_msg` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Course` WRITE;
INSERT INTO `Course` VALUES ("COMP3278", "hi.zoom", "Please finish your asm");
UNLOCK TABLES;

# Create TABLE 'Classroom'
CREATE TABLE `Classroom` (
  `room_id` varchar(25) NOT NULL PRIMARY KEY,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Classroom` WRITE;
INSERT INTO `Classroom` VALUES ("MTW2", "Ming Wah Complex 2");
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
UNLOCK TABLES;

CREATE TABLE `TakePlace` (
  `room_id` varchar(25) NOT NULL,
  `course_id` varchar(25) NOT NULL,
  PRIMARY KEY (room_id, course_id),
  FOREIGN KEY (room_id) REFERENCES Classroom (room_id),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TakePlace` WRITE;
INSERT INTO `TakePlace` VALUES ("MTW2", "COMP3278");
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
INSERT INTO `ClassTime` VALUES ("COMP3278", "10:30", "12:30", "FRI");
UNLOCK TABLES;

CREATE TABLE `CourseNote` (
  `course_id` varchar(25) NOT NULL,
  `note_link` varchar(100) NOT NULL,
  PRIMARY KEY (course_id, note_link),
  FOREIGN KEY (course_id) REFERENCES Course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `CourseNote` WRITE;
INSERT INTO `CourseNote` VALUES ("COMP3278", "lecture1_note.com");
UNLOCK TABLES;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
