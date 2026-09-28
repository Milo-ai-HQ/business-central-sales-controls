table 50100 "AIDV Open Order Buffer"
{
    Caption = 'Open Order Buffer';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Customer No."; Code[20]) { }
        field(3; "Customer Name"; Text[100]) { }
        field(4; "Open Lines"; Integer) { }
        field(5; "Open Amount (LCY)"; Decimal) { AutoFormatType = 1; }
        field(6; "Oldest Order Date"; Date) { }
        field(7; "Credit Limit (LCY)"; Decimal) { AutoFormatType = 1; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
