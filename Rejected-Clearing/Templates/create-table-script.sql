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