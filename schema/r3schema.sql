USE `db314802x3159000`;

-- kapvortoj kun referenco al drv@mrk:
-- mrk: drv@mrk, var: tld@var
-- ofc: la unua (se escepte estas pluraj) ofc de la kapvorto: *, 1-9, 1953...
CREATE TABLE `r3kap` (
    `kap` VARCHAR(100) NOT NULL COLLATE=utf8_esperanto_ci,
    `mrk` VARCHAR(100) NOT NULL,
    `var` VARCHAR(10) NOT NULL DEFAULT '',
    `ofc` VARCHAR(10) NOT NULL DEFAULT '',
    KEY `kap` (`kap`),
    KEY `mrk` (`mrk`),
    KEY `var` (`var`),
    KEY `ofc` (`ofc`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- PLIBONIGU: ebligu serĉi kapvortojn sen distingi inter minusklaj kaj majusklaj vortoj:
-- alter table r3kap  MODIFY COLUMN kap VARCHAR(100) NOT NULL COLLATE utf8mb4_general_ci


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
-- ĉu ni bezonas ankaŭ? ALTER TABLE r3mrk ADD INDEX(drv);

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

-- tradukoj por la serĉo de ne-esperantaj vortoj
-- ind: la indeksita ŝlosilvorto <ind>...</ind> aŭ se tiu ne enestas en 'trd' la tuta teksto (sed sen ofc, klr)
-- trd: la unuopa tradukvorto, se ĝi enhavas klr, tiu enestas, se enestas mll - nur tiu parto
-- lng: lingvo-kodo
-- mrk: referenco kie la traduko troviĝas, se gi estas en ekz aŭ snc sen @mrk, tio estas
--      la sekva plej proksima @mrk (de snc, drv...), ĝi servu por trovi la kapvortoj per -- 'mrk' -- 'kap'
-- ekz: se temas pri traduko de ekzemplo, ties parto inter <ind>...</ind>
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

--- PLIBONIGU: uzu unicode_ci utf8_ci por ind - por trovi majusklajn kaj minusklajn per sama serĉo
-- alter table r3trd CONVERT TO CHARACTER SET utf8mb4 utf8mb4_general_ci
-- alter table r3trd  MODIFY COLUMN ind VARCHAR(100) NOT NULL COLLATE utf8mb4_general_ci
-- alter table r3trd  MODIFY COLUMN trd VARCHAR(100) NOT NULL COLLATE utf8mb4_general_ci

-- mankis 'dif'
-- ALTER TABLE r3ref MODIFY COLUMN `tip` ENUM('','vid','ekz','lst','prt','malprt','sub','super','hom','ant','sin','dif') DEFAULT ''

-- rigardo por kolekti la referencojn en ambaŭ direktoj kaj
-- ligi ilin al la celata kapvorto
-- NOTO: kiel trakti variaĵojn? cu ekskludi per var='' aŭ
-- havi linion po variaĵo?

-- PLIBONIGU: Ĝi daŭras ankoraŭ tro longe, sed verŝajne oni povas ankoraŭ plibonigi ĝin
-- Vd. EXPLAIN select * from v3tezauro where mrk like 'abak.%'; 
-- https://dev.mysql.com/doc/refman/5.7/en/explain-output.html
-- https://dev.mysql.com/doc/refman/5.7/en/outer-join-optimization.html

-- Ŝajnas pli rapide do fari la unuopajn du SQL en Perl kaj tie kunigi la rezulton!

-- CREATE OR REPLACE VIEW `v3tezauro` AS
-- SELECT r.mrk, r.tip, r.cel, r.lst, k.kap, k.var, m.num
-- FROM (
--     SELECT mrk, tip, cel, lst 
--     FROM `r3ref`
--   UNION 
--     SELECT cel AS `mrk`,
--       CASE tip WHEN 'prt' THEN 'malprt' WHEN 'malprt' THEN 'prt'
--                WHEN 'sub' THEN 'super' WHEN 'super' THEN 'sub'
--                WHEN 'ekz' THEN 'super' WHEN 'dif' THEN 'sin'
--       ELSE tip END AS `tip`, 
--     mrk AS `cel`, NULL AS `lst`
--     FROM `r3ref` WHERE tip <> 'lst'
-- ) AS r
-- INNER JOIN r3mrk m ON r.cel = m.mrk
-- INNER JOIN r3kap k ON m.drv = k.mrk AND k.var = '';

-- uzebla kiel select * from v3tradukoj where ind like 'abak%'
-- sed tio daŭras multe pli longe ol rekte serĉante per SELECT...

-- Atentu: tiuj JOIN funkcias nur rapide uzante indeksojn (mrk) se tiuj kolumnoj havas
-- ekzakte la saman specifon. LEFT JOIN ŝajnas pli rapide ol INNER JOIN - oni ja povas
-- poste forigi eventualajn troajn liniojn per WHERE kap is NOT NULL aŭ simile!

-- oni povas demandi la aktualan tabel-difinon tiel:
-- SHOW CREATE TABLE db314802x3159000.r3trd;

CREATE OR REPLACE VIEW `v3traduko` AS
SELECT t.mrk, t.lng, t.ind, t.trd, k.kap, k.var, m.num 
FROM `r3trd` t
LEFT JOIN `r3mrk` m ON t.mrk = m.mrk
LEFT JOIN `r3kap` k ON m.drv = k.mrk;

-- por serĉi e-e kun tradukoj:
ALTER TABLE `r3mrk` ADD INDEX (drv);
--ALTER TABLE `r3kap` MODIFY `kap` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `r3kap` MODIFY `kap` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_esperanto_ci;

CREATE OR REPLACE VIEW `v3esperanto` AS
SELECT k.kap, k.var, m.num, t.mrk, t.lng, t.ind, t.trd 
FROM r3kap k 
LEFT JOIN r3mrk m ON k.mrk=m.drv
LEFT JOIN r3trd t ON t.mrk=m.mrk;
-- LEFT JOIN r3trd t ON k.mrk LIKE t.mrk || '%'


