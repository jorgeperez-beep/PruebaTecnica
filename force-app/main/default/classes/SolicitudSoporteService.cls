public with sharing class SolicitudSoporteService {
    

    public static void Enunciado1(List<SupportRequest__c> newList,Map<Id, SupportRequest__c> oldMap,Boolean isInsert) {

        for (SupportRequest__c sr : newList) {
            if(sr.ExpectedResolutionDate__c != null && String.isNotBlank(sr.Status__c)){
                Boolean debeCalcular = false;
                if (isInsert) {
                    debeCalcular = true;
                }else{
                    SupportRequest__c old = oldMap.get(sr.Id);
                    if(old.Status__c != 'ToManage' && sr.Status__c == 'ToManage'){
                        debeCalcular = true;
                    }
                }
                if (debeCalcular) {
                    Integer dias = getDiasPorPrioridad(sr.Priority__c);
                    sr.ExpectedResolutionDate__c = SolicitudSoporteService.sumarDiasHabiles(Date.today(), dias);
                }
            }    
        }
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