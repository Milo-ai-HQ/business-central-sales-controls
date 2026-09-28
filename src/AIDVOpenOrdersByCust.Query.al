/// <summary>
/// Open Orders by Customer: one row per customer with open order lines, open value
/// and oldest order date. Usable in analysis mode, Excel and as an OData endpoint.
/// </summary>
query 50100 "AIDV Open Orders by Cust."
{
    Caption = 'Open Orders by Customer';
    QueryType = Normal;
    OrderBy = descending(OpenAmountLCY);

    elements
    {
        dataitem(Customer; Customer)
        {
            column(CustomerNo; "No.") { }
            column(CustomerName; Name) { }
            column(CreditLimitLCY; "Credit Limit (LCY)") { }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Bill-to Customer No." = Customer."No.";
                DataItemTableFilter = "Document Type" = const(Order), "Outstanding Quantity" = filter(<> 0);
                SqlJoinType = InnerJoin;

                column(OpenLines) { Method = Count; }
                column(OpenAmountLCY; "Outstanding Amount (LCY)") { Method = Sum; }

                dataitem(SalesHeader; "Sales Header")
                {
                    DataItemLink = "Document Type" = SalesLine."Document Type", "No." = SalesLine."Document No.";
                    SqlJoinType = InnerJoin;

                    filter(OrderDateFilter; "Order Date") { }
                    column(OldestOrderDate; "Order Date") { Method = Min; }
                }
            }
        }
    }
}
