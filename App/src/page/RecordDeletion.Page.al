page 50000 "Record Deletion"
{

    PageType = List;
    SourceTable = "Record Deletion";
    Caption = 'Record Deletion';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field(NoOfRecords; RecordDeletionMgt.CalcRecordsInTable(Rec."Table ID"))
                {
                    CaptionML = ENU = 'No. of Records';
                    ToolTip = 'Specifies the value of the CalcRecordsInTable(Rec.Table ID) field.';

                }
                field("No. of Table Relation Errors"; Rec."No. of Table Relation Errors")
                {
                    ToolTip = 'Specifies the value of the No. of Table Relation Errors field.';
                }
                field("Delete Records"; Rec."Delete Records")
                {
                    ToolTip = 'Specifies the value of the Delete Records field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {

        }
        area(Processing)
        {
            action(InsertUpdateTables)
            {
                CaptionML = ENU = 'Insert/Update Tables';
                Promoted = true;
                PromotedIsBig = true;
                Image = Refresh;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the InsertUpdateTables action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.InsertUpdateTables();
                end;
            }
            action(SuggestsRecords)
            {
                CaptionML = ENU = 'Suggest Records to Delete';
                Promoted = true;
                PromotedIsBig = true;
                Image = Suggest;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the SuggestsRecords action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.SuggestRecordsToDelete();
                end;
            }
            action(SuggestsUnlicensedPartnerOrCustomRecords)
            {
                CaptionML = ENU = 'Suggest Unlicensed Partner or Custom Records to Delete';
                Promoted = true;
                PromotedIsBig = true;
                Image = Suggest;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the SuggestsUnlicensedPartnerOrCustomRecords action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.SuggestUnlicensedPartnerOrCustomRecordsToDelete();
                end;
            }
            action(ClearRecords)
            {
                CaptionML = ENU = 'Clear Records to Delete';
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the ClearRecords action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.ClearRecordsToDelete();
                end;
            }
            action(DeleteRecords)
            {
                CaptionML = ENU = 'Delete Records (no trigger!)';
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the DeleteRecords action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.DeleteRecords(false);
                end;
            }
            action(DeleteRecordsWithTrigger)
            {
                CaptionML = ENU = 'Delete Records (with trigger!)';
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the DeleteRecordsWithTrigger action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.DeleteRecords(true);
                end;
            }
            action(CheckTableRelations)
            {
                CaptionML = ENU = 'Check Table Relations';
                Promoted = true;
                PromotedIsBig = true;
                Image = Relationship;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the CheckTableRelations action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.CheckTableRelations();
                end;
            }
            action(ViewRecords)
            {
                CaptionML = ENU = 'View Records';
                Promoted = true;
                PromotedIsBig = true;
                Image = Table;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the ViewRecords action.';
                trigger OnAction()
                begin
                    RecordDeletionMgt.ViewRecords(Rec);
                end;
            }
        }

    }
    var
        RecordDeletionMgt: Codeunit "Record Deletion Mgt.";

}
