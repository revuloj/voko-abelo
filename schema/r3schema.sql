USE `db314802x3159000`;

-- La tabeloj pleniĝas el JSON-dosieroj en revo/tez/, kiujn ni ekstraktas el
-- la XML-fontoj de la artikoloj, enhavantaj kap, mrk, ref, trd.
-- 
-- La tezaŭro kaj serĉo poste uzas tiujn tabeloj resp. la rigardojn v3*
-- 
-- Pri la signaroj:
-- 
-- Por e-aj kolumnoj ni uzas CHARSET=utf8, sed por nacilingvaj kolumnoj utf8mb4. La kaŭzo estas, ke utf8 estas kripligita 
-- permesantaj nur unikodajn signojn ĝis 3-bitokajn. Tamen ĝi havas la avantaĝon, ke ekz-e por indeksoj ĝi rezervas  
-- nur 3 anst. 4 bitokoj, kaj en la servilo retavortaro.de la indekso estas limigita al maks. mil bitokoj, kiu ne sufiĉus 
-- por r3trd.
-- 
-- Por la kolumnoj mrk principe ni ne bezonus uft8, ĉar ili devus esti askiaj, tamen foje enŝteliĝas e-a litero, do ni  
-- elektis pli sekure ankaŭ utf8. Por serĉkampoj kap, ind, ekz, kie ni ne volas distingi inter majuskloj kaj minuskloj ni  
-- elektis ordigilojn _ci (case insensitive), cetere la elekto _general_ ankaŭ ne distingas supersignitajn literojn, kio  
-- helpas serĉadon en lingvoj kiel la franca ks. Por kap ni elekits utf8_esperanto_ci, kiu ebligas ordigi laŭ reguloj de  
-- Esperanto, kion ni en la serĉo tamen ne uzas, ĉar post regrupigo ni ĉiuokaze devos reordigi en la retumiloj per 
-- Javoskripto.
--
-- La indeksoj kaj rigardoj v3* estas tiel aranĝitaj, ke la serĉoj, kiujn ni efektive faras en la tezaŭro kaj serĉilo  
-- funkciu plej eble rapidaj. MySQL alie ol ekz-e Oracle estas relative sentema pri tio, t.e. malgranda ŝanĝeto jam faras 
-- diferencon inter 0,005 kaj 0,5s aŭ eĉ 5s do la cent- aŭ miloblon.

-- oni povas demandi la aktualan tabel-difinon tiel:
-- SHOW CREATE TABLE db314802x3159000.r3trd;


-- kapvortoj kun referenco al drv@mrk:
-- mrk: drv@mrk, var: tld@var
-- ofc: la unua (se escepte estas pluraj) ofc de la kapvorto: *, 1-9, 1953...
CREATE TABLE `r3kap` (
    `kap` VARCHAR(100) NOT NULL COLLATE utf8_esperanto_ci,
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
    KEY `ele` (`ele`),
    KEY `drv` (`drv`)
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
    `ekz` VARCHAR(255) COLLATE utf8_esperanto_ci NOT NULL,
    KEY `mrk` (`mrk`),
    KEY `lng` (`lng`),
    KEY `ind` (`ind`),
    KEY `ekz` (`ekz`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Referencoj al FdE kaj OA:
-- inx: indeksita vorto, radiko k.s.
-- mrk: marko de Revo-artikolo/-derivaĵo en kiu aperu la referenco (ni limiĝas al unu)
-- fnt: 'fe' aŭ 'oa'
-- dos: dosiero / sekcio-id, ekz. gra_en, univort, oa_1... (sen finaĵo .html)
-- ref: referencparto post #
-- skc: montrebla nomo de la referenco, kez. UV, OA3 II
CREATE TABLE `r3ofc` (
  `inx` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mrk` varchar(100),
  `fnt` varchar(10) NOT NULL,
  `dos` varchar(100) NOT NULL,
  `ref` varchar(255) NOT NULL,
  `skc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
   KEY `inx` (`inx`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- uzebla kiel select * from v3tradukoj where ind like 'abak%'
-- sed tio daŭras multe pli longe ol rekte serĉante per SELECT...

-- Atentu: tiuj JOIN funkcias nur rapide uzante indeksojn (mrk) se tiuj kolumnoj havas
-- ekzakte la saman specifon. LEFT JOIN ŝajnas pli rapide ol INNER JOIN - oni ja povas
-- poste forigi eventualajn troajn liniojn per WHERE kap is NOT NULL aŭ simile!


CREATE OR REPLACE VIEW `v3traduko` AS
SELECT t.mrk, t.lng, t.ind, t.trd, t.ekz, k.kap, k.var, m.num 
FROM `r3trd` t
LEFT JOIN `r3mrk` m ON t.mrk = m.mrk
LEFT JOIN `r3kap` k ON m.drv = k.mrk;

-- por serĉi e-e kun tradukoj:
-- ALTER TABLE `r3mrk` ADD INDEX (drv);
-- ALTER TABLE `r3kap` MODIFY `kap` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_esperanto_ci;

CREATE OR REPLACE VIEW `v3esperanto` AS
SELECT k.kap, k.var, m.num, m.mrk, t.lng, t.ind, t.trd, t.ekz 
FROM r3kap k 
LEFT JOIN r3mrk m ON k.mrk=m.drv
LEFT JOIN r3trd t ON t.mrk=m.mrk;


