unit uDmCon;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, System.IOUtils;

type
  TdmCon = class(TDataModule)
    conLocal: TFDConnection;
    procedure conLocalBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmCon: TdmCon;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmCon.conLocalBeforeConnect(Sender: TObject);
begin
  try
    try
      {$IF DEFINED(iOS) or DEFINED(ANDROID)}
      conLocal.Params.Values['Database'] :=
        TPath.Combine(TPath.GetDocumentsPath, 'BDTAREFAS.s3db');
      {$ENDIF}
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.conLocalBeforeConnect;';
      end;
    end;
  finally
  end;
end;

end.
