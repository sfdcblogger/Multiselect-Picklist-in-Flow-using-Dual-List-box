import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchMultiselectPicklistOptions from '@salesforce/apex/CustomMultiselectPicklistController.fetchMultiselectPicklistOptions';

export default class Custom_multiselect_picklist extends LightningElement {

    @api objectApiName;
    @api labelFieldApiName;
    options = [];
    selectedOptions = [];

    connectedCallback() {
        this.loadPicklistData();
    }

    loadPicklistData(){
        fetchMultiselectPicklistOptions({ objectName: this.objectApiName }).then(result => {
            let optionsVar = [];
            var labelFieldApiNameVar = this.labelFieldApiName;
            result.forEach(eachRecord => {
                optionsVar.push({ value: eachRecord.Id, label: eachRecord[labelFieldApiNameVar] });
            });            
            this.options = optionsVar;
        }).catch(error => {
            console.log(JSON.stringify(error));
            this.dispatchEvent(new ShowToastEvent({
                title: "",
                message: error,
                variant: "error"
            }));
        });
    }

    handleChange(e){
        this.selectedOptions = e.detail.value;
    }
}