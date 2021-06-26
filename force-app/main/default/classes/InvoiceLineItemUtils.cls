/**
 * @name: InvoiceLineItemUtils
 * @description: Apex Utils class for Invoice_Line_Item__c object
 * @test: InvoiceLineItemUtils_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-26 - Initial version
 */
public with sharing class InvoiceLineItemUtils {

	/**
	 * @name: addItemToInvoiceMap
	 * @description: Method for adding a new InvoiceLineItem to a Item per Invoice Map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: 	itemsByInvoiceMap	Map<Id, List<Invoice_Line_Item__c>>		Map of List of Invoice Line Items per Invoice Id
	 * 			item				Invoice_Line_Item__c					A Invoice Line Item to add
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.2 - 2021-06-26 - Method moved to InvoiceLineItemUtils
	 */
	@TestVisible
	private static void addItemToInvoiceMap(Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap, Invoice_Line_Item__c item)
	{
		List<Invoice_Line_Item__c> itemList;

		if (itemsByInvoiceMap != null)
		{
			if (!itemsByInvoiceMap.isEmpty() && itemsByInvoiceMap.containsKey(item.Invoice__c))
			{
				itemList = itemsByInvoiceMap.get(item.Invoice__c);
				if (itemList != null)
				{
					itemList.add(item);
				}
			}
			else
			{
				itemList = new List<Invoice_Line_Item__c>();
				itemList.add(item);
				itemsByInvoiceMap.put(item.Invoice__c, itemList);
			}
		}
	}

	/**
	 * @name: getItemsByInvoiceMap
	 * @description: Method for creating a InvoiceLineItems per Invoice map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	invoiceIdsSet	Set<Id>						Set of Invoice Ids to map
	 * 			itemsList		List<Invoice_Line_Item__c>	List of Invoice Line Item to map
	 * @return:	Map<Id, List<Invoice_Line_Item__c>>		Map of List of Invoice Line Items per Invoice Id
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.2 - 2021-06-26 - Method moved to InvoiceLineItemUtils
	 */
	public static Map<Id, List<Invoice_Line_Item__c>> getItemsByInvoiceMap(
		Set<Id> invoiceIdsSet,
		List<Invoice_Line_Item__c> itemsList)
	{
		Set<Id>								itemIdsSet;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;

		// Get all related InvoiceLineItems
		itemIdsSet = new Set<Id>();
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		for (Invoice_Line_Item__c item : itemsList)
		{
			itemIdsSet.add(item.Id);
			addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		for (Invoice_Line_Item__c item : [SELECT Id, Invoice__c, Amount__c FROM Invoice_Line_Item__c 
											WHERE Invoice__c IN :invoiceIdsSet 
											AND Id NOT IN :itemIdsSet])
		{
			addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		return itemsByInvoiceMap;
	}

	/**
	 * @name: getILIsWithInvoice
	 * @description: Method for getting a list of Invoice Line Items with Invoice
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: itemsList	List<Invoice_Line_Item__c>		List of Invoice Line Items to filter
	 * @return: List<Invoice_Line_Item__c>	List of Invoice Line Items with Invoice
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 * v0.2 - 2021-06-26 - Method moved to InvoiceLineItemUtils
	 */
	public static List<Invoice_Line_Item__c> getILIsWithInvoice(List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice_Line_Item__c> itemsWithInvoiceList;

		itemsWithInvoiceList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : itemsList)
		{
			if (item.Invoice__c != null)
			{
				itemsWithInvoiceList.add(item);
			}	
		}
		return itemsWithInvoiceList;
	}

	/**
	 * @name: getItemsWithoutChanges
	 * @description: Method for getting a set of ILIs Ids that don't have Invoice and Amount changes
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: itemsList	List<Invoice_Line_Item__c>		List of Invoice Line Items with Invoices to get
	 * @return: Set<Id>	Set of Invoice Ids
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 * v0.2 - 2021-06-26 - Method moved to InvoiceLineItemUtils
	 */
	public static Set<Id> getItemsWithoutChanges(
		Map<Id, Invoice_Line_Item__c> oldItemsMap, 
		Map<Id, Invoice_Line_Item__c> newItemsMap)
	{
		Set<Id>					itemsWithoutChanges;
		Invoice_Line_Item__c	oldItem;
		Invoice_Line_Item__c	newItem;

		itemsWithoutChanges = new Set<Id>();
		for (Id id : newItemsMap.keyset())
		{
			if (oldItemsMap.containsKey(id) && newItemsMap.containsKey(id))
			{
				oldItem = oldItemsMap.get(id);
				newItem = newItemsMap.get(id);

				if (oldItem.Invoice__c == newItem.Invoice__c && oldItem.Amount__c == newItem.Amount__c)
				{
					itemsWithoutChanges.add(id);
				}
			}
		}
		return itemsWithoutChanges;
	}

}