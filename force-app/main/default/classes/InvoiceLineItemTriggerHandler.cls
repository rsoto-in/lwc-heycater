/**
 * @name: InvoiceLineItemTriggerHandler
 * @description: Apex Trigger Handler class for Invoice_Line_Item__c trigger
 * @test: InvoiceLineItemTriggerHandler_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 * v0.2 - 2021-06-23 - Add After Delete handler
 */
public with sharing class InvoiceLineItemTriggerHandler {

	private List<Invoice_Line_Item__c> triggerNew;
    private List<Invoice_Line_Item__c> triggerOld;
    private Map<Id, Invoice_Line_Item__c> triggerMapNew;
    private Map<Id, Invoice_Line_Item__c> triggerMapOld;

	/**
	 * @name: InvoiceLineItemTriggerHandler
	 * @description: Invoice_Line_Item__c Trigger Handler constructor
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	triggerNew		List<Invoice_Line_Item__c>		List of new Invoice Line Items
	 * 			triggerOld		List<Invoice_Line_Item__c>		List of previous Invoice Line Items
	 * 			triggerMapNew	Map<Id, Invoice_Line_Item__c>	Map of new Invoice Line Items by Id
	 * 			triggerMapOld	Map<Id, Invoice_Line_Item__c>	Map of previous Invoice Line Items by Id
	 * @return: InvoiceLineItemTriggerHandler
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
    public InvoiceLineItemTriggerHandler(List<Invoice_Line_Item__c> triggerNew, List<Invoice_Line_Item__c> triggerOld,
								Map<Id, Invoice_Line_Item__c> triggerMapNew, Map<Id, Invoice_Line_Item__c> triggerMapOld) {
		this.triggerNew = triggerNew;
		this.triggerOld = triggerOld;
		this.triggerMapNew = triggerMapNew;
		this.triggerMapOld = triggerMapOld;
    }

	/**
	 * @name: afterInsert
	 * @description: After Insert method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public void afterInsert()
	{
		List<Invoice_Line_Item__c>	itemsWithInvoiceSet;
		Set<Id> 					amountILISInvoicesSet;

		itemsWithInvoiceSet = InvoiceUtils.getILIsWithInvoice(this.triggerNew);
		if (itemsWithInvoiceSet != null && !itemsWithInvoiceSet.isEmpty())
		{
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(itemsWithInvoiceSet);
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, itemsWithInvoiceSet);
		}
	}

	/**
	 * @name: afterUpdate
	 * @description: After Update method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public void afterUpdate()
	{
		List<Invoice_Line_Item__c>	itemsWithInvoiceSet;
		Set<Id> 					amountILISInvoicesSet;

		itemsWithInvoiceSet = InvoiceUtils.getILIsWithInvoice(this.triggerNew);
		if (itemsWithInvoiceSet != null && !itemsWithInvoiceSet.isEmpty())
		{
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(itemsWithInvoiceSet);
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, itemsWithInvoiceSet);
		}
	}

	/**
	 * @name: afterDelete
	 * @description: After Delete method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	public void afterDelete() 
	{
		List<Invoice_Line_Item__c>	itemsWithInvoiceSet;
		Set<Id> 					amountILISInvoicesSet;

		itemsWithInvoiceSet = InvoiceUtils.getILIsWithInvoice(this.triggerOld);
		if (itemsWithInvoiceSet != null && !itemsWithInvoiceSet.isEmpty())
		{
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(itemsWithInvoiceSet);
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, new List<Invoice_Line_Item__c>());
		}
	}
}