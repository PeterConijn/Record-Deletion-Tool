table 50001 "Record Deletion Rel. Error"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Record Deletion Rel. Error";
    DrillDownPageId = "Record Deletion Rel. Error";
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(10; "Field No."; Integer)
        {
            Caption = 'Field No.';
            Editable = false;
        }
        field(11; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table ID"), "No." = field("Field No.")));
            Editable = false;
        }
        field(20; Error; Text[250])
        {
            Caption = 'Error';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Table ID", "Entry No.")
        {
            Clustered = true;
        }
    }

}