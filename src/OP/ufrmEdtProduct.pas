unit ufrmEdtProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBasic, ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls, DB,
  DBCtrls, StdCtrls, Mask, DBCtrlsEh, DBGridEh, DBLookupEh, Grids, DBGrids,
  ADODB, uDMEntity, uDMManager;

type
  TfrmEdtProduct = class(TfrmBasic)
    ds_active: TDataSource;
    Label14: TLabel;
    Label21: TLabel;
    dbdtpProductionTime: TDBDateTimeEditEh;
    dbedtTrackingID: TDBEditEh;
    Label10: TLabel;
    gboxCOInfor: TGroupBox;
    Label4: TLabel;
    Label7: TLabel;
    gboxProductionInfo: TGroupBox;
    Label2: TLabel;
    dbedtProductSN: TDBEditEh;
    dbedtWaCode: TDBEditEh;
    Label3: TLabel;
    gboxScheduleInfo: TGroupBox;
    Label5: TLabel;
    dbtxtScheduleID: TDBText;
    Label6: TLabel;
    dbtxtLine: TDBText;
    Label8: TLabel;
    dbdtpScheduleStartTime: TDBDateTimeEditEh;
    gboxTrackComponent: TGroupBox;
    gridComponent: TDBGrid;
    ds_component: TDataSource;
    adt_component: TADODataSet;
    adt_componentProductComponentTrackingID: TAutoIncField;
    adt_componentProductTrackingID: TIntegerField;
    adt_componentComponentID: TIntegerField;
    adt_componentComponentSerialNumber: TStringField;
    adt_componentComponentItem: TStringField;
    adt_componentComponentSeriesID: TIntegerField;
    adt_componentComponentSeriesName: TStringField;
    dbtxtCustomerNumber: TDBText;
    dbtxtModel: TDBText;
    dbtxtCustomerName: TDBText;
    Label9: TLabel;
    Label16: TLabel;
    dbdtpRTD: TDBDateTimeEditEh;
    dbdtpETD: TDBDateTimeEditEh;
    Label1: TLabel;
    DBNavigator2: TDBNavigator;
    dbcbbProductTrackingStates: TDBLookupComboboxEh;
    adt_trackingStates: TADODataSet;
    ds_trackingStates: TDataSource;
    dbedtTrackingStates: TDBEditEh;
    DBNavigator1: TDBNavigator;
    procedure dbedtTrackingIDChange(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetData; override;
    procedure SetUI; override;
    procedure SetAccess; override;
  public
    { Public declarations }
    class procedure EdtFromList(adt_from: TADODataSet);
  end;


implementation

uses DataModule, uMJ;

{$R *.dfm}

{ TfrmEdtProduct }

procedure TfrmEdtProduct.SetData;
begin
  DM.DataSetQuery(adt_trackingStates, 'EXEC usp_GetProductTrackingStates');
end;

procedure TfrmEdtProduct.SetUI;
begin
  inherited;
  Position := poOwnerFormCenter;
end;

procedure TfrmEdtProduct.SetAccess;
begin
  inherited;
end;

class procedure TfrmEdtProduct.EdtFromList(adt_from: TADODataSet);
begin
  with TfrmEdtProduct.Create(Application) do
  try
    ds_active.DataSet := adt_from;
    gboxTrackComponent.Caption := 'Component Of Tracking ID : ' + dbedtTrackingID.Text;

    gboxCOInfor.Enabled := false;
    gboxScheduleInfo.Enabled := false;
    gboxProductionInfo.Enabled := false;
    dbdtpRTD.Color := clBtnFace;
    dbdtpETD.Color := clBtnFace;
    dbedtProductSN.Color := clBtnFace;
    dbedtWaCode.Color := clBtnFace;
    gridComponent.Color := clBtnFace;
    DBNavigator2.Enabled := false;
    gridComponent.ReadOnly := true;

    if (objCurUser.AccessLevel = 3) or (objCurUser.AccessLevel = 22) then
    begin
      DBNavigator2.Enabled := true;
      gridComponent.ReadOnly := false;
      dbcbbProductTrackingStates.Visible := true;
    end;

    if (adt_from.State in [dsEdit]) then
      adt_from.Cancel;

    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmEdtProduct.dbedtTrackingIDChange(Sender: TObject);
begin
  if objCurUser.AccessLevel = 3 then
  begin
    dbcbbProductTrackingStates.Visible := true
      {
    if ((ds_active.DataSet.FieldByName('ProductTrackingStatesID').AsInteger = 1)
      or (ds_active.DataSet.FieldByName('ProductTrackingStatesID').AsInteger = 2)
      or (ds_active.DataSet.FieldByName('ProductTrackingStatesID').AsInteger = 3)
      or (ds_active.DataSet.FieldByName('ProductTrackingStatesID').AsInteger = 4)
      or (ds_active.DataSet.FieldByName('ProductTrackingStatesID').AsInteger = 7)
      ) then
      dbcbbProductTrackingStates.Visible := true
    else
      dbcbbProductTrackingStates.Visible := false;   }
  end
  else
    dbcbbProductTrackingStates.Visible := false;
  gboxTrackComponent.Caption := 'Component Of Product SN. : ' + dbedtProductSN.Text;
  DM.DataSetQuery(adt_component, 'EXEC usp_GetProductComponentTracking @ProductTrackingID='
    + VarToStr(dbedtTrackingID.Value));
  gridComponent.DataSource.DataSet.Active := false;
  gridComponent.DataSource.DataSet.Active := true;
end;

end.

