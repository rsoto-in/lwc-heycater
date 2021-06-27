import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

import getInvoiceLineItems from '@salesforce/apex/InvoiceLineItemsController.getInvoiceLineItems';

import CURRENCY from '@salesforce/i18n/currency';
import INVOICE_OBJECT from '@salesforce/schema/Invoice__c';
import INVOICE_ID_FIELD from '@salesforce/schema/Invoice__c.Id';
import INVOICE_NAME_FIELD from '@salesforce/schema/Invoice__c.Name';
import INVOICE_AMOUNT_ILI_FIELD from '@salesforce/schema/Invoice__c.Amount_Invoice_Line_Items__c';
import INVOICE_LINE_ITEM_OBJECT from '@salesforce/schema/Invoice_Line_Item__c';

const CLOSE = 'Close';

const COLS = [
	{label: 'Name', fieldName: 'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}},
	{label: 'Amount', fieldName: 'Amount__c', type: 'currency', typeAttributes: { currencyCode: CURRENCY, step: '0.001'}}
];

const ERROR_TITLE = 'We encountered a problem when trying to display Invoice Line Items.';
const ERROR_MSG = 'For help, contact your administrator';
const ERROR_VAR = 'error';

export default class InvoiceLineItems extends LightningElement
{
	@api
	recordId;

	@track
	error;
	
	errorVariant = ERROR_VAR;
	errorTitle = ERROR_TITLE;
	errorMessage = ERROR_MSG;
	
	invoiceLabel = '';
	itemLabel = '';
	objectApiNames = [INVOICE_OBJECT, INVOICE_LINE_ITEM_OBJECT];
	invoice = INVOICE_OBJECT;
	invoiceName = INVOICE_NAME_FIELD;
	invoiceAmountILIs = INVOICE_AMOUNT_ILI_FIELD;
	close = CLOSE;
	columns = COLS;
	
	@track 
	items = [];

	@wire(getObjectInfos, { objectApiNames: '$objectApiNames' })
	objectInfos(result)
	{
		const {data, error} = result;
		if (data)
		{
			this.invoiceLabel = data.results[0].result.label;
			this.itemLabel = data.results[1].result.label;
		}
		if (error)
		{
            this.error = error;
        }
	};

	@wire(getRecord, { recordId: '$recordId', fields: [INVOICE_ID_FIELD] })
    record(result)
	{
		const {data, error} = result;
		if (data)
		{
			this.retrieveItems();
		}
		if (error)
		{
			this.error = error;
        }
	};

	retrieveItems()
	{
		getInvoiceLineItems({ invoiceId: this.recordId })
			.then((data) => 
			{
				let nameUrl;
				this.items = data.map(row => 
				{
					nameUrl = `/${row.Id}`;
					return {...row , nameUrl} 
				})
				this.error = undefined;
			})
			.catch((error) => 
			{
				this.showError();
				this.error = error;
				this.items = undefined;
			});
	}

	showError()
	{
        const event = new ShowToastEvent({
            title: this.errorTitle,
            message: this.errorMessage,
            variant: this.errorVariant,
        });
        this.dispatchEvent(event);
    }

	handleClose()
	{
		this.dispatchEvent(new CloseActionScreenEvent());
	}

}