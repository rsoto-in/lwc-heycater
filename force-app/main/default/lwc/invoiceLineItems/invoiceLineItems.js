import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import getInvoiceLineItems from '@salesforce/apex/InvoiceLineItemsController.getInvoiceLineItems';

import CURRENCY from '@salesforce/i18n/currency';

import INVOICE_OBJECT from '@salesforce/schema/Invoice__c';
import INVOICE_NAME_FIELD from '@salesforce/schema/Invoice__c.Name';
import INVOICE_AMOUNT_ILI_FIELD from '@salesforce/schema/Invoice__c.Amount_Invoice_Line_Items__c';
import INVOICE_LINE_ITEM_OBJECT from '@salesforce/schema/Invoice_Line_Item__c';

const CLOSE = 'Close';

const COLS = [
	{label: 'Name', fieldName: 'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}},
	{label: 'Amount', fieldName: 'Amount__c', type: 'currency', typeAttributes: { currencyCode: CURRENCY, step: '0.001'}}
];

export default class InvoiceLineItems extends LightningElement {

	@api
	recordId;

	objectApiNames = [INVOICE_OBJECT, INVOICE_LINE_ITEM_OBJECT];
	
	invoiceLabel = '';
	itemLabel = '';

	invoice = INVOICE_OBJECT;
	invoiceName = INVOICE_NAME_FIELD;
	invoiceAmountILIs = INVOICE_AMOUNT_ILI_FIELD;

	columns = COLS;
	
	@track 
	itemsList = [];

	length = -1;

	close = CLOSE;

	@wire(getObjectInfos, { objectApiNames: '$objectApiNames' })
	objectInfos(result) {
		const {data, error} = result;
		if (data) {
			this.invoiceLabel = data.results[0].result.label;
			this.itemLabel = data.results[1].result.label;
		}
		if (error) {
            this.error = error;
        }
	};

	get items() {
		if (this.length < 0)
		{
			getInvoiceLineItems({ invoiceId: this.recordId })
				.then((data) => {
					let nameUrl;
					this.itemsList = data.map(row => {
						nameUrl = `/${row.Id}`;
						return {...row , nameUrl} 
					})
					this.error = undefined;
				})
				.catch((error) => {
					this.error = error;
					this.itemsList = undefined;
				});
			if (this.error) {
				this.length = 0;
				return false;
			}
			this.length = this.itemsList.length;
		}
		return true;
	}

	handleClose() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

}