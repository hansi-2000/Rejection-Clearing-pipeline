DECLARE 
   output_ VARCHAR(256); 
   attr_ VARCHAR(256);
   objver_ VARCHAR(256);
   objid_  VARCHAR(256);
BEGIN
   Client_SYS.Add_To_Attr('ACTION_ENABLE', 'FALSE', attr_);
   select OBJVERSION , OBJID INTO objver_ , objid_ 
   from fnd_event_action where
   EVENT_LU_NAME='LanguageTranslation'
   and EVENT_ID='REJECT_STOP'
   and ACTION_NUMBER = '0';
   Fnd_Event_Action_API.Modify__(output_,objid_,objver_,attr_,'DO');
   Fnd_Event_API.Set_Event_Enable('LanguageTranslation','REJECT_STOP');
   Fnd_Event_Action_API.Update_Action('LanguageTranslation','REJECT_STOP',NULL);
   COMMIT;
   
END;
/