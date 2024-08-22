--
-- DO NOT MODIFY THIS SCRIPT DIRECTLY, ALWAYS UPDATE THE SCRIPT IN https://bitbucket.org/ifs-pd/ifs-technology-internal/src/master/Translation%20-20%Scripts/
--
LOCK TABLE language_translation_tab IN EXCLUSIVE MODE NOWAIT; 
CREATE TABLE language_translation_tab_<CURRENT_DATE> AS (
SELECT c.path, a.attribute_id, t.lang_code, a.prog_text, t.text, t.reject_information, t.case_id, c.main_type, c.sub_type, c.module, c.obsolete, a.obsolete attrib_obsolete
  FROM language_translation_tab t,
       language_attribute_tab   a,
       language_context_tab     c
 WHERE c.context_id = a.context_id
   AND a.attribute_id = t.attribute_id
   AND (c.obsolete = 'N' AND a.obsolete = 'N')
   AND t.reject_status = 'REJECTED');
/
LOCK TABLE language_translation_tab IN EXCLUSIVE MODE NOWAIT; 
   
BEGIN
   History_Setting_Util_API.Disable;
END;
UPDATE language_translation_tab t
   SET t.case_id            = NULL,
       t.reject_status      = NULL,
       t.reject_information = NULL
 WHERE reject_status = 'REJECTED'
   AND (lang_code, attribute_id) IN
       (SELECT t.lang_code, t.attribute_id
          FROM language_translation_tab t,
               language_attribute_tab   a,
               language_context_tab     c
         WHERE c.context_id = a.context_id
           AND a.attribute_id = t.attribute_id
           AND (c.obsolete = 'N' AND a.obsolete = 'N')
           AND t.reject_status = 'REJECTED');
/
--COMMIT
--/
BEGIN
   History_Setting_Util_API.Enable;
END;