
-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db314802x3159000` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_bin */;

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



CREATE TABLE `r3trd` (
    `mrk` VARCHAR(100) NOT NULL,
    `lng` VARCHAR(3) NOT NULL,
    `ind` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `trd` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `ekz` VARCHAR(255),
    KEY `mrk` (`mrk`),
    KEY `lng` (`lng`),
    KEY `ind` (`ind`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE OR REPLACE VIEW `v3traduko` AS
SELECT t.mrk, t.lng, t.ind, t.trd, k.kap, k.var, m.num 
FROM `r3trd` t
LEFT JOIN `r3mrk` m ON t.mrk = m.mrk
LEFT JOIN `r3kap` k ON m.drv = k.mrk;

-- por seeĉi e-e kun tradukoj:

ALTER TABLE r3mrk ADD INDEX (drv);
ALTER TABLE `r3kap` MODIFY `kap` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_esperanto_ci;


CREATE OR REPLACE VIEW `v3esperanto` AS
SELECT k.kap, k.var, m.num, t.mrk, t.lng, t.ind, t.trd 
FROM r3kap k 
LEFT JOIN r3mrk m ON k.mrk=m.drv
LEFT JOIN r3trd t ON t.mrk=m.mrk;
-- LEFT JOIN r3trd t ON k.mrk LIKE t.mrk || '%'
