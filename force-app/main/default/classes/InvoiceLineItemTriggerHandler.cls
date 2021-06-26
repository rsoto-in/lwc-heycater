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

		newItemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(this.triggerNew);
		if (!newItemsWithInvoiceList.isEmpty())
		{
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(newItemsWithInvoiceList);
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

		newItemsWithInvoiceMap = new Map<Id, Invoice_Line_Item__c>();
		newItemsWithInvoiceMap.putAll(InvoiceLineItemUtils.getILIsWithInvoice(this.triggerNew));
		oldItemsWithInvoiceMap = new Map<Id, Invoice_Line_Item__c>();
		oldItemsWithInvoiceMap.putAll(InvoiceLineItemUtils.getILIsWithInvoice(this.triggerOld));
		if (!newItemsWithInvoiceMap.isEmpty() || !oldItemsWithInvoiceMap.isEmpty())
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsWithInvoiceMap, newItemsWithInvoiceMap);
			for (Id id : itemsWithoutChanges)
			{
				oldItemsWithInvoiceMap.remove(id);
				newItemsWithInvoiceMap.remove(id);
			}
			amountILISInvoicesSet = new Set<Id>();
			amountILISInvoicesSet.addAll(InvoiceUtils.getInvoiceIdsSet(newItemsWithInvoiceMap.values()));
			amountILISInvoicesSet.addAll(InvoiceUtils.getInvoiceIdsSet(oldItemsWithInvoiceMap.values()));
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

		oldItemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(this.triggerOld);
		if (!oldItemsWithInvoiceList.isEmpty())
		{
			amountILISInvoicesSet = InvoiceUtils.getInvoiceIdsSet(oldItemsWithInvoiceList);
			InvoiceUtils.updateAmountILIs(amountILISInvoicesSet, new List<Invoice_Line_Item__c>());
		}
	}
}