/**
 * @name: InvoiceLineItemTriggerHandler_Test
 * @description: Apex Test class for Invoice_Line_Item__c Trigger handler
 * @class: InvoiceLineItemTriggerHandler
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 * v0.2 - 2021-06-27 - Minor changes
 */
@IsTest
private with sharing class InvoiceLineItemTriggerHandler_Test {

	private static final String INVOICE_NOT_UPDATED_MSG = 'Invoice\'s Amount Invoice Line Items has not been updated';
	private static final String INVOICE_UPDATED_MSG = 'Invoice\'s Amount Invoice Line Items has been updated';

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
		User user = TestDataFactory.createUser(TestUtils.PROFILE_NAME_TEST);
		if (user != null)
		{
			TestDataFactory.assignPermissionSet(TestUtils.PERMISSION_SET_NAME_TEST, user.Id);
		}
		System.runAs(user){
			TestDataFactory.createInvoicesAndILIs(7);
		}
	}

	/**
	 * @name: afterInsertInvoiceChangeTest
	 * @description: After Insert test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterInsertInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NOT_NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		// Clone Invoice Line Items with Invoice lookup field value
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			item.Amount__c += 10;
			itemsList.add(item.clone(false, true, false, false));
		}

		// Get Invoice amounts for test assertion (before insert)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			insert itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after insert)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertNotEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_NOT_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterInsertNoInvoiceChangeTest
	 * @description: After Insert test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterInsertNoInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		// Clone Invoice Line Items with Invoice lookup field value
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			if (item.Amount__c > 0)
			{
				item.Amount__c -= 10;
			}
			else
			{
				item.Amount__c += 10;
			}
			itemsList.add(item.clone(false, true, false, false));
		}

		// Get Invoice amounts for test assertion (before insert)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			insert itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after insert)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_NOT_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterUpdateInvoiceChangeTest
	 * @description: After Update test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterUpdateInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NOT_NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		// Update Invoice Line Items' amounts
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			item.Amount__c += 10;
			itemsList.add(item);
		}

		// Get Invoice amounts for test assertion (before update)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			update itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after update)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertNotEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_NOT_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterUpdateNoILIChangeTest
	 * @description: After Update test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterUpdateNoILIChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		// Update Invoice Line Items' amounts
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			if (item.Amount__c > 0)
			{
				item.Amount__c -= 10;
			}
			else
			{
				item.Amount__c += 10;
			}
			itemsList.add(item);
		}

		// Get Invoice amounts for test assertion (before update)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			update itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after update)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterUpdateNoInvoiceChangeTest
	 * @description: After Update test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterUpdateNoInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Invoice__c> 				invoiceBeforeMap;
		Map<Id, Invoice__c> 				invoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NOT_NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		// Update Invoice Line Items' amounts
		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			itemsList.add(item);
		}

		// Get Invoice LastModifiedDate for test assertion (before update)
		invoiceBeforeMap = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c LIMIT 50000])
		{
			invoiceBeforeMap.put(invoice.Id, invoice);
		}

		Test.startTest();
		System.runAs(user)
		{
			update itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after update)
		invoiceAfterMap = new Map<Id, Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c, LastModifiedDate FROM Invoice__c LIMIT 50000])
		{
			invoiceAfterMap.put(invoice.Id, invoice);
		}

		for (Id id : invoiceBeforeMap.keySet())
		{
			if (invoiceAfterMap.containsKey(id))
			{
				System.assertEquals(
					invoiceBeforeMap.get(id).Amount_Invoice_Line_Items__c, 
					invoiceAfterMap.get(id).Amount_Invoice_Line_Items__c,
					INVOICE_UPDATED_MSG);
				System.assertEquals(
					invoiceBeforeMap.get(id).LastModifiedDate,
					invoiceAfterMap.get(id).LastModifiedDate, 
					INVOICE_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterDeleteInvoiceChangeTest
	 * @description: After Delete test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterDeleteInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NOT_NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			itemsList.add(item);
		}

		// Get Invoice amounts for test assertion (before delete)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			delete itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after delete)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertNotEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_NOT_UPDATED_MSG);
			}
		}
	}

	/**
	 * @name: afterDeleteNoInvoiceChangeTest
	 * @description: After Delete test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 * v0.2 - 2021-06-27 - Minor changes
	 */
	@IsTest
	static void afterDeleteNoInvoiceChangeTest()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceBeforeMap;
		Map<Id, Decimal> 					sumByInvoiceAfterMap;
		Decimal								sum;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(TestUtils.INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = TestUtils.SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME +  ' ' + TestUtils.NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			itemsList.add(item);
		}

		// Get Invoice amounts for test assertion (before delete)
		sumByInvoiceBeforeMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceBeforeMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		Test.startTest();
		System.runAs(user)
		{
			delete itemsList;
		}
		Test.stopTest();

		// Get Invoice amounts for test assertion (after delete)
		sumByInvoiceAfterMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c LIMIT 50000])
		{
			sumByInvoiceAfterMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}

		for (Id id : sumByInvoiceBeforeMap.keySet())
		{
			if (sumByInvoiceAfterMap.containsKey(id))
			{
				System.assertEquals(sumByInvoiceBeforeMap.get(id), sumByInvoiceAfterMap.get(id), INVOICE_UPDATED_MSG);
			}
		}
	}
}