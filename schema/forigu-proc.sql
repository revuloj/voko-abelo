DELIMITER //

-- forigas informojn pri unu artikolo el la diversaj tabeloj de la datumbazo
-- vi povas voki tiel:
--  
--   call forigu_art('<radik>');

-- se jam ekzistas:
-- DROP PROCEDURE forigu_art//

CREATE PROCEDURE forigu_art(IN dosiero VARCHAR(255))
BEGIN
  
  DELETE FROM var 
  WHERE var_drv_id in (SELECT drv_id FROM drv WHERE drv_art_id in 
      (SELECT art_id FROM art WHERE art_amrk = dosiero));

  DELETE FROM trd 
  WHERE trd_snc_id in (SELECT snc_id FROM snc WHERE snc_drv_id in 
       (SELECT drv_id FROM drv WHERE drv_art_id in (SELECT art_id FROM art WHERE art_amrk = dosiero)));

  DELETE FROM rim WHERE rim_art_id in (SELECT art_id FROM art WHERE art_amrk = dosiero);

  DELETE FROM snc 
  WHERE snc_drv_id in (SELECT drv_id FROM drv WHERE drv_art_id in 
       (SELECT art_id FROM art WHERE art_amrk = dosiero));

  DELETE FROM drv 
  WHERE drv_art_id in (SELECT art_id FROM art WHERE art_amrk = dosiero);

  DELETE FROM art WHERE art_amrk = dosiero;

  DELETE FROM r3kap WHERE mrk = dosiero OR mrk LIKE concat(dosiero,'.%');

  DELETE FROM r3mrk WHERE mrk LIKE concat(dosiero,'.%');

  -- referencoj povas ankaŭ montri al la forigenda artikolo
  -- se pli bone forigu ilin el la fontaj artikoloj sekvante la eraroraporton
  -- tiam ili malaperos ankaŭ el r3ref!
  DELETE FROM r3ref WHERE mrk LIKE concat(dosiero,'.%');
  
END//

DELIMITER ;
