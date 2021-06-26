/**
 * @name: InvoiceUtils
 * @description: Apex Utils class for Invoice__c object
 * @test: InvoiceUtils_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-22 - Initial version
 */
public with sharing class InvoiceUtils {

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
	 */
	@TestVisible
	private static Map<Id, List<Invoice_Line_Item__c>> getItemsByInvoiceMap(
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
	 * @name: calculateAmountILIs
	 * @description: Method for calculating Amount_Invoice_Line_Items__c field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	invoiceIdsSet	Set<Id>						Set of Invoice Ids to calculate
	 * 			itemsList		List<Invoice_Line_Item__c>	List of Invoice Line Items with Invoices to calculate
	 * @return: List<Invoice__c>	List of Invoices after calculation
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@TestVisible
	private static List<Invoice__c> calculateAmountILIs(
		Set<Id> invoiceIdsSet, 
		List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice__c>					invoicesList;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		List<Invoice_Line_Item__c>			innerItemsList;
        Double amount;

		itemsByInvoiceMap = getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		invoicesList = new List<Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c WHERE Id IN :invoiceIdsSet])
		{
			invoice.Amount_Invoice_Line_Items__c = 0;
			innerItemsList = itemsByInvoiceMap.get(invoice.Id);
			if (innerItemsList != null)
			{
				for (Invoice_Line_Item__c item : innerItemsList)
				{
                    amount = item.Amount__c != null ? item.Amount__c : 0;
					invoice.Amount_Invoice_Line_Items__c += amount;
				}
			}
			invoicesList.add(invoice);
		}
		return invoicesList;
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
	 * @name: getInvoiceIdsSet
	 * @description: Method for getting a set of Invoice Ids
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: itemsList	List<Invoice_Line_Item__c>		List of Invoice Line Items with Invoices to get
	 * @return: Set<Id>	Set of Invoice Ids
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	public static Set<Id> getInvoiceIdsSet(List<Invoice_Line_Item__c> itemsList)
	{
		Set<Id>				invoiceIdsSet;

		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
		}
		return invoiceIdsSet;
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

	/**
	 * @name: updateAmountILIs
	 * @description: Method for updating Amount_Invoice_Line_Items__c field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: 	invoiceIdsSet	Set<Id>						Set of Invoice Ids to calculate
	 * 			itemsList		List<Invoice_Line_Item__c>	List of Invoice Line Items to use for Invoice calculation
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.1 - 2021-06-23 - Receive a set of Invoice Ids to be updated
	 */
	public static void updateAmountILIs(Set<Id>	invoiceIdsSet, List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice__c>	invoicesList;

		invoicesList = new List<Invoice__c>();
		invoicesList.addAll(InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList));
		if (!invoicesList.isEmpty())
		{
			update invoicesList;
		}
	}
}