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
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
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
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
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
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static List<Invoice__c> calculateAmountILIs(
		Set<Id> invoiceIdsSet, 
		List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice__c>					invoicesList;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		List<Invoice_Line_Item__c>			innerItemsList;

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
					invoice.Amount_Invoice_Line_Items__c += item.Amount__c;
				}
			}
			invoicesList.add(invoice);
		}
		return invoicesList;
	}

	/**
	 * @name: updateAmountILIs
	 * @description: Method for updating Amount_Invoice_Line_Items__c field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static void updateAmountILIs(List<Invoice_Line_Item__c> itemsList)
	{
		Set<Id>				invoiceIdsSet;
		List<Invoice__c>	invoicesList;

		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
		}
		invoicesList = new List<Invoice__c>();
		invoicesList.addAll(InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList));
		if (!invoicesList.isEmpty())
		{
			update invoicesList;
		}
	}
}