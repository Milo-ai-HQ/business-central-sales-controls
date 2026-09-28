page 50100 "AIDV Open Orders by Cust."
{
    Caption = 'Open Orders by Customer';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "AIDV Open Order Buffer";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rows)
            {
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Open Lines"; Rec."Open Lines") { }
                field("Open Amount (LCY)"; Rec."Open Amount (LCY)") { }
                field("Oldest Order Date"; Rec."Oldest Order Date") { }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)") { }
            }
        }
    }

    trigger OnOpenPage()
    var
        OpenOrders: Query "AIDV Open Orders by Cust.";
        EntryNo: Integer;
    begin
        OpenOrders.Open();
        while OpenOrders.Read() do begin
            EntryNo += 1;
            Rec.Init();
            Rec."Entry No." := EntryNo;
            Rec."Customer No." := OpenOrders.CustomerNo;
            Rec."Customer Name" := OpenOrders.CustomerName;
            Rec."Open Lines" := OpenOrders.OpenLines;
            Rec."Open Amount (LCY)" := OpenOrders.OpenAmountLCY;
            Rec."Oldest Order Date" := OpenOrders.OldestOrderDate;
            Rec."Credit Limit (LCY)" := OpenOrders.CreditLimitLCY;
            Rec.Insert();
        end;
        OpenOrders.Close();
    end;
}
