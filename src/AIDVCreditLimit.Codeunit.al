/// <summary>
/// Hard credit-limit block on sales orders.
/// BC's standard credit check (Cust-Check Cr. Limit) only warns, and only in the UI.
/// This subscriber runs on every Sales Line insert/modify, so it also stops orders
/// created through API v2.0 (e.g. the shopify-sync service): the error rolls back the
/// whole deep-insert request.
/// </summary>
codeunit 50100 "AIDV Credit Limit"
{
    Access = Internal;

    var
        CreditLimitErr: Label 'Order exceeds customer credit limit';

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        CheckLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if (Rec."Outstanding Amount (LCY)" <= xRec."Outstanding Amount (LCY)") then
            exit; // exposure did not grow
        CheckLine(Rec);
    end;

    local procedure CheckLine(var SalesLine: Record "Sales Line")
    begin
        if SalesLine.IsTemporary() then
            exit;
        if SalesLine."Document Type" <> SalesLine."Document Type"::Order then
            exit;
        if SalesLine."Bill-to Customer No." = '' then
            exit;
        if ExceedsCreditLimit(SalesLine."Bill-to Customer No.") then
            Error(CreditLimitErr);
    end;

    /// <summary>
    /// Balance (LCY) + Outstanding Orders (LCY) against Credit Limit (LCY); 0 = no limit.
    /// Called after the line is written, so the line itself is already in Outstanding Orders.
    /// </summary>
    procedure ExceedsCreditLimit(CustomerNo: Code[20]): Boolean
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then
            exit(false);
        if Customer."Credit Limit (LCY)" = 0 then
            exit(false);
        Customer.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)");
        exit(Customer."Balance (LCY)" + Customer."Outstanding Orders (LCY)" > Customer."Credit Limit (LCY)");
    end;
}
