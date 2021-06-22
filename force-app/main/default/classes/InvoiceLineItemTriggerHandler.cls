/**
 * @name: InvoiceLineItemTriggerHandler
 * @description: Apex Trigger Handler class for Invoice_Line_Item__c trigger
 * @test: InvoiceLineItemTriggerHandler_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 */
public with sharing class InvoiceLineItemTriggerHandler {

	private List<Invoice_Line_Item__c> triggerNew;
    private List<Invoice_Line_Item__c> triggerOld;
    private Map<Id, Invoice_Line_Item__c> triggerMapNew;
    private Map<Id, Invoice_Line_Item__c> triggerMapOld;

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
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public void afterInsert() {}

	/**
	 * @name: afterUpdate
	 * @description: After Update method for Invoice_Line_Item__c trigger
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	public void afterUpdate() {}
}