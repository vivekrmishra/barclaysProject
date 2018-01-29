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
-- Dumping events for database 'barclays'
--

--
-- Dumping routines for database 'barclays'
--
/*!50003 DROP PROCEDURE IF EXISTS `createItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `createItem`(itemname varchar(45), costprice double,
sellingprice double)
BEGIN
declare v_itemid int; 
declare v_sellpriceid int;
declare v_activitycount int;

insert into itemdetails (name, costprice, status)
values (itemname, costprice, 'active');

/*select det.id from itemdetails det where det.name = itemname;*/
select det.id into v_itemid from itemdetails det where det.name = itemname and det.status='active';

insert into item_sellprice_history (itemid, sellingprice)
values(v_itemid, sellingprice);

/*select ish.sellpriceid from item_sellprice_history ish
where ish.itemid = v_itemid;
*/

select ish.sellpriceid into v_sellpriceid from item_sellprice_history ish
where ish.itemid = v_itemid;

update itemdetails det set det.sellpriceid = v_sellpriceid where det.name = itemname and det.status='active';

select count(*) into v_activitycount from activity;

if v_activitycount = 0 then
	insert into activity (activitytype, activitystatus)
	values ('report', 'success');
end if;

insert into activity (activitytype, itemid, costprice, sellpriceid, activitystatus)
values ('add', v_itemid, costprice, v_sellpriceid, 'success');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteitem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `deleteitem`(itemname varchar(45))
BEGIN
	
    declare v_itemid int;
    
    select det.id into v_itemid from itemdetails det where det.name = itemname and det.status = 'active';
    
    update itemdetails det set det.status = 'delete' where det.id=v_itemid;
    
    
    insert into activity (activitytype, itemid, activitystatus)
	values ('delete', v_itemid, 'success');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `report`()
BEGIN
	
    
    
    declare profit double;
    declare netProfit double;
    drop table if exists activity1;
    drop table if exists profitloss;
	/*DECLARE activity_cursor CURSOR FOR 
		select * from activity a where activityid > 
			(select max(a1.activityid) from activity a1 where activitytype = 'report') 
            and a.activitytype in ('updateSell', 'delete');


	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;*/
    CREATE temporary TABLE `activity1` (
  `activityid` int(11) NOT NULL AUTO_INCREMENT,
  `activitytype` varchar(45) DEFAULT NULL,
  `itemid` int(11) DEFAULT NULL,
  `costprice` double DEFAULT NULL,
  `sellpriceid` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `activitystatus` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`activityid`)
	) ;

	INSERT INTO ACTIVITY1
    select * from activity a where activityid > 
			(select max(a1.activityid) from activity a1 where activitytype = 'report') 
            and a.activitytype in ('updateSell', 'delete');
	
    create temporary table profitloss (
    net double);
    
    set profit = 0;
    set netProfit = 0;
    /*open activity_cursor;
    get_activity: loop
	
    fetch */
    insert into profitloss
    select (a.quantity * (ish.sellingprice - det.costprice))
	from ACTIVITY1 a, itemdetails det, item_sellprice_history ish
	where a.activitytype = 'updateSell' and a.itemid = det.id and det.sellpriceid = ish.sellpriceid;
	
    insert into profitloss
    select (-1 * det.costprice * det.quantity)
	from ACTIVITY1 a, itemdetails det
	where a.activitytype = 'delete' and a.itemid = det.id;
    
    select * from profitloss;
    
    select sum(net) into netProfit from  profitloss;

    insert into activity (activitytype, activitystatus)
	values ('report', 'success');
    
    select netProfit as profitsinceprevrep, det.name as itemname, det.costprice as broughtat, 
    ish.sellingprice as sellingprice, det.quantity as quantity, (det.costprice * det.quantity) as value
	from itemdetails det, item_sellprice_history ish
	where det.id = ish.itemid and det.sellpriceid = ish.sellpriceid and det.status='active' order by itemname;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateBuy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `updateBuy`(itemname varchar(45), quantity int)
BEGIN

declare v_itemid int;

update itemdetails det set det.quantity = quantity where det.name = itemname and det.status='active';

select det.id into v_itemid from itemdetails det where det.name = itemname and det.status='active';

insert into activity (activitytype, itemid, quantity, activitystatus)
values ('updateBuy', v_itemid, quantity, 'success');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateSell` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `updateSell`(itemname varchar(45), a_quantity int)
BEGIN

declare v_available int;
declare v_itemid int;

select det.quantity into v_available from itemdetails det where det.name = itemname and det.status='active';
select det.id into v_itemid from itemdetails det where det.name = itemname and det.status='active';
 
if (v_available >= a_quantity) then
	
    update itemdetails det set det.quantity = (v_available-a_quantity) where det.name = itemname and det.status='active';
    
    insert into activity (activitytype, itemid, quantity, activitystatus)
	values ('updateSell', v_itemid, a_quantity, 'success');
else
    insert into activity (activitytype, itemid, quantity, activitystatus)
	values ('updateSell', v_itemid, a_quantity, 'failure');
	
end if;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateSellPrice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `updateSellPrice`(itemname varchar(45), sellPrice double)
BEGIN

declare v_itemid int;
declare v_sellpriceid int;

select det.id into v_itemid from itemdetails det where det.name = itemname and det.status='active';

insert into item_sellprice_history (itemid, sellingprice)
values(v_itemid, sellPrice);

select ish.sellpriceid into v_sellpriceid from item_sellprice_history ish 
where ish.itemid = v_itemid and ish.sellingprice = sellPrice;

update itemdetails det set det.sellpriceid = v_sellpriceid where det.id=v_itemid and  det.status='active';

insert into activity (activitytype, itemid, sellpriceid, activitystatus)
values ('updateSellPrice', v_itemid, v_sellpriceid, 'success');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-28 22:10:40
