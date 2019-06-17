
-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `usr_web277_1` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `usr_web277_1`;

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