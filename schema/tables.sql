-- Ankoraŭ nekomplete dokumentita skemo de la mysql-datumbazo...

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
 `lng_kodo` varchar(3) COLLATE utf8_bin NOT NULL DEFAULT '',
 `lng_nomo` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '',
 PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=149 DEFAULT CHARSET=utf8 COLLATE=utf8_bin

-- Referencoj al Vikipedio:
-- vik_celref estas la marko de Revo-drivaĵo kaj vik_artikolo la paĝo (artikolo) en Vikipedio
-- per vik_revo oni povas dokumenti kapvorton kun alia literumo ol la Vikipedia vorto, sed
-- momente ni ne uzas tiun informon
CREATE TABLE `r2_vikicelo` (
  `vik_celref` varchar(60) COLLATE utf8_bin NOT NULL PRIMARY KEY,
  `vik_artikolo` varchar(60) COLLATE utf8_bin,
  `vik_revo` varchar(40) COLLATE utf8_bin DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ALTER TABLE r2_tezauro ADD INDEX (tez_kapvorto);
-- ALTER TABLE r2_tezauro ADD INDEX (tez_fontref);
-- ALTER TABLE r2_tezauro ADD INDEX (tez_celref);
-- ALTER TABLE r2_tezauro ADD INDEX (tez_celteksto);
-- ALTER TABLE r2_tezauro ADD INDEX (tez_tipo);

CREATE TABLE `r2_tezauro` (
  `tez_kapvorto` varchar(20) COLLATE utf8_bin NOT NULL,
  `tez_fontteksto` varchar(40) COLLATE utf8_bin NOT NULL DEFAULT '',
  `tez_fontref` varchar(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `tez_fontn` smallint(2) DEFAULT NULL,
  `tez_celteksto` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `tez_celref` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `tez_celn` smallint(2) DEFAULT NULL,
  `tez_tipo` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `tez_fako` varchar(6) COLLATE utf8_bin DEFAULT NULL,
  `tez_tushita` tinyint(1) NOT NULL DEFAULT '1',
  `tez_dato` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `tez_kapvorto` (`tez_kapvorto`),
  KEY `tez_fontref` (`tez_fontref`),
  KEY `tez_celref` (`tez_celref`),
  KEY `tez_celteksto` (`tez_celteksto`),
  KEY `tez_tipo` (`tez_tipo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin

CREATE TABLE `r2_indekso` (
 `ind_id` bigint(20) NOT NULL AUTO_INCREMENT,
 `ind_kapvorto` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '',
 `ind_teksto` varchar(45) COLLATE utf8_bin NOT NULL DEFAULT '',
 `ind_traduko` varchar(150) COLLATE utf8_bin DEFAULT NULL,
 `ind_trdgrp` varchar(45) COLLATE utf8_bin DEFAULT NULL,
 `ind_kat` char(3) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
 `ind_subkat` varchar(6) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
 `ind_celref` varchar(60) COLLATE utf8_bin NOT NULL DEFAULT '',
 `ind_ord` varchar(45) COLLATE utf8_bin DEFAULT NULL,
 `ind_subord` varchar(45) COLLATE utf8_bin DEFAULT NULL,
 `ind_ord2` varchar(45) COLLATE utf8_bin DEFAULT NULL,
 `ind_tushita` tinyint(1) unsigned DEFAULT '1',
 `ind_dato` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 `ind_kaplit` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
 PRIMARY KEY (`ind_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4054838 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `r2_kat` (
 `kat_kat` varchar(6) COLLATE latin1_bin NOT NULL DEFAULT '',
 `kat_tipo` char(3) COLLATE latin1_bin NOT NULL DEFAULT '',
 `kat_nomo` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '',
 PRIMARY KEY (`kat_kat`,`kat_tipo`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


