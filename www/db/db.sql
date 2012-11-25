-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 25, 2012 at 07:25 AM
-- Server version: 5.5.25
-- PHP Version: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `weatherapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` int(5) NOT NULL AUTO_INCREMENT COMMENT 'city id [PK]',
  `city` varchar(20) NOT NULL DEFAULT '' COMMENT 'city name',
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `lat` decimal(10,5) NOT NULL COMMENT 'cit latitude',
  `lng` decimal(10,5) NOT NULL COMMENT 'city long',
  `zipcode` int(10) DEFAULT NULL COMMENT 'accepts whatever length...?',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`id`, `city`, `state`, `country`, `lat`, `lng`, `zipcode`) VALUES
(1, 'New York', 'NY', 'USA', 40.74232, -73.98799, NULL),
(2, 'San Francisco', 'CA', 'USA', 37.77493, -122.41942, NULL),
(3, 'Toronto', 'ON', 'CA', 43.65323, -79.38318, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `temps`
--

CREATE TABLE `temps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `city_id` int(11) NOT NULL,
  `temperature` decimal(10,5) NOT NULL,
  `date_stamp` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='saves all temperatures in here.' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `temps`
--

INSERT INTO `temps` (`id`, `city_id`, `temperature`, `date_stamp`) VALUES
(1, 1, 3.00000, '2012-11-25'),
(2, 2, 12.00000, '2012-11-25'),
(3, 3, 0.00000, '2012-11-25');
