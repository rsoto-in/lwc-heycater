/**
 * @name: InvoiceUtils_Test
 * @description: Apex Test class for Invoice__c Utils class
 * @class: InvoiceUtils
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 */
@isTest
private with sharing class InvoiceUtils_Test {

	private static final String	PROFILE_NAME_TEST = 'Standard User';
	private static final String	PERMISSION_SET_NAME_TEST = 'SalesUser';

	private static final String INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	private static final String INVOICE_FIELD_API_NAME = 'Invoice__c';
	private static final String INVOICE_NOT_CALCULATED_MSG = 'Invoice\'s Amount Invoice Line Items has not been calculated';
	private static final String INVOICE_NOT_UPDATE_MSG = 'Invoice\'s Amount Invoice Line Items has not been updated';
	private static final String DIFFERENT_NUM_ILIS_W_INVOICE_MSG = 'The number of Invoice Line Items with Invoice retrieved is not correct';
	private static final String DIFFERENT_NUM_INVOICE_IDS_MSG = 'The number of Invoice Ids retrieved is not correct';

	private static final String ITEMS_LIST_NULL_MSG = 'List of Item has to be NULL';
	private static final String INVOICE_IDS_SET_NULL_MSG = 'Set of Invoice Ids cannot to be NULL';
	private static final String INVOICE_IDS_SET_SIZE_0_MSG = 'Size of set of Invoice Ids has to be 0';
	private static final String INVOICE_IDS_SET_SIZE_1_MSG = 'Size of set of Invoice Ids has to be 1';

	private static final String ITEMS_LIST_NOT_NULL_MSG = 'List of Item cannot be NULL';
	private static final String INVOICE_ILI_AMOUNT_INCORRECT_UPDATE_MSG = 'Invoice\'s Amount Invoice Line Items has been updated incorrectly';
	private static final String INVOICE_INCORRECT_UPDATE_MSG = 'Invoice has been updated incorrectly';
	private static final String INVOICE_IDS_SET_NOT_NULL_MSG = 'Set of Invoice Ids cannot be NULL';

	private static final String SELECT_OPERATION = 'SELECT';
	private static final String COUNT_AGGREGATE_FUNCTION_OPERATION = 'COUNT()';
	private static final String FROM_TARGET = 'FROM';
	private static final String WHERE_FILTER = 'WHERE';
	private static final String NOT_NULL_FILTER = '!= NULL';
	private static final String NULL_FILTER = '= NULL';
	private static final String QUERY_LIMIT_1 = 'LIMIT 1';
	private static final String MAX_QUERY_LIMIT = 'LIMIT 50000';

	/**
	 * @name: setup
	 * @description: Setup method for testing
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@TestSetup
	static void setup()
	{
		User user = TestDataFactory.createUser(PROFILE_NAME_TEST);
		if (user != null)
		{
			TestDataFactory.assignPermissionSet(PERMISSION_SET_NAME_TEST, user.Id);
		}
		System.runAs(user)
		{
			TestDataFactory.createInvoicesAndILIs(7);
		}
	}

	/**
	 * @name: calculateAmountILIsNullParamsTest
	 * @description: Test calculateAmountILIs method with NULL params
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void calculateAmountILIsNullParamsTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
	}

	/**
	 * @name: calculateAmountILIsNullSetTest
	 * @description: Test calculateAmountILIs method with NULL Invoice Ids Set
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void calculateAmountILIsNullSetTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		Id							invoiceId;
		Map<Id, Invoice__c>			invoicesMapBefore;
		Map<Id, Invoice__c>			invoicesMapAfter;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			invoiceId = item.Invoice__c;
			itemsList.add(item);
		}
		invoicesMapBefore = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapBefore.put(invoice.Id, invoice);
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		invoicesMapAfter = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapAfter.put(invoice.Id, invoice);
		}
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertNotEquals(null, itemsList, ITEMS_LIST_NOT_NULL_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).Amount_Invoice_Line_Items__c, 
			invoicesMapAfter.get(invoiceId).Amount_Invoice_Line_Items__c, 
			INVOICE_ILI_AMOUNT_INCORRECT_UPDATE_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).LastModifiedDate, 
			invoicesMapAfter.get(invoiceId).LastModifiedDate, 
			INVOICE_INCORRECT_UPDATE_MSG);
	}

	/**
	 * @name: calculateAmountILIsNullListTest
	 * @description: Testing calculateAmountILIs method with NULL Items list
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void calculateAmountILIsNullListTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		Id							invoiceId;
		Map<Id, Invoice__c>			invoicesMapBefore;
		Map<Id, Invoice__c>			invoicesMapAfter;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		invoiceIdsSet = new Set<Id>();
		invoicesMapBefore = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c LIMIT 1])
		{
			invoiceId = invoice.Id;
			invoiceIdsSet.add(invoiceId);
			invoicesMapBefore.put(invoice.Id, invoice);
		}

		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();

		invoicesMapAfter = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapAfter.put(invoice.Id, invoice);
		}
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NOT_NULL_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).Amount_Invoice_Line_Items__c, 
			invoicesMapAfter.get(invoiceId).Amount_Invoice_Line_Items__c, 
			INVOICE_ILI_AMOUNT_INCORRECT_UPDATE_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).LastModifiedDate, 
			invoicesMapAfter.get(invoiceId).LastModifiedDate, 
			INVOICE_INCORRECT_UPDATE_MSG);
	}

	/**
	 * @name: calculateAmountILIsPositiveTest
	 * @description: Test method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 */
	@IsTest
	static void calculateAmountILIsPositiveTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceManualMap;
		Map<Id, Decimal> 					sumByInvoiceAutoMap;
		Decimal								sum;
		Set<Id>								invoiceIdsSet;
		List<Invoice__c>					invoicesList;
		Id									invoiceId;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME +  ' ' + NOT_NULL_FILTER + ' ';
		query += MAX_QUERY_LIMIT;

		// Clone Invoice Line Items with Invoice lookup field value
		// Calculate Invoice amounts for test assertion (manual) (with original records)
		itemsList = new List<Invoice_Line_Item__c>();
		sumByInvoiceManualMap = new Map<Id, Decimal>();
		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
			item.Amount__c += 10;
			itemsList.add(item.clone(false, true, false, false));
		}
		// Calculate Invoice amounts for test assertion (manual) (with cloned records)
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
		}
		invoicesList = new List<Invoice__c>();
		Test.startTest();
		System.runAs(user)
		{
			invoicesList.addAll(InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList));
		}
		Test.stopTest();
		// Get Invoice amount calculations for test assertion (auto)
		sumByInvoiceAutoMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : invoicesList)
		{
			sumByInvoiceAutoMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}
		for (Id id : sumByInvoiceManualMap.keySet())
		{
			if (sumByInvoiceAutoMap.containsKey(id))
			{
				invoiceId = id;
				break;
			}
		}
		System.assertEquals(sumByInvoiceManualMap.get(invoiceId), sumByInvoiceAutoMap.get(invoiceId), INVOICE_NOT_CALCULATED_MSG);
	}

	/**
	 * @name: getInvoiceIdsSetNullParamsTest
	 * @description: Testing getInvoiceIdsSet method with NULL params
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getInvoiceIdsSetNullParamsTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		Set<Id>						invoiceIdsSet;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		Test.startTest();
		System.runAs(user)
		{
			invoiceIdsSet = InvoiceUtils.getInvoiceIdsSet(itemsList);
		}
		Test.stopTest();
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		if (invoiceIdsSet != null)
		{
			System.assertEquals(0, invoiceIdsSet.size(), INVOICE_IDS_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getInvoiceIdsSetSObjectExceptionTest
	 * @description: Testing getInvoiceIdsSet method without querying a field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getInvoiceIdsSetSObjectExceptionTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		Set<Id>						invoiceIdsSet;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			invoiceIdsSet = InvoiceUtils.getInvoiceIdsSet(itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		if (invoiceIdsSet != null)
		{
			System.assertEquals(0, invoiceIdsSet.size(), INVOICE_IDS_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getInvoiceIdsSetNegativeTest
	 * @description: Testing getInvoiceIdsSet method with negative outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	@IsTest
	static void getInvoiceIdsSetNegativeTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		Set<Id>						invoiceIdsSet;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c = NULL LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			invoiceIdsSet = InvoiceUtils.getInvoiceIdsSet(itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		if (invoiceIdsSet != null)
		{
			System.assertEquals(1, invoiceIdsSet.size(), INVOICE_IDS_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getInvoiceIdsSetPositiveTest
	 * @description: Testing getInvoiceIdsSet method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	@IsTest
	static void getInvoiceIdsSetPositiveTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		Set<Id>						invoiceIdsSet;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			invoiceIdsSet = InvoiceUtils.getInvoiceIdsSet(itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		if (invoiceIdsSet != null)
		{
			System.assertEquals(1, invoiceIdsSet.size(), INVOICE_IDS_SET_SIZE_1_MSG);
		}
	}

	/**
	 * @name: updateAmountILIsNullParamsTest
	 * @description: Test updateAmountILIs method with NULL params
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void updateAmountILIsNullParamsTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.updateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
	}

	/**
	 * @name: updateAmountILIsNullParamsTest
	 * @description: Test updateAmountILIs method with NULL Invoice Ids Set
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void updateAmountILIsNullSetTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		Id							invoiceId;
		Map<Id, Invoice__c>			invoicesMapBefore;
		Map<Id, Invoice__c>			invoicesMapAfter;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			invoiceId = item.Invoice__c;
			itemsList.add(item);
		}
		invoicesMapBefore = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapBefore.put(invoice.Id, invoice);
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.updateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		invoicesMapAfter = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapAfter.put(invoice.Id, invoice);
		}
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertNotEquals(null, itemsList, ITEMS_LIST_NOT_NULL_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).Amount_Invoice_Line_Items__c, 
			invoicesMapAfter.get(invoiceId).Amount_Invoice_Line_Items__c, 
			INVOICE_ILI_AMOUNT_INCORRECT_UPDATE_MSG);
		System.assertEquals(
			invoicesMapBefore.get(invoiceId).LastModifiedDate, 
			invoicesMapAfter.get(invoiceId).LastModifiedDate, 
			INVOICE_INCORRECT_UPDATE_MSG);
	}

	/**
	 * @name: updateAmountILIsNullListTest
	 * @description: Test updateAmountILIs method with NULL Items list
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void updateAmountILIsNullListTest()
	{
		User 						user;
		Set<Id>						invoiceIdsSet;
		List<Invoice_Line_Item__c>	itemsList;
		Id							invoiceId;
		Map<Id, Invoice__c>			invoicesMapBefore;
		Map<Id, Invoice__c>			invoicesMapAfter;
		
		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		invoiceIdsSet = new Set<Id>();
		invoicesMapBefore = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c LIMIT 1])
		{
			invoiceId = invoice.Id;
			invoiceIdsSet.add(invoiceId);
			invoicesMapBefore.put(invoice.Id, invoice);
		}

		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.updateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();

		invoicesMapAfter = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c WHERE Id = :invoiceId LIMIT 1])
		{
			invoicesMapAfter.put(invoice.Id, invoice);
		}
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NOT_NULL_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertEquals(
			0, 
			invoicesMapAfter.get(invoiceId).Amount_Invoice_Line_Items__c, 
			INVOICE_ILI_AMOUNT_INCORRECT_UPDATE_MSG);
		System.assertNotEquals(
			invoicesMapBefore.get(invoiceId).LastModifiedDate, 
			invoicesMapAfter.get(invoiceId).LastModifiedDate, 
			INVOICE_INCORRECT_UPDATE_MSG);
	}

	/**
	 * @name: updateAmountILIsPositiveTest
	 * @description: Testing updateAmountILIs method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.2
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 * v0.2 - 2021-06-26 - Minor changes
	 */
	@IsTest
	static void updateAmountILIsPositiveTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceManualMap;
		Map<Id, Decimal> 					sumByInvoiceAutoMap;
		Decimal								sum;
		Set<Id>								invoiceIdsSet;
		Id									invoiceId;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME +  ' ' + NOT_NULL_FILTER + ' ';
		query += MAX_QUERY_LIMIT;

		// Clone Invoice Line Items with Invoice lookup field value
		// Calculate Invoice amounts for test assertion (manual) (with original records)
		itemsList = new List<Invoice_Line_Item__c>();
		sumByInvoiceManualMap = new Map<Id, Decimal>();
		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
			item.Amount__c += 10;
			itemsList.add(item.clone(false, true, false, false));
		}
		// Calculate Invoice amounts for test assertion (manual) (with cloned records)
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceUtils.updateAmountILIs(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		// Get Invoice amount calculations for test assertion (auto)
		sumByInvoiceAutoMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c WHERE Id IN :invoiceIdsSet LIMIT 1])
		{
			sumByInvoiceAutoMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}
		for (Id id : sumByInvoiceManualMap.keySet())
		{
			if (sumByInvoiceAutoMap.containsKey(id))
			{
				invoiceId = id;
				break;
			}
		}
		System.assertEquals(sumByInvoiceManualMap.get(invoiceId), sumByInvoiceAutoMap.get(invoiceId), INVOICE_NOT_UPDATE_MSG);
	}
}