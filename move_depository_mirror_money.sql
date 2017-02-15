DELIMITER $$

USE `zzjr_bank`$$

DROP PROCEDURE IF EXISTS `move_depository_mirror_money`$$

CREATE DEFINER=`root`@`%` PROCEDURE `move_depository_mirror_money`()
label_pro:BEGIN
	
DECLARE err INT DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
START TRANSACTION; 
CREATE TABLE IF NOT EXISTS `depository_mirror_money_move_log` (
  `id` INT(8) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mirror_id_begin` BIGINT(18) NOT NULL COMMENT '迁移操作的开始镜像ID',
  `mirror_id_end` BIGINT(18) NOT NULL COMMENT '迁移操作的结束镜像ID',
  `move_mirror_begin_day` DATE DEFAULT NULL COMMENT '需要迁移的镜像的开始日期',
  `move_mirror_end_day` DATE DEFAULT NULL COMMENT '需要迁移的镜像的结束日期',
  `status` TINYINT(1) DEFAULT NULL COMMENT '镜像迁移的状态：1、成功，其他、未成功',
  `history_table_name` VARCHAR(50) NOT NULL COMMENT '历史表的名称(如“depository_mirror_money_history_2016-02-19”）',
  `gmt_create` DATETIME DEFAULT NULL COMMENT '迁移开始时间',
  `gmt_modify` DATETIME DEFAULT NULL COMMENT '迁移结束时间',
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=10000001 DEFAULT CHARSET=utf8;
  SELECT MAX(move_mirror_end_day) FROM depository_mirror_money_move_log INTO @last_day;
  IF (@last_day IS NULL) THEN
    SELECT CONCAT('depository_mirror_money_history_',DATE_FORMAT(CURDATE(),'%Y%m%d')) INTO @history_table_name; 
  ELSE
    SELECT history_table_name FROM depository_mirror_money_move_log ORDER BY id DESC LIMIT 1 INTO @history_table_name;
    SET @STMT := CONCAT("select count(*) from ", @history_table_name, " into @history_count",";");
    PREPARE STMT FROM @STMT;
    EXECUTE STMT; 
    IF (@history_count > 2000000) THEN
       SELECT CONCAT('depository_mirror_money_history_',DATE_FORMAT(CURDATE(),'%Y%m%d')) INTO @history_table_name;
    END IF;
  END IF; 
  
  SET @STMT := CONCAT("CREATE TABLE IF NOT EXISTS ", @history_table_name , " (
   `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` bigint(18) NOT NULL COMMENT '会员ID',
  `platcust` varchar(32) NOT NULL COMMENT '存管平台客户号(冗余)',
  `record_day` date NOT NULL COMMENT '记录日期如：2015-10-15',
  `mirror_cash_amount` bigint(22) NOT NULL DEFAULT '0' COMMENT '现金投资账户镜像，以每日23:59:59镜像时的金额为准',
  `mirror_otw_amount` bigint(22) NOT NULL DEFAULT '0' COMMENT '在途投资账户镜像，以每日23:59:59镜像时的金额为准',
  `frozen_cash_amount` bigint(22) DEFAULT '0' COMMENT '现金账户冻结金额(含手续费)',
  `withdraw_fee` bigint(22) DEFAULT '0' COMMENT '提现手续费(实时手续费,出账成功后减掉)',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0：未处理(未对账)，1：已处理(已对账)',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_mirror_memberid_recordday` (`record_day`,`member_id`) USING BTREE,
  KEY `idx_platcust` (`platcust`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100000000002166152 DEFAULT CHARSET=utf8 COMMENT='银行存管每日资金镜像表';");
  
  
  PREPARE STMT FROM @STMT;
  EXECUTE STMT; 
  SELECT MAX(id) FROM `depository_mirror_money` WHERE record_day < DATE_SUB(CURDATE(),INTERVAL 6 DAY) INTO @id_end;
  SELECT MIN(id) FROM `depository_mirror_money` WHERE record_day < DATE_SUB(CURDATE(),INTERVAL 6 DAY) INTO @id_begin;
  SELECT MAX(record_day) FROM `depository_mirror_money` WHERE record_day < DATE_SUB(CURDATE(),INTERVAL 6 DAY) INTO @day_end;
  SELECT MIN(record_day) FROM `depository_mirror_money` WHERE record_day < DATE_SUB(CURDATE(),INTERVAL 6 DAY) INTO @day_begin;
  
  IF (@id_end IS NULL OR @id_begin IS NULL OR @day_begin IS NULL OR @day_end IS NULL) THEN
    SELECT '无数据需要迁移';
    LEAVE label_pro;
  END IF;
  
  IF (@last_day IS NULL OR @last_day < DATE_SUB(CURDATE(),INTERVAL 7 DAY)) THEN
    SET @STMT := CONCAT("insert into depository_mirror_money_move_log (mirror_id_begin,mirror_id_end,move_mirror_begin_day,move_mirror_end_day,`status`,history_table_name,gmt_create) value(", @id_begin, ",",@id_end,",'",@day_begin,"','",@day_end,"',0,'",@history_table_name,"',NOW());");
    PREPARE STMT FROM @STMT;
    EXECUTE STMT; 
    
    SET @STMT := CONCAT("insert into ", @history_table_name, " SELECT * from depository_mirror_money where record_day < DATE_SUB(curdate(),INTERVAL 6 DAY);");
    PREPARE STMT FROM @STMT;
    EXECUTE STMT; 
    DELETE FROM depository_mirror_money WHERE record_day < DATE_SUB(CURDATE(),INTERVAL 6 DAY);
    SET @STMT := CONCAT("update depository_mirror_money_move_log set status=1,gmt_modify=NOW() where move_mirror_begin_day = '",@day_begin,"' AND move_mirror_end_day = '",@day_end,"' LIMIT 1;");
    PREPARE STMT FROM @STMT;
    EXECUTE STMT; 
  END IF;  
    
IF (err=0) THEN
    COMMIT;
    SELECT 'OK';
ELSE
    ROLLBACK;
    SELECT 'err';
END IF;
  
END$$

DELIMITER ;
