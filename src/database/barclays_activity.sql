CREATE DATABASE  IF NOT EXISTS `barclays` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `barclays`;
-- MySQL dump 10.13  Distrib 5.6.23, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: barclays
-- ------------------------------------------------------
-- Server version	5.6.24-enterprise-commercial-advanced-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity` (
  `activityid` int(11) NOT NULL AUTO_INCREMENT,
  `activitytype` varchar(45) DEFAULT NULL,
  `itemid` int(11) DEFAULT NULL,
  `costprice` double DEFAULT NULL,
  `sellpriceid` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `activitystatus` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`activityid`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity`
--

LOCK TABLES `activity` WRITE;
/*!40000 ALTER TABLE `activity` DISABLE KEYS */;
INSERT INTO `activity` VALUES (1,'report',NULL,NULL,NULL,NULL,'success'),(2,'add',1,10.5,1,NULL,'success'),(3,'add',2,1.47,2,NULL,'success'),(4,'add',3,30.63,3,NULL,'success'),(5,'add',4,57,4,NULL,'success'),(6,'updateBuy',4,NULL,NULL,100,'success'),(7,'updateSell',4,NULL,NULL,2,'success'),(8,'updateBuy',2,NULL,NULL,500,'success'),(9,'updateBuy',1,NULL,NULL,100,'success'),(10,'updateBuy',3,NULL,NULL,100,'success'),(11,'updateSell',2,NULL,NULL,1,'success'),(12,'updateSell',2,NULL,NULL,1,'success'),(13,'updateSell',4,NULL,NULL,2,'success'),(14,'report',NULL,NULL,NULL,NULL,'success'),(15,'delete',1,NULL,NULL,NULL,'success'),(16,'updateSell',4,NULL,NULL,5,'success'),(17,'add',5,10.51,5,NULL,'success'),(18,'updateBuy',5,NULL,NULL,250,'success'),(19,'updateSell',2,NULL,NULL,5,'success'),(20,'updateSell',5,NULL,NULL,4,'success'),(21,'updateSell',3,NULL,NULL,10,'success'),(22,'report',NULL,NULL,NULL,NULL,'success'),(23,'updateSell',5,NULL,NULL,10,'success'),(27,'report',NULL,NULL,NULL,NULL,'success');
/*!40000 ALTER TABLE `activity` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-28 22:10:39
