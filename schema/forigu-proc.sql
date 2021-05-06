DELIMITER //

-- forigas informojn pri unu artikolo el la diversaj tabeloj de la datumbazo
-- vi povas voki tiel:
--  
--   call forigu_art('<radik>');

-- se jam ekzistas:
-- DROP PROCEDURE forigu_art//

CREATE PROCEDURE forigu_art(IN dosiero VARCHAR(255))
BEGIN
  
  DELETE FROM r3trd 
  WHERE mrk = dosiero OR mrk LIKE CONCAT(dosiero,'.%');

  DELETE FROM r3ref
  WHERE mrk = dosiero OR mrk LIKE CONCAT(dosiero,'.%');
  -- referencoj povas ankaŭ montri al la forigenda artikolo
  -- sed eble pli bone forigu ilin el la fontaj artikoloj sekvante la eraroraporton
  -- tiam ili malaperos ankaŭ el r3ref!

  DELETE FROM r3mrk
  WHERE mrk = dosiero OR mrk LIKE CONCAT(dosiero,'.%');

  DELETE FROM r3kap
  WHERE mrk = dosiero OR mrk LIKE CONCAT(dosiero,'.%');

  DELETE FROM r2_vikicelo
  WHERE vik_celref = dosiero OR vik_celref LIKE CONCAT(dosiero,'.%');

END//

DELIMITER ;
