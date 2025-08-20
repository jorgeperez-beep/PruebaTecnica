public with sharing class SolicitudSoporteTriggerHandler extends TriggerHandler {

    List<SupportRequest__c> lSolicitudSoporte;
    List<SupportRequest__c> lOldSolicitudSoporte;
    Map<Id, SupportRequest__c> mSolicitudSoporte;
    Map<Id, SupportRequest__c> mOldSolicitudSoporte;
    Boolean isInsert;

    public SolicitudSoporteTriggerHandler() {
        lSolicitudSoporte = Trigger.new;
        lOldSolicitudSoporte = Trigger.old;
        mSolicitudSoporte = (Map<Id, SupportRequest__c>) Trigger.newMap;
        mOldSolicitudSoporte = (Map<Id, SupportRequest__c>) Trigger.oldMap;
        isInsert = Trigger.isInsert;
    }

     public override void beforeInsert() {
        SolicitudSoporteService.Enunciado1(lSolicitudSoporte, null, isInsert);
    }

    public override void beforeUpdate() {
        SolicitudSoporteService.Enunciado1(lSolicitudSoporte, mOldSolicitudSoporte, isInsert);
    }
}