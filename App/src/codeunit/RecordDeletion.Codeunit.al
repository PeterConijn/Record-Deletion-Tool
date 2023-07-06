codeunit 50001 "Record Deletion"
{
    Access = Internal;

    Permissions =
        tabledata "G/L Entry" = rimd,
        tabledata "Cust. Ledger Entry" = rimd,
        tabledata "Vendor Ledger Entry" = rimd,
        tabledata "Item Ledger Entry" = rimd,
        tabledata "G/L Register" = rimd,
        tabledata "Item Register" = rimd,
        tabledata "User Time Register" = rimd,
        tabledata "G/L Budget Entry" = rimd,
        tabledata "Sales Shipment Header" = rimd,
        tabledata "Sales Shipment Line" = rimd,
        tabledata "Sales Invoice Header" = rimd,
        tabledata "Sales Invoice Line" = rimd,
        tabledata "Sales Cr.Memo Header" = rimd,
        tabledata "Sales Cr.Memo Line" = rimd,
        tabledata "Return Shipment Header" = rimd,
        tabledata "Return Shipment Line" = rimd,
        tabledata "Purch. Rcpt. Header" = rimd,
        tabledata "Purch. Rcpt. Line" = rimd,
        tabledata "Purch. Inv. Header" = rimd,
        tabledata "Purch. Inv. Line" = rimd,
        tabledata "Purch. Cr. Memo Hdr." = rimd,
        tabledata "Purch. Cr. Memo Line" = rimd,
        tabledata "Return Receipt Header" = rimd,
        tabledata "Return Receipt Line" = rimd,
        tabledata "Res. Ledger Entry" = rimd,
        tabledata "Job Journal Template" = rimd,
        tabledata "Dimension Set Tree Node" = rimd,
        tabledata "G/L Entry - VAT Entry Link" = rimd,
        tabledata "VAT Entry" = rimd,
        tabledata "Bank Account Ledger Entry" = rimd,
        tabledata "Check Ledger Entry" = rimd,
        tabledata "Bank Account Statement Line" = rimd,
        tabledata "Phys. Inventory Ledger Entry" = rimd,
        tabledata "VAT Amount Line" = rimd,
        tabledata "Issued Reminder Header" = rimd,
        tabledata "Issued Reminder Line" = rimd,
        tabledata "Reminder/Fin. Charge Entry" = rimd,
        tabledata "Item Application Entry" = rimd,
        tabledata "Detailed Cust. Ledg. Entry" = rimd,
        tabledata "Detailed Vendor Ledg. Entry" = rimd,
        tabledata "XBRL G/L Map Line" = rimd,
        tabledata "XBRL Taxonomy Label" = rimd,
        tabledata "Change Log Setup" = rimd,
        tabledata "Change Log Setup (Table)" = rimd,
        tabledata "Change Log Setup (Field)" = rimd,
        tabledata "Change Log Entry" = rimd,
        tabledata "IC G/L Account" = rimd,
        tabledata "Dimension Set Entry" = rimd,
        tabledata "FA Ledger Entry" = rimd,
        tabledata "FA Register" = rimd,
        tabledata "Item Charge" = rimd,
        tabledata "Value Entry" = rimd,
        tabledata "Item Journal Buffer" = rimd,
        tabledata "Avg. Cost Adjmt. Entry Point" = rimd,
        tabledata "Item Charge Assignment (Sales)" = rimd,
        tabledata "Service Document Log" = rimd,
        tabledata "Value Entry Relation" = rimd,
        tabledata "Warehouse Entry" = rimd;

    procedure DeleteRecordsFromTable(var RecordDeletion: Record "Record Deletion"; RunTrigger: Boolean)
    var
        RecordDeletionRelError: Record "Record Deletion Rel. Error";
        RecordRef: RecordRef;
    begin
        RecordRef.Open(RecordDeletion."Table ID");
        RecordRef.DeleteAll(RunTrigger);
        RecordRef.Close();

        RecordDeletionRelError.SetRange("Table ID", RecordDeletion."Table ID");
        RecordDeletionRelError.DeleteAll();
    end;
}
