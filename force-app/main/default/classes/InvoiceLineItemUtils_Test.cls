/**
 * @name: InvoiceLineItemUtils_Test
 * @description: Apex Test class for Invoice_Line_Item_c Utils class
 * @class: InvoiceLineItemUtils
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-26 - Initial version
 */
@isTest
private with sharing class InvoiceLineItemUtils_Test
{
	private static final String	PROFILE_NAME_TEST = 'Standard User';
	private static final String	PERMISSION_SET_NAME_TEST = 'SalesUser';

	private static final String INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	private static final String INVOICE_FIELD_API_NAME = 'Invoice__c';

	private static final String ILI_LIST_INVOICE_MAP_NULL_MSG = 'Invoice Line Item List by Invoice Map has to be NULL';
	private static final String ILI_LIST_INVOICE_MAP_NOT_NULL_MSG = 'Invoice Line Item List by Invoice Map cannot be NULL';
	private static final String INVOICE_LINE_ITEM_NULL_MSG = 'Invoice Line Item has to be NULL';
	private static final String INVOICE_LINE_ITEM_NOT_NULL_MSG = 'Invoice Line Item cannot be NULL';
	private static final String ILI_BY_INVOICE_EMPTY_MAP_SIZE_1_MSG = 'Invoice Line Item by Invoice Map is empty. Now it has a new key. Size has to be 1';
	private static final String ILI_BY_INVOICE_MAP_SIZE_2_MSG = 'Invoice Line Item by Invoice Map had 1 key. Now it has a new key. Size has to be 2';
	private static final String ILI_BY_INVOICE_MAP_SIZE_1_MSG = 'Invoice Line Item by Invoice Map had 1 key. There are no new keys. Size has to be 1';
	private static final String ILI_LIST_EMPTY_SIZE_1_MSG = 'Invoice Line Item List is empty. Now it has a new item. Size has to be 1';
	private static final String ILI_BY_INVOICE_EMPTY_MAP_SIZE_0_MSG = 'Invoice Line Item by Invoice Map is empty. An exception has been thrown. Size has to be 0';
	
	private static final String INVOICE_IDS_SET_NULL_MSG = 'Set of Invoice Ids has to be NULL';
	private static final String ITEMS_LIST_NULL_MSG = 'List of Item has to be NULL';
	private static final String ITEM_BY_INVOICE_MAP_NOT_NULL_MSG = 'Map of Items by Invoice cannot be NULL';
	private static final String ITEM_BY_INVOICE_MAP_SIZE_0_MSG = 'Size of map of Items by Invoice has to be 0';
	private static final String INVOICE_IDS_SET_SIZE_1_MSG = 'Size of set of Invoice Ids has to be 1';
	private static final String ITEMS_LIST_SIZE_1_MSG = 'Size of list of Item has to be 1';
	private static final String ITEM_BY_INVOICE_MAP_SIZE_1_MSG = 'Size of map of Items by Invoice has to be 1';
	private static final String ITEM_BY_INVOICE_MAP_SIZE_2_MSG = 'Size of map of Items by Invoice has to be 2';
	
	private static final String ITEMS_W_INVOICE_LIST_NOT_NULL_MSG = 'List of Items with Invoice cannot be NULL';
	private static final String ITEMS_W_INVOICE_LIST_SIZE_0_MSG = 'Size of list of Items with Invoice has to be 0';
	private static final String DIFFERENT_NUM_ILIS_W_INVOICE_MSG = 'The number of Invoice Line Items with Invoice retrieved is not correct';

	private static final String OLD_ITEMS_MAP_NULL_MSG = 'Map of old Invoice Line Items has to be NULL';
	private static final String NEW_ITEMS_MAP_NULL_MSG = 'Map of new Invoice Line Items has to be NULL';
	private static final String ITEMS_WO_CHANGES_SET_NOT_NULL_MSG = 'Set of changed Invoice Line Items cannot to be NULL';
	private static final String ITEMS_WO_CHANGES_SET_SIZE_0_MSG = 'Size of changed Invoice Line Items set has to be 0';
	private static final String NEW_ITEMS_MAP_NOT_NULL_MSG = 'Map of new Invoice Line Items cannot be NULL';
	private static final String OLD_ITEMS_MAP_NOT_NULL_MSG = 'Map of old Invoice Line Items cannot be NULL';
	private static final String ITEMS_WO_CHANGES_SET_SIZE_1_MSG = 'Size of changed Invoice Line Items set has to be 1';

	private static final String SELECT_OPERATION = 'SELECT';
	private static final String COUNT_AGGREGATE_FUNCTION_OPERATION = 'COUNT()';
	private static final String FROM_TARGET = 'FROM';
	private static final String WHERE_FILTER = 'WHERE';
	private static final String NOT_NULL_FILTER = '!= NULL';
	private static final String NULL_FILTER = '= NULL';
	private static final String IN_FILTER = 'IN';
	private static final String INVOICE_IDS_SET = 'invoiceIdsSet';
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
	 * v0.1 - 2021-06-26 - Initial version
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
	 * @name: addItemToInvoiceMapNullParamsTest
	 * @description: Testing addItemToInvoiceMap method with NULL input parameters
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapNullParamsTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertEquals(null, itemsByInvoiceMap, ILI_LIST_INVOICE_MAP_NULL_MSG);
		System.assertEquals(null, item, INVOICE_LINE_ITEM_NULL_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapNullMapTest
	 * @description: Testing addItemToInvoiceMap method with a NULL Item list per Invoice Map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapNullMapTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		for (Invoice_Line_Item__c record : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			item = record;
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertEquals(null, itemsByInvoiceMap, ILI_LIST_INVOICE_MAP_NULL_MSG);
		System.assertNotEquals(null, item, INVOICE_LINE_ITEM_NOT_NULL_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapNullItemTest
	 * @description: Testing addItemToInvoiceMap method with a NULL Item
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapNullItemTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertNotEquals(null, itemsByInvoiceMap, ILI_LIST_INVOICE_MAP_NOT_NULL_MSG);
		System.assertEquals(null, item, INVOICE_LINE_ITEM_NULL_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapEmptyMapTest
	 * @description: Testing addItemToInvoiceMap method with an empty map and an item
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapEmptyMapTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		for (Invoice_Line_Item__c record : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			item = record;
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertEquals(1, itemsByInvoiceMap.size(), ILI_BY_INVOICE_EMPTY_MAP_SIZE_1_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapNewKeyTest
	 * @description: Testing addItemToInvoiceMap method with a new key in the map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapNewKeyTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		for (Invoice_Line_Item__c record : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			item = record;
		}
		for (Invoice__c invoice : [SELECT Id FROM Invoice__c WHERE Id != :item.Invoice__c LIMIT 1])
		{
			itemsByInvoiceMap.put(invoice.Id, new List<Invoice_Line_Item__c>());
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertEquals(2, itemsByInvoiceMap.size(), ILI_BY_INVOICE_MAP_SIZE_2_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapNewKeyTest
	 * @description: Testing addItemToInvoiceMap method with an existing key in the map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapExistingKeyTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;
		List<Invoice_Line_Item__c>			itemsList;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		for (Invoice_Line_Item__c record : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			item = record;
		}
		for (Invoice__c invoice : [SELECT Id FROM Invoice__c WHERE Id = :item.Invoice__c LIMIT 1])
		{
			itemsByInvoiceMap.put(invoice.Id, new List<Invoice_Line_Item__c>());
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		itemsList = new List<Invoice_Line_Item__c>();
		itemsList.addAll(itemsByInvoiceMap.get(item.Invoice__c));
		System.assertEquals(1, itemsByInvoiceMap.size(), ILI_BY_INVOICE_MAP_SIZE_1_MSG);
		System.assertEquals(1, itemsList.size(), ILI_LIST_EMPTY_SIZE_1_MSG);
	}

	/**
	 * @name: addItemToInvoiceMapSOQLExceptionTest
	 * @description: Testing addItemToInvoiceMap method without querying fields used
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void addItemToInvoiceMapSOQLExceptionTest()
	{
		User								user;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		Invoice_Line_Item__c				item;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsByInvoiceMap = new Map<Id, List<Invoice_Line_Item__c>>();
		for (Invoice_Line_Item__c record : [SELECT Id FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			item = record;
		}
		Test.startTest();
		System.runAs(user)
		{
			InvoiceLineItemUtils.addItemToInvoiceMap(itemsByInvoiceMap, item);
		}
		Test.stopTest();
		System.assertEquals(0, itemsByInvoiceMap.size(), ILI_BY_INVOICE_EMPTY_MAP_SIZE_0_MSG);
	}

	/**
	 * @name: getItemsByInvoiceMapTest
	 * @description: Testing getItemsByInvoiceMap method with NULL input parameters
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsByInvoiceMapNullParamsTest()
	{
		User								user;
		Set<Id>								invoiceIdsSet;
		List<Invoice_Line_Item__c>			itemsList;
		Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertNotEquals(null, itemsByInvoiceMap, ITEM_BY_INVOICE_MAP_NOT_NULL_MSG);
		if (itemsByInvoiceMap != null)
		{
			System.assertEquals(0, itemsByInvoiceMap.size(), ITEM_BY_INVOICE_MAP_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsByInvoiceMapNullSetTest
	 * @description: Testing getItemsByInvoiceMap method with a NULL set
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsByInvoiceMapNullSetTest()
	{
		User								user;
		Set<Id>								invoiceIdsSet;
		List<Invoice_Line_Item__c>			itemsList;
		Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c = NULL LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertEquals(null, invoiceIdsSet, INVOICE_IDS_SET_NULL_MSG);
		System.assertEquals(1, itemsList.size(), ITEMS_LIST_SIZE_1_MSG);
		System.assertNotEquals(null, itemsByInvoiceMap, ITEM_BY_INVOICE_MAP_NOT_NULL_MSG);
		if (itemsByInvoiceMap != null)
		{
			System.assertEquals(1, itemsByInvoiceMap.size(), ITEM_BY_INVOICE_MAP_SIZE_1_MSG);
		}
	}

	/**
	 * @name: getItemsByInvoiceMapNullListTest
	 * @description: Testing getItemsByInvoiceMap method with a NULL list
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsByInvoiceMapNullListTest()
	{
		User								user;
		Set<Id>								invoiceIdsSet;
		List<Invoice_Line_Item__c>			itemsList;
		Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		invoiceIdsSet = new Set<Id>();
		for (Invoice__c invoice : [SELECT Id FROM Invoice__c LIMIT 1])
		{
			invoiceIdsSet.add(invoice.Id);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, invoiceIdsSet, INVOICE_IDS_SET_SIZE_1_MSG);
		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertNotEquals(null, itemsByInvoiceMap, ITEM_BY_INVOICE_MAP_NOT_NULL_MSG);
		if (itemsByInvoiceMap != null)
		{
			System.assertEquals(0, itemsByInvoiceMap.size(), ITEM_BY_INVOICE_MAP_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsByInvoiceMapNullKeyTest
	 * @description: Testing getItemsByInvoiceMap method to receive a map with an Invoice Id and null keys
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsByInvoiceMapNullKeyTest()
	{
		User								user;
		Set<Id>								invoiceIdsSet;
		List<Invoice_Line_Item__c>			itemsList;
		Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap;
		String								query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		invoiceIdsSet = new Set<Id>();
		for (Invoice__c invoice : [SELECT Id FROM Invoice__c LIMIT 1])
		{
			invoiceIdsSet.add(invoice.Id);
		}
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c = NULL LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		query = SELECT_OPERATION + ' ' + COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME + ' ' + IN_FILTER + ':' + INVOICE_IDS_SET + ' ';
		query += MAX_QUERY_LIMIT;
		System.assertNotEquals(null, itemsByInvoiceMap, ITEM_BY_INVOICE_MAP_NOT_NULL_MSG);
		if (itemsByInvoiceMap != null)
		{
			System.assertEquals(2, itemsByInvoiceMap.size(), ITEM_BY_INVOICE_MAP_SIZE_2_MSG);
		}
	}

	/**
	 * @name: getItemsByInvoiceMapPositiveTest
	 * @description: Testing getItemsByInvoiceMap method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsByInvoiceMapPositiveTest()
	{
		User								user;
		Set<Id>								invoiceIdsSet;
		List<Invoice_Line_Item__c>			itemsList;
		Map<Id, List<Invoice_Line_Item__c>> itemsByInvoiceMap;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		invoiceIdsSet = new Set<Id>();
		for (Invoice__c invoice : [SELECT Id FROM Invoice__c LIMIT 1])
		{
			invoiceIdsSet.add(invoice.Id);
		}
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c IN :invoiceIdsSet LIMIT 1])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, itemsByInvoiceMap, ITEM_BY_INVOICE_MAP_NOT_NULL_MSG);
		if (itemsByInvoiceMap != null)
		{
			System.assertEquals(1, itemsByInvoiceMap.size(), ITEM_BY_INVOICE_MAP_SIZE_1_MSG);
		}
	}	

	/**
	 * @name: getILIsWithInvoiceNullParamsTest
	 * @description: Testing getILIsWithInvoice method with NULL params
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getILIsWithInvoiceNullParamsTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		List<Invoice_Line_Item__c>	itemsWithInvoiceList;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		Test.startTest();
		System.runAs(user)
		{
			itemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(itemsList);
		}
		Test.stopTest();

		System.assertEquals(null, itemsList, ITEMS_LIST_NULL_MSG);
		System.assertNotEquals(null, itemsWithInvoiceList, ITEMS_W_INVOICE_LIST_NOT_NULL_MSG);
		if (itemsWithInvoiceList != null)
		{
			System.assertEquals(0, itemsWithInvoiceList.size(), ITEMS_W_INVOICE_LIST_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getILIsWithInvoiceSObjectExceptionTest
	 * @description: Testing getILIsWithInvoice method with an Exception
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getILIsWithInvoiceSObjectExceptionTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		List<Invoice_Line_Item__c>	itemsWithInvoiceList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id FROM Invoice_Line_Item__c LIMIT 50000])
		{
			itemsList.add(item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithInvoiceList = InvoiceLineItemUtils.getILIsWithInvoice(itemsList);
		}
		Test.stopTest();
		System.assertNotEquals(null, itemsWithInvoiceList, ITEMS_W_INVOICE_LIST_NOT_NULL_MSG);
		if (itemsWithInvoiceList != null)
		{
			System.assertEquals(0, itemsWithInvoiceList.size(), ITEMS_W_INVOICE_LIST_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getILIsWithInvoicePositiveTest
	 * @description: Testing getILIsWithInvoice method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.2
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 * v0.2 - 2021-06-26 - Method moved to InvoiceLineItemUtils_Test
	 */
	@IsTest
	static void getILIsWithInvoicePositiveTest()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		List<Invoice_Line_Item__c>	itemsWithInvoiceList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Invoice__c FROM Invoice_Line_Item__c LIMIT 50000])
		{
			itemsList.add(item);
		}
		itemsWithInvoiceList = new List<Invoice_Line_Item__c>();
		Test.startTest();
		System.runAs(user)
		{
			itemsWithInvoiceList.addAll(InvoiceLineItemUtils.getILIsWithInvoice(itemsList));
		}
		Test.stopTest();
		query = SELECT_OPERATION + ' ';
		query += COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME + ' ' + NOT_NULL_FILTER + ' ';
		query += MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsWithInvoiceList.size(), DIFFERENT_NUM_ILIS_W_INVOICE_MSG);
	}

	/**
	 * @name: getItemsWithoutChangesNullParamsTest
	 * @description: Testing getItemsWithoutChanges method with NULL parameters
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesNullParamsTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Set<Id>							itemsWithoutChanges;			

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertEquals(null, oldItemsMap, OLD_ITEMS_MAP_NULL_MSG);
		System.assertEquals(null, newItemsMap, NEW_ITEMS_MAP_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(0, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsWithoutChangesNullOldMapTest
	 * @description: Testing getItemsWithoutChanges method with NULL old map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesNullOldMapTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Set<Id>							itemsWithoutChanges;			

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		newItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c LIMIT 1])
		{
			newItemsMap.put(item.Id, item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertEquals(null, oldItemsMap, OLD_ITEMS_MAP_NULL_MSG);
		System.assertNotEquals(null, newItemsMap, NEW_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(0, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsWithoutChangesNullNewMapTest
	 * @description: Testing getItemsWithoutChanges method with NULL new map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesNullNewMapTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Set<Id>							itemsWithoutChanges;			

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		oldItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c LIMIT 1])
		{
			oldItemsMap.put(item.Id, item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertNotEquals(null, oldItemsMap, OLD_ITEMS_MAP_NOT_NULL_MSG);
		System.assertEquals(null, newItemsMap, NEW_ITEMS_MAP_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(0, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsWithoutChangesSameTest
	 * @description: Testing getItemsWithoutChanges method with ILIs with changes
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesSameTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Set<Id>							itemsWithoutChanges;			

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		oldItemsMap = new Map<Id, Invoice_Line_Item__c>();
		newItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c LIMIT 1])
		{
			oldItemsMap.put(item.Id, item);
			newItemsMap.put(item.Id, item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertNotEquals(null, oldItemsMap, OLD_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, newItemsMap, NEW_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(1, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_1_MSG);
		}
	}

	/**
	 * @name: getItemsWithoutChangesTest
	 * @description: Testing getItemsWithoutChanges method with NULL new map
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesDifferentTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Invoice_Line_Item__c			oldInvoiceLineItem;
		Invoice_Line_Item__c			newInvoiceLineItem;
		Set<Id>							itemsWithoutChanges;		

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		oldItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Amount__c, Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			oldItemsMap.put(item.Id, item);
		}
		newItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Id id : oldItemsMap.keyset())
		{
			oldInvoiceLineItem = oldItemsMap.get(id);
			newInvoiceLineItem = oldInvoiceLineItem.clone(true, true, true, true);
			newInvoiceLineItem.Amount__c = 0;
			newInvoiceLineItem.Invoice__c = null;
			newItemsMap.put(id, newInvoiceLineItem);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertNotEquals(null, oldItemsMap, OLD_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, newItemsMap, NEW_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(0, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_0_MSG);
		}
	}

	/**
	 * @name: getItemsWithoutChangesSObjectExceptionTest
	 * @description: Testing getItemsWithoutChanges method with ILIs with a thrown exception
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Initial version
	 */
	@IsTest
	static void getItemsWithoutChangesSObjectExceptionTest()
	{
		User 							user;
		Map<Id, Invoice_Line_Item__c> 	oldItemsMap;
		Map<Id, Invoice_Line_Item__c> 	newItemsMap;
		Set<Id>							itemsWithoutChanges;			

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		oldItemsMap = new Map<Id, Invoice_Line_Item__c>();
		newItemsMap = new Map<Id, Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id FROM Invoice_Line_Item__c LIMIT 1])
		{
			oldItemsMap.put(item.Id, item);
			newItemsMap.put(item.Id, item);
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsWithoutChanges = InvoiceLineItemUtils.getItemsWithoutChanges(oldItemsMap, newItemsMap);
		}
		Test.stopTest();
		System.assertNotEquals(null, oldItemsMap, OLD_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, newItemsMap, NEW_ITEMS_MAP_NOT_NULL_MSG);
		System.assertNotEquals(null, itemsWithoutChanges, ITEMS_WO_CHANGES_SET_NOT_NULL_MSG);
		if (itemsWithoutChanges != null)
		{
			System.assertEquals(0, itemsWithoutChanges.size(), ITEMS_WO_CHANGES_SET_SIZE_0_MSG);
		}
	}
}