import { LightningElement, api, wire } from 'lwc';
import actualizarFecha from '@salesforce/apex/botonSupportController.actualizarFecha';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

import STATUS_FIELD from '@salesforce/schema/SupportRequest__c.Status__c';

export default class MiBotonLwc extends NavigationMixin(LightningElement) {
  @api recordId;

  @wire(getRecord, { recordId: '$recordId', fields: [STATUS_FIELD] })
  record;

  get status() {
    return getFieldValue(this.record.data, STATUS_FIELD);
  }

  handleClick() {
    if (!this.status) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Advertencia',
          message: 'Debes seleccionar un estado antes de actualizar la fecha.',
          variant: 'warning'
        })
      );
      return;
    }

    actualizarFecha({ recordId: this.recordId })
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: '¡Éxito!',
            message: 'Fecha de resolución actualizada.',
            variant: 'success'
          })
        );
        getRecordNotifyChange([{ recordId: this.recordId }]);
        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
            recordId: this.recordId,
            objectApiName: 'SupportRequest__c',
            actionName: 'view'
          }
        });
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Error al actualizar',
            message: error.body?.message || error.message,
            variant: 'error'
          })
        );
      });
  }
}