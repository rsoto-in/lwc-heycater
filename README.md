# heycater! LWC project

A heycater! project using Lightning Web Component (LWC) on Salesforce Platform.

## Requirements

This project is based on two custom objects: Invoice and Invoice Line Item (ILI):

- Each ILI has a lookup relationship to an Invoice, and a currency field: Amount.
- Each Invoice has a currency field: Amount Invoice Line Items.

The project's tasks were the following:

- **Using a trigger**, make sure that **Amount Invoice Line Items** always contains the summary of **Amount** of all ILIs associated with the invoice. Please follow SF best practices when implementing this feature, and provide a well thought test class.
- Create a Lightning Component that shows a table of all ILIs associated with a specific invoice (the table should have two columns, for **Name** and for **Amount**). Please show above the table the **Name** and **Amount Invoice Line Items** of the corresponding invoice. The component should be opened from an action on the Invoice page. You can create either an Aura or a LWC component, but using LWC in your solution is preferred.
