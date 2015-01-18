-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 27, 2012 at 07:17 PM
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
  `zipcode` int(10) NOT NULL DEFAULT '0' COMMENT 'accepts whatever length...?',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`id`, `city`, `state`, `country`, `lat`, `lng`, `zipcode`) VALUES
(1, 'New York', 'NY', 'USA', 40.74232, -73.98799, 0),
(2, 'San Francisco', 'CA', 'USA', 37.77493, -122.41942, 0),
(3, 'Toronto', 'ON', 'CA', 43.65323, -79.38318, 0),
(4, 'Chicago', 'IL', 'USA', 41.87811, -87.62980, 0),
(5, 'Los Angeles', 'CA', 'USA', 34.05223, -118.24369, 0),
(6, 'Houston', 'TX', 'USA', 29.76019, -95.36939, 0),
(7, 'Philadelphia', 'PA', 'USA', 39.95234, -75.16379, 0),
(8, 'Phoenix', 'AZ', 'USA', 33.44838, -112.07404, 0),
(9, 'San Diego', 'CA', 'USA', 32.71533, -117.15726, 0),
(10, 'Vancouver', 'BC', 'CA', 49.26123, -123.11393, 0),
(11, 'Tokyo', '', 'JP', 35.68949, 139.69171, 0),
(12, 'Berlin', NULL, 'DE', 52.51917, 13.40609, 0),
(13, 'Seóul', NULL, 'KR', 37.56654, 126.97797, 0),
(14, 'Mexico City', '', 'MX', 19.43261, -99.13321, 0),
(15, 'Mumbai', NULL, 'IN', 19.07598, 72.87766, 0),
(16, 'Sáo Paulo', NULL, 'BZ', -23.54894, -46.63882, 0),
(17, 'Shanghai', NULL, 'CN', 31.23039, 121.47370, 0),
(18, 'Hong Kong', NULL, 'CN', 22.39643, 114.10950, 0),
(19, 'Moscow', NULL, 'RS', 55.75124, 37.61842, 0),
(20, 'London', NULL, 'UK', 51.50734, -0.12768, 0),
(21, 'Paris', NULL, 'FR', 48.85661, 2.35222, 0),
(22, 'Tel Aviv', NULL, 'IL', 32.06616, 34.77782, 0),
(23, 'Rome', NULL, 'IT', 41.90151, 12.46077, 0);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='saves all temperatures in here.' AUTO_INCREMENT=59 ;

--
-- Dumping data for table `temps`
--

INSERT INTO `temps` (`id`, `city_id`, `temperature`, `date_stamp`) VALUES
(1, 1, 3.00000, '2012-11-25'),
(3, 3, 0.00000, '2012-11-25'),
(7, 2, 12.00000, '2012-11-25'),
(8, 1, 6.00000, '2012-11-26'),
(9, 2, 7.00000, '2012-11-26'),
(10, 3, 3.00000, '2012-11-26'),
(36, 1, 2.00000, '2012-11-27'),
(37, 2, 14.00000, '2012-11-27'),
(38, 3, 3.00000, '2012-11-27'),
(39, 4, 0.00000, '2012-11-27'),
(40, 5, 14.00000, '2012-11-27'),
(41, 6, 13.00000, '2012-11-27'),
(42, 7, 3.00000, '2012-11-27'),
(43, 8, 17.00000, '2012-11-27'),
(44, 9, 16.00000, '2012-11-27'),
(45, 10, 1.00000, '2012-11-27'),
(46, 11, 8.00000, '2012-11-27'),
(47, 12, 7.00000, '2012-11-27'),
(48, 13, 2.00000, '2012-11-27'),
(49, 14, 18.00000, '2012-11-27'),
(50, 15, 25.00000, '2012-11-27'),
(51, 16, 27.00000, '2012-11-27'),
(52, 17, 6.00000, '2012-11-27'),
(53, 18, 15.00000, '2012-11-27'),
(54, 19, 0.00000, '2012-11-27'),
(55, 20, 7.00000, '2012-11-27'),
(56, 21, 7.00000, '2012-11-27'),
(57, 22, 19.00000, '2012-11-27'),
(58, 23, 16.00000, '2012-11-27');
