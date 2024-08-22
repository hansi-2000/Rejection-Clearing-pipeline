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