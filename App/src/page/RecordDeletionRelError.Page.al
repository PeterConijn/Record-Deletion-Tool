page 50001 "Record Deletion Rel. Error"
{

    PageType = List;
    SourceTable = "Record Deletion Rel. Error";
    Caption = 'Record Deletion Rel. Error';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the Entry No.';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the error text if an error occured';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the Field Name';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the Field No.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the Table ID';
                }
            }
        }
    }

}
