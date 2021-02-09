
-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db314802x3159000` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_bin */;

USE `db314802x3159000`;

CREATE TABLE `email` (
  `ema_red_id` int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,,
  `ema_email` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ema_sort` int(11) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `ema_email` (`ema_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `redaktanto` (
  `red_id`	int	unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,,	
	`red_nomo`	varchar(30)	 CHARACTER SET utf8 NOT NULL DEFAULT '',
	`red_kodvorto`	varchar(20)	CHARACTER SET utf8 DEFAULT '',
	`red_sessid`	bigint(20)	unsigned DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  

CREATE TABLE `submeto` (
  `sub_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sub_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sub_state` ENUM('nova','trakt','arkiv','eraro') NOT NULL DEFAULT 'nova', 
                                -- trakt' = traktata, 'arkiv' = akceptita/arkivita, 'eraro' = rifuzita pro eraro
  `sub_email` VARCHAR(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `sub_cmd` VARCHAR(20) CHARACTER SET utf8 NOT NULL DEFAULT '', -- 'aldono' por nova dosiero, principe eblus ankau forigo!
  `sub_desc` VARCHAR(255) CHARACTER SET utf8 NOT NULL DEFAULT '', -- la ŝanĝpriskribo
  `sub_type` VARCHAR(20) CHARACTER SET utf8 NOT NULL DEFAULT 'xml', -- 'zip/xml' por kunpremita xml
  `sub_fname` VARCHAR(50) CHARACTER SET utf8 NOT NULL DEFAULT '', -- ĉe 'aldono' la nomo de nova dosiero
  `sub_content` MEDIUMBLOB NOT NULL,
  INDEX inx_sub_state(`sub_state`),
  INDEX inx_sub_email(`sub_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  
