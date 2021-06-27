/**
 * @name: InvoiceLineItemTriggerHandler
 * @description: Apex Trigger Handler class for Invoice_Line_Item__c trigger
 * @test: InvoiceLineItemTriggerHandler_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.2
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 * v0.2 - 2021-06-23 - Add After Delete handler
 * v0.3 - 2021-06-27 - Minor changes
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
	 * @version: 0.2
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	public void afterInsert()
	{
		List<Invoice_Line_Item__c>	newItemsWithInvoiceList;
		Set<Id> 					amountILISInvoicesSet;

		// Use ONLY new Invoice Line Items with Invoice lookup field value
		newItemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(this.triggerNew);
		if (!newItemsWithInvoiceList.isEmpty())
		{
			// Create a set of Invoice Ids to be updated
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(newItemsWithInvoiceList);
			// Update Invoices' Amount Invoice Line Items
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, newItemsWithInvoiceList);
		}
	}

	/**
	 * @name: afterUpdate
	 * @description: After Update method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.2
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	public void afterUpdate()
	{
		Map<Id, Invoice_Line_Item__c>	newItemsWithInvoiceMap;
		Map<Id, Invoice_Line_Item__c>	oldItemsWithInvoiceMap;
		Set<Id>							itemsWithoutChanges;
		Set<Id> 						amountILISInvoicesSet;

		// Use ONLY new Invoice Line Items with Invoice lookup field value
		newItemsWithInvoiceMap = new Map<Id, Invoice_Line_Item__c>();
		newItemsWithInvoiceMap.putAll(InvoiceLineItemUtils.getILIsWithInvoice(this.triggerNew));
		// Use ONLY old Invoice Line Items with Invoice lookup field value (for Invoice lookup field value changes)
		oldItemsWithInvoiceMap = new Map<Id, Invoice_Line_Item__c>();
		oldItemsWithInvoiceMap.putAll(InvoiceLineItemUtils.getILIsWithInvoice(this.triggerOld));
		if (!newItemsWithInvoiceMap.isEmpty() || !oldItemsWithInvoiceMap.isEmpty())
		{
			// Use ONLY Invoice Line Items with Amount field value or Invoice lookup field value changes
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsWithInvoiceMap, newItemsWithInvoiceMap);
			for (Id id : itemsWithoutChanges)
			{
				oldItemsWithInvoiceMap.remove(id);
				newItemsWithInvoiceMap.remove(id);
			}
			// Create a set of Invoice Ids to be updated
			amountILISInvoicesSet = new Set<Id>();
			amountILISInvoicesSet.addAll(InvoiceUtils.getInvoiceIdsSet(newItemsWithInvoiceMap.values()));
			amountILISInvoicesSet.addAll(InvoiceUtils.getInvoiceIdsSet(oldItemsWithInvoiceMap.values()));
			// Update Invoices' Amount Invoice Line Items
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, newItemsWithInvoiceMap.values());
		}
	}

	/**
	 * @name: afterDelete
	 * @description: After Delete method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.2
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	public void afterDelete() 
	{
		List<Invoice_Line_Item__c>	oldItemsWithInvoiceList;
		Set<Id> 					amountILISInvoicesSet;

		// Use ONLY old Invoice Line Items with Invoice lookup field value
		oldItemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(this.triggerOld);
		if (!oldItemsWithInvoiceList.isEmpty())
		{
			// Create a set of Invoice Ids to be updated
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(oldItemsWithInvoiceList);
			// Update Invoices' Amount Invoice Line Items
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, new List<Invoice_Line_Item__c>());
		}
	}
}