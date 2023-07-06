codeunit 50000 "Record Deletion Mgt."
{
    Permissions = tabledata "G/L Entry" = IMD, tabledata "Sales Header" = IMD, tabledata "Sales Line" = IMD, tabledata "Purchase Header" = IMD, tabledata "Purchase Line" = IMD, tabledata "Gen. Journal Line" = IMD, tabledata "Cust. Ledger Entry" = IMD, tabledata "Vendor Ledger Entry" = IMD, tabledata "Item Ledger Entry" = IMD, tabledata "Sales Shipment Header" = IMD, tabledata "Sales Shipment Line" = IMD, tabledata "Sales Invoice Header" = IMD, tabledata "Sales Invoice Line" = IMD, tabledata "Sales Cr.Memo Header" = IMD, tabledata "Sales Cr.Memo Line" = IMD, tabledata "Purch. Rcpt. Header" = IMD, tabledata "Purch. Rcpt. Line" = IMD, tabledata "Purch. Inv. Header" = IMD, tabledata "Purch. Inv. Line" = IMD, tabledata "Purch. Cr. Memo Hdr." = IMD, tabledata "Purch. Cr. Memo Line" = IMD, tabledata "Job Ledger Entry" = IMD, tabledata "Detailed Cust. Ledg. Entry" = IMD, tabledata "Detailed Vendor Ledg. Entry" = IMD, tabledata "Bank Account Ledger Entry" = IMD, tabledata "Value Entry" = IMD, tabledata "Return Shipment Header" = IMD, tabledata "Return Receipt Header" = IMD;
    procedure InsertUpdateTables();
    var
        AllObjWithCaption: Record AllObjWithCaption;
        RecordDeletion: Record "Record Deletion";
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        // Do not include system tables
        AllObjWithCaption.SetFilter("Object ID", '< %1', 2000000001);
        if AllObjWithCaption.FindSet() then
            repeat
                RecordDeletion.Init();
                RecordDeletion."Table ID" := AllObjWithCaption."Object ID";
                RecordDeletion.Company := CopyStr(CompanyName, 1, MaxStrLen(RecordDeletion.Company));
                if RecordDeletion.Insert() then;
            until AllObjWithCaption.Next() = 0;
    end;

    procedure SuggestUnlicensedPartnerOrCustomRecordsToDelete();
    var
        SuggestRecords: Codeunit "Suggest Records";
    begin
        SuggestRecords.SuggestUnlicensedPartnerOrCustomRecordsToDelete();
    end;

    procedure SuggestRecordsToDelete()
    var
        SuggestRecords: Codeunit "Suggest Records";
    begin
        SuggestRecords.SuggestRecordsToDelete();
    end;

    procedure ClearRecordsToDelete();
    var
        RecordDeletion: Record "Record Deletion";
    begin
        RecordDeletion.ModifyAll("Delete Records", false);
    end;

    procedure DeleteRecords(RunTrigger: Boolean);
    var
        RecordDeletion: Record "Record Deletion";
        UpdateDialog: Dialog;
        DeleteRecordsQst: Label 'Delete Records with RunTrigger = false?';
        DeleteRecordsWithTriggerQst: Label 'Delete Records with RunTrigger = true?';
        DeletingRecordsTxt: Label 'Deleting Records!\Table: #1#######', Comment = '%1 = Table ID';
    begin
        if RunTrigger then begin
            if not Confirm(DeleteRecordsWithTriggerQst, false) then
                exit;
#pragma warning disable AA0005
        end else begin
            if not Confirm(DeleteRecordsQst, false) then
                exit;
        end;
#pragma warning restore AA0005

        UpdateDialog.Open(DeletingRecordsTxt);

        if RecordDeletion.FindSet() then
            repeat
                DeleteRecordFromTable(RunTrigger, RecordDeletion, UpdateDialog);
            until RecordDeletion.Next() = 0;

        UpdateDialog.Close();
    end;

    procedure CheckTableRelations();
    var
        Field: Record Field;
        Field2: Record Field;
        KeyRec: Record "Key";
        RecordDeletion: Record "Record Deletion";
        RecordDeletionRelError: Record "Record Deletion Rel. Error";
        TableMetadata: Record "Table Metadata";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        SkipCheck: Boolean;
        UpdateDialog: Dialog;
        EntryNo: Integer;
        CheckingRelationsTxt: Label 'Checking Relations Between Records!\Table: #1#######', Comment = '%1 = Table ID';
        CheckRelationsQst: Label 'Check Table Relations?';
        NotExistsTxt: Label '%1 => %2 = ''%3'' does not exist in the ''%4'' table', Comment = '%1 = RecRef Position, %2 = FieldRef Name, %3 = FieldRef Value, %4 = Record Ref Name';
    begin
        if not Confirm(CheckRelationsQst, false) then
            exit;

        UpdateDialog.Open(CheckingRelationsTxt);

        RecordDeletionRelError.DeleteAll();

        if RecordDeletion.FindSet() then
            repeat
                UpdateDialog.Update(1, Format(RecordDeletion."Table ID"));
                // Only allow "normal" tables to avoid errors, Skip TableType MicrosoftGraph and CRM etc.
                TableMetadata.SetRange(ID, RecordDeletion."Table ID");
                TableMetadata.SetRange(TableType, TableMetadata.TableType::Normal);
                if not TableMetadata.IsEmpty then begin
                    RecordRef.Open(RecordDeletion."Table ID");
                    if RecordRef.FindSet() then
                        repeat
                            Field.SetRange(TableNo, RecordDeletion."Table ID");
                            Field.SetRange(Class, Field.Class::Normal);
                            Field.SetFilter(RelationTableNo, '<>0');
                            if Field.FindSet() then
                                repeat
                                    FieldRef := RecordRef.Field(Field."No.");
                                    if (Format(FieldRef.Value) <> '') and (Format(FieldRef.Value) <> '0') then begin
                                        RecordRef2.Open(Field.RelationTableNo);
                                        SkipCheck := false;
                                        if Field.RelationFieldNo <> 0 then
                                            FieldRef2 := RecordRef2.Field(Field.RelationFieldNo)
                                        else begin
                                            KeyRec.Get(Field.RelationTableNo, 1);  // PK
                                            Field2.SetRange(TableNo, Field.RelationTableNo);
                                            Field2.SetFilter(FieldName, CopyStr(KeyRec.Key, 1, 30));
                                            if Field2.FindFirst() then // No Match if Dual PK
                                                FieldRef2 := RecordRef2.Field(Field2."No.")
                                            else
                                                SkipCheck := true;
                                        end;
                                        if (FieldRef.Type = FieldRef2.Type) and (FieldRef.Length = FieldRef2.Length) and (not SkipCheck) then begin
                                            FieldRef2.SetRange(FieldRef.Value);
                                            if not RecordRef2.FindFirst() then begin
                                                RecordDeletionRelError.SetRange("Table ID", RecordRef.Number);
                                                if RecordDeletionRelError.FindLast() then
                                                    EntryNo := RecordDeletionRelError."Entry No." + 1
                                                else
                                                    EntryNo := 1;
                                                RecordDeletionRelError.Init();
                                                RecordDeletionRelError."Table ID" := RecordRef.Number;
                                                RecordDeletionRelError."Entry No." := EntryNo;
                                                RecordDeletionRelError."Field No." := FieldRef.Number;
                                                RecordDeletionRelError.Error := CopyStr(StrSubstNo(NotExistsTxt, Format(RecordRef.GetPosition()), Format(FieldRef2.Name), Format(FieldRef.Value), Format(RecordRef2.Name)), 1, 250);
                                                RecordDeletionRelError.Insert();
                                            end;
                                        end;
                                        RecordRef2.Close();
                                    end;
                                until Field.Next() = 0;
                        until RecordRef.Next() = 0;
                    RecordRef.Close();
                end;
            until RecordDeletion.Next() = 0;
        UpdateDialog.Close();
    end;

    procedure ViewRecords(RecordDeletion: Record "Record Deletion");
    begin
        Hyperlink(GetUrl(ClientType::Current, CompanyName, ObjectType::Table, RecordDeletion."Table ID"));
    end;

    procedure CalcRecordsInTable(TableNoToCheck: Integer): Integer
    var
        Field: Record Field;
        RecordRef: RecordRef;
        NoOfRecords: Integer;
    begin
        Field.SetRange(TableNo, TableNoToCheck);
        if not Field.IsEmpty() then begin
            RecordRef.Open(TableNoToCheck);
            RecordRef.LockTable();
            NoOfRecords := RecordRef.Count();
            RecordRef.Close();
            exit(NoOfRecords);
        end;
        exit(0);
    end;

    local procedure DeleteRecordFromTable(RunTrigger: Boolean; var RecordDeletionRec: Record "Record Deletion"; var UpdateDialog: Dialog)
    var
        RecordDeletion: Codeunit "Record Deletion";
    begin
        if not RecordDeletionRec."Delete Records" then
            exit;

        UpdateDialog.Update(1, Format(RecordDeletionRec."Table ID"));

        RecordDeletion.DeleteRecordsFromTable(RecordDeletionRec, RunTrigger);
    end;



}