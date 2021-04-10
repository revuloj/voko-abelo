USE `db314802x3159000`;

-- kapvortoj kun referenco al drv@mrk:
-- mrk: drv@mrk, var: tld@var
-- ofc: la unua (se escepte estas pluraj) ofc de la kapvorto: *, 1-9, 1953...
CREATE TABLE `r3kap` (
    `kap` VARCHAR(100) NOT NULL,
    `mrk` VARCHAR(100) NOT NULL,
    `var` VARCHAR(10) NOT NULL DEFAULT '',
    `ofc` VARCHAR(10) NOT NULL DEFAULT '',
    KEY `kap` (`kap`),
    KEY `mrk` (`mrk`),
    KEY `var` (`var`),
    KEY `ofc` (`ofc`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- markoj, t.e. adreseblaj celoj drv, mrk, snc, subsnc, rim (=ele)
-- num: aŭtomate atribuita numeroj, aparte de snc/subsnc: 1, 2a, 2b...
-- drv: drv@mrk por konekti al r3kap.mrk
CREATE TABLE `r3mrk` (
    `mrk` VARCHAR(100) NOT NULL PRIMARY KEY,
    `ele` VARCHAR(10) NOT NULL,
    `num` VARCHAR(10) NOT NULL DEFAULT '',
    `drv` VARCHAR(100),
    KEY `mrk` (`mrk`),
    KEY `ele` (`ele`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- referencoj, i.a. por la tezaŭro, 'mrk' kaj 'cel' estas atributoj @mrk 
-- tradukeblaj al kapvortoj kaj numeroj per la tabeloj r3mrk kaj r3kap
-- tip: interne estas cifera kolumno kun '' = 0, 'vid' = 1 ... 'sin' = 10
CREATE TABLE `r3ref` (
    `mrk` VARCHAR(100) NOT NULL,
    `tip` ENUM('','vid','ekz','lst','prt','malprt','sub','super','hom','ant','sin','dif') DEFAULT '',
    `cel` VARCHAR(100) NOT NULL,
    `lst` VARCHAR(100),
    KEY `mrk` (`mrk`),
    KEY `cel` (`cel`),
    KEY `tip` (`tip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- mankis 'dif'
-- ALTER TABLE r3ref MODIFY COLUMN `tip` ENUM('','vid','ekz','lst','prt','malprt','sub','super','hom','ant','sin','dif') DEFAULT ''

-- rigardo por kolekti la referencojn en ambaŭ direktoj kaj
-- ligi ilin al la celata kapvorto
-- NOTO: kiel trakti variaĵojn? cu ekskludi per var='' aŭ
-- havi linion po variaĵo?
CREATE OR REPLACE VIEW `v3tezauro` AS
SELECT r.mrk, r.tip, r.cel, r.lst, k.kap, k.var, m.num
FROM (
    SELECT mrk, tip, cel, lst 
    FROM `r3ref`
  UNION 
    SELECT cel AS `mrk`,
      CASE tip WHEN 'prt' THEN 'malprt' WHEN 'malprt' THEN 'prt'
               WHEN 'sub' THEN 'super' WHEN 'super' THEN 'sub'
               WHEN 'ekz' THEN 'super' WHEN 'lst' THEN 'ekz'
               WHEN 'dif' THEN 'sin'
      ELSE tip END AS `tip`, 
    mrk AS `cel`, NULL AS `lst`
    FROM `r3ref`
) AS r
INNER JOIN r3mrk m ON r.cel = m.mrk
INNER JOIN r3kap k ON m.drv = k.mrk;

-- tradukoj por la serĉo de ne-esperantaj vortoj
-- trd: la unuopa tradukvorto, se gi enhavas klr@tip=ind aŭ klr@tip=amb, tiu estas parto
-- ind: la indksita ŝlosilvorto <ind>...</ind>
-- lng: lingvo-kodo
-- mrk: referenco kie la traduko troviĝas, se gi estas en ekz aŭ snc sen @mrk, tio estas
--      la sekva plej proksima @mrk (de snc, drv...), gi servu por trovi la kapvortoj per -- 'mrk' -- 'kap'
-- ekz: se temas pri traduko de ekzemplo, ties parto inter <ind>...</ind>
-- CREATE TABLE `r3trd` (
--     `trd` VARCHAR(255) NOT NULL,
--     `ind` VARCHAR(100) NOT NULL,
--     `lng` VARCHAR(3) NOT NULL,
--     `mrk` VARCHAR(100) NOT NULL,
--     `ekz` VARCHAR(255) NOT NULL,
--     KEY `trd` (`trd`),
--     KEY `ind` (`ind`),
--     KEY `lng` (`lng`),
--     KEY `mrk` (`mrk`),
-- ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;