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
                    sr.ExpectedResolutionDate__c = sr.ExpectedResolutionDate__c.addDays(dias);
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
}