public with sharing class DiasHabilesCheck {
    public static Date sumarDiasHabiles(Date fechaInicio, Integer dias) {
        if (fechaInicio == null || dias == null || dias <= 0) return fechaInicio;

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
