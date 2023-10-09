# voko-abelo

Procesumo de la datumbazo (mySQL) de Reta Vortaro.

Pri la nomo: abeloj kolektas polenon kaj nektaron
en regulaj sesangulaj fakoj. Simile datumbazo ordigas
kaj indeksas informerojn laŭ regulaj strukturoj. 

## Ekstrakti mankantajn tradukojn 

Por ekstrakti mankantajn tradukojn de iu lingvo kune kun oficialeco vi povas uzi

```
SELECT r3mrk.mrk, r3kap.kap, r3mrk.num, r3ofc.dos FROM r3mrk 
LEFT JOIN r3trd ON (r3trd.mrk = r3mrk.mrk or r3trd.mrk = r3mrk.drv) AND lng = 'en' 
LEFT JOIN r3kap ON r3kap.mrk = r3mrk.drv 
LEFT JOIN r3ofc ON r3kap.mrk = r3ofc.mrk
WHERE ele = 'snc' AND r3trd.mrk IS NULL 
ORDER BY r3mrk.mrk LIMIT 200
```

La konektinformojn al localhost:8889 donas revo-medioj/araneujo-s/bin/as-abel