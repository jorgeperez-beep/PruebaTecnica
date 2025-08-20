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
            sr.ExpectedResolutionDate__c = sr.ExpectedResolutionDate__c.addDays(dias);
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
    Date resultado = fechaInicio;
    Integer contador = 0;
    while (contador < dias) {
        resultado = resultado.addDays(1);
        Integer dow = resultado.toStartOfDay().dayOfWeek();
        if (dow != DateTime.SUNDAY && dow != DateTime.SATURDAY) {
            contador++;
        }
    }
    return resultado;
}
}