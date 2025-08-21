public with sharing class botonSupportController {
    
    @AuraEnabled
    public static void actualizarFecha(Id recordId) {
        system.debug('llega');
        SupportRequest__c sr = [
            SELECT Id, Priority__c,ExpectedResolutionDate__c
            FROM SupportRequest__c
            WHERE Id = :recordId
            LIMIT 1
        ];
        Integer dias = getDiasPorPrioridad(sr.Priority__c);
        if(sr.ExpectedResolutionDate__c!=null && dias!=null){
            sr.ExpectedResolutionDate__c = botonSupportController.sumarDiasHabiles(Date.today(), dias);

        }        
        update sr;
    }
    
    
    
    
    
    private static Integer getDiasPorPrioridad(String prioridad) {
        if (prioridad == 'High'){
            return 1;
        }   
        if (prioridad == 'Medium'){
            return 3;
        } 
        if (prioridad=='Low'){
            return 5;
            } 
        return null;
    }

    private static Date sumarDiasHabiles(Date fechaInicio, Integer dias) {
       
        if (fechaInicio == null || dias == null || dias <= 0) {
            return fechaInicio;
        }
        

        Date d = fechaInicio;
        Integer added = 0;

        while (added < dias) {
            d = d.addDays(1);
            Integer dow = d.toStartOfWeek().daysBetween(d);
            if (dow != 0 && dow != 6) { 
                added++;
            }
        }
        return d;
    }
}