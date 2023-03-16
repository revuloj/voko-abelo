-- Ankoraŭ nekomplete dokumentita skemo de la mysql-datumbazo...

-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db314802x3159000` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_bin */;


-- oni povas demandi la aktualan tabel-difinon tiel:
-- SHOW CREATE TABLE db314802x3159000.r2_vikicelo;

USE `db314802x3159000`;

CREATE TABLE `email` (
  `ema_red_id` int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `ema_email` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ema_sort` int(11) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `ema_email` (`ema_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `redaktanto` (
  `red_id`	int	unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,	
	`red_nomo`	varchar(30)	CHARACTER SET utf8 NOT NULL DEFAULT '',
	`red_kodvorto`	varchar(20)	CHARACTER SET utf8 DEFAULT '',
	`red_sessid`	bigint(20) unsigned DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  

CREATE TABLE `submeto` (
  `sub_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sub_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sub_state` ENUM('nov','trakt','arkiv','erar','ignor') NOT NULL DEFAULT 'nov', 
                                -- trakt' = traktata, 'arkiv' = akceptita/arkivita, 'eraro' = rifuzita pro eraro
                                -- ignor ni uzas por testado
  `sub_email` VARCHAR(50) CHARACTER SET utf8 NOT NULL,
  `sub_cmd` VARCHAR(20) CHARACTER SET utf8 NOT NULL DEFAULT 'redakto', -- 'aldono' por nova dosiero, principe eblus ankau forigo!
  `sub_desc` VARCHAR(255) CHARACTER SET utf8 NOT NULL, -- la ŝanĝpriskribo
  `sub_type` VARCHAR(20) CHARACTER SET utf8 NOT NULL DEFAULT 'xml', -- 'zip/xml' por kunpremita xml
  `sub_fname` VARCHAR(50) CHARACTER SET utf8 NOT NULL, -- ĉe 'aldono' la nomo de nova dosiero
  `sub_content` MEDIUMBLOB NOT NULL,
  `sub_result` BLOB,
  INDEX inx_sub_state(`sub_state`),
  INDEX inx_sub_email(`sub_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  


CREATE TABLE `lng` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lng_kodo` varchar(4) COLLATE utf8_bin NOT NULL DEFAULT '',
  `lng_nomo` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=149 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Referencoj al Vikipedio:
-- vik_celref estas la marko de Revo-derivaĵo kaj vik_artikolo la paĝo (artikolo) en Vikipedio
-- per vik_revo oni povas dokumenti kapvorton kun alia literumo ol la Vikipedia vorto, sed
-- momente ni ne uzas tiun informon
CREATE TABLE `r2_vikicelo` (
  `vik_celref` varchar(60) COLLATE utf8_bin NOT NULL PRIMARY KEY,
  `vik_artikolo` varchar(60) COLLATE utf8_bin,
  `vik_revo` varchar(40) COLLATE utf8_bin DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ALTER TABLE lng MODIFY lng_kodo VARCHAR(4);

