global class UpdateSupportRequestByStatusBatch
    implements Database.Batchable<SObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Priority__c,ExpectedResolutionDate__c
            FROM SupportRequest__c where Status__c='PendingInternal' OR Status__c='PendingCustomer'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<SupportRequest__c> scope) {
        List<SupportRequest__c> updates = new List<SupportRequest__c>(scope.size());
        system.debug('entra execute' + scope);
        for (SupportRequest__c sr : scope) {
            Integer dias;
            if (sr.Priority__c == 'High') {
                dias = 1;
            } else if (sr.Priority__c == 'Medium') {
                dias = 3;
            } else if(sr.Priority__c=='Low'){
                dias = 5;
            }
            if(sr.ExpectedResolutionDate__c!=null && dias!=null){
                sr.ExpectedResolutionDate__c = DiasHabilesCheck.sumarDiasHabiles(Date.today(), dias);
            }
        }

        update scope;


    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch de actualización de solicitudes completado.');

    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 200);
    }
}