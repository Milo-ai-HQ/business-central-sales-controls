permissionset 50100 "AIDV Sales Controls"
{
    Assignable = true;
    Caption = 'AIDV Sales Controls';
    Permissions =
        codeunit "AIDV Credit Limit" = X,
        query "AIDV Open Orders by Cust." = X,
        page "AIDV Open Orders by Cust." = X,
        table "AIDV Open Order Buffer" = X;
}
