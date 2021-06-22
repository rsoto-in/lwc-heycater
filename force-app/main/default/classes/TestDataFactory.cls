/**
 * @name: TestDataFactory
 * @description: Apex class for creating test data records
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 */
@isTest
public class TestDataFactory {

	private static String INVOICE_DATA_TEST = 'TestInvoices';
	private static String INVOICE_LINE_ITEM_DATA_TEST = 'TestInvoiceLineItems';
	private static String USERNAME_TEST = 'sales@example.test';
	private static String LAST_NAME_TEST = 'Sales';
	private static String EMAIL_TEST = 'sales@example.invalid';
	private static String ALIAS_TEST = 'sales';
	private static String TIME_ZONE_SID_KEY_TEST = 'Europe/Paris';
	private static String LOCALE_SID_KEY_TEST = 'en_US';
	private static String EMAIL_ENCODING_KEY_TEST = 'UTF-8';
	private static String LANGUAGE_LOCALE_KEY_TEST = 'en_US';

	/**
	 * @name: createUser
	 * @description: Method for creating a test User
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	profileName	String	user Profile name
	 * @return: User		Test user
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static User createUser(String profileName)
	{
		User	user;
		Id		profileId;

		for (Profile profile : [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1])
		{
			profileId = profile.Id;	
		}

		if (profileId != null)
		{
			user = new User(
				Username = USERNAME_TEST, 
				LastName = LAST_NAME_TEST, 
				Email = EMAIL_TEST, 
				Alias = ALIAS_TEST, 
				TimeZoneSidKey = TIME_ZONE_SID_KEY_TEST, 
				LocaleSidKey = LOCALE_SID_KEY_TEST, 
				EmailEncodingKey = EMAIL_ENCODING_KEY_TEST, 
				ProfileId = profileId, 
				LanguageLocaleKey = LANGUAGE_LOCALE_KEY_TEST);
			
			insert user;
		}
		return user;
	}

	/**
	 * @name: assignPermissionSet
	 * @description: Method for assigning a Permission Set to a User
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: 	permissionSetName	String	Permission Set name
	 * 			userId				Id		User identifier
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@future
	public static void assignPermissionSet(String permissionSetName, Id userId)
	{
		PermissionSetAssignment	assignment;
		Id 						permissionSetId;
		
		for (PermissionSet ps : [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1])
		{
			permissionSetId = ps.Id;
		}

		if (permissionSetId != null)
		{
			assignment = new PermissionSetAssignment(
				PermissionSetId = permissionSetId,
				AssigneeId = userId
			);
			insert assignment;
		}
	}

	/**
	 * @name: loadInvoices
	 * @description: Method for loading Invoices
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: List<SObject>		SObject test records list
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static List<SObject> loadInvoices()
	{
		return Test.loadData(Invoice__c.sObjectType, INVOICE_DATA_TEST);
	}

	/**
	 * @name: loadInvoiceLineItems
	 * @description: Method for loading Invoice Line Items
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: List<SObject>		SObject test records list
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static List<SObject> loadInvoiceLineItems()
	{
		return Test.loadData(Invoice_Line_Item__c.sObjectType, INVOICE_LINE_ITEM_DATA_TEST);
	}

	/**
	 * @name: linkInvoiceLineItems
	 * @description: Method for linking Invoice Line Items to Invoices
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	invoicesList			List<SObject>	List of Invoice records
	 * 			invoiceLineItemsList	List<SObject>	List of Invoice Line Item records
	 * 			numberOfRelatedILIs		Integer			Number of related Invoice Line Items
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static void linkInvoiceLineItems(List<Invoice__c> invoicesList, 
		List<Invoice_Line_Item__c> invoiceLineItemsList,
		Integer numberOfRelatedILIs)
	{
		Integer i;
		Integer	count;

		i = 0;
		count = 0;
		// Iterate through Invoices
		for (Invoice__c invoice : invoicesList) {
			// Link Invoice Line Items to current Invoice until set limit
			for (i = count; i < count + numberOfRelatedILIs; i++) {
				if (invoiceLineItemsList != null && i < invoiceLineItemsList.size() - 1)
				{
					invoiceLineItemsList[i].Invoice__c = invoice.Id;
				}
			}
			// Continue with the next Invoice Line Items
			count = i;
		}
		update invoiceLineItemsList;
	}

	/**
	 * @name: createInvoicesAndILIs
	 * @description: Method for creating test data records
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: numberOfILISPerInvoice	Integer		number of Invoice Line Items per Invoice
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public static void createInvoicesAndILIs(Integer numberOfILISPerInvoice)
	{
		List<Invoice__c>			invoicesList;
		List<Invoice_Line_Item__c>	itemsList;
		List<Invoice_Line_Item__c>	invoiceLineItemsList;
		
		// Load main Invoices and Invoices Line Items
		invoicesList = loadInvoices();
		itemsList = loadInvoiceLineItems();

		// Filter Invoice Line Items
		invoiceLineItemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : itemsList) {
			if (item.Amount__c > -99999999999999.98 && item.Amount__c < 99999999999999.98)
			{
				invoiceLineItemsList.add(item);
			}
		}

		// Link Invoice Line Items and Invoices
		linkInvoiceLineItems(invoicesList, invoiceLineItemsList, numberOfILISPerInvoice);
	}
}