
-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `usr_web277_1` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `usr_web277_1`;

CREATE TABLE `email` (
  `ema_red_id` int(11) unsigned NOT NULL DEFAULT 0,
  `ema_email` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ema_sort` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`ema_red_id`),
  UNIQUE KEY `ema_email` (`ema_email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


