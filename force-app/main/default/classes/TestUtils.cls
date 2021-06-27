/**
 * @name: TestUtils
 * @description: Apex Utils class for testing
 * @test: N/A
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-27 - Initial version
 */
@IsTest
public with sharing class TestUtils {
	
	public static final String	PROFILE_NAME_TEST = 'Standard User';
	public static final String	PERMISSION_SET_NAME_TEST = 'TestAssignmentUser';

	public static final String	INVOICE_DATA_TEST = 'TestInvoices';
	public static final String	INVOICE_LINE_ITEM_DATA_TEST = 'TestInvoiceLineItems';

	public static final String	INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	public static final String	INVOICE_FIELD_API_NAME = 'Invoice__c';
	
	public static final String	SELECT_OPERATION = 'SELECT';
	public static final String	COUNT_AGGREGATE_FUNCTION_OPERATION = 'COUNT()';
	public static final String	FROM_TARGET = 'FROM';
	public static final String	WHERE_FILTER = 'WHERE';
	public static final String	EQUAL_FILTER = '=';
	public static final String	NULL_FILTER = '= NULL';
	public static final String	NOT_NULL_FILTER = '!= NULL';
	public static final String	IN_FILTER = 'IN';
	public static final String	MAX_QUERY_LIMIT = 'LIMIT 50000';

}