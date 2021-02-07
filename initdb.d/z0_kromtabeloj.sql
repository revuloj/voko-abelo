
-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db314802x3159000` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_bin */;

USE `db314802x3159000`;

CREATE TABLE `email` (
  `ema_red_id` int(11) unsigned NOT NULL DEFAULT 0,
  `ema_email` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ema_sort` int(11) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `ema_email` (`ema_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `redaktanto` (
  `red_id`	int(11)	unsigned NOT NULL DEFAULT 0,	
	`red_nomo`	varchar(30)	 CHARACTER SET utf8 NOT NULL DEFAULT '',
	`red_kodvorto`	varchar(20)	CHARACTER SET utf8 DEFAULT '',
	`red_sessid`	bigint(20)	unsigned DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  

-- CREATE TABLE `submeto` (
--   `sub_tempo` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP PRIMARY KEY,
--   `sub_email` VARCHAR(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
--   `sub_type` VARCHAR(20) CHARACTER SET utf8 NOT NULL DEFAULT 'xml',
--   `sub_content` MEDIUMBLOB NOT NULL
-- ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  