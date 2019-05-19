unit uFrmCadQuadroTarefas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Colors, FMX.EditBox,
  FMX.NumberBox, FMX.Edit, FireDAC.Comp.DataSet, System.UIConsts, FireDAC.DApt;

type
  TfrmCadQuadroTarefas = class(TfrmBase)
    actCancelar: TAction;
    lytButtons: TLayout;
    crclCancelar: TCircle;
    rndrctSalvar: TRoundRect;
    lytCancelarTopo: TLayout;
    lbl1: TLabel;
    lblBtnSalvar: TLabel;
    btnSalvar: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnVoltar: TSpeedButton;
    lytFormulario: TLayout;
    edtNome: TEdit;
    nmbrbxPosicao: TNumberBox;
    cmbclrbxColorBox: TComboColorBox;
    lblNome: TLabel;
    lblCor: TLabel;
    lblPosicao: TLabel;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    procedure loadRecord();
    procedure saveRecord();
    procedure changeRecord();
    procedure closeWindow();
    function checkCampos(): Boolean;
  public
    { Public declarations }
  end;

var
  frmCadQuadroTarefas: TfrmCadQuadroTarefas;

implementation

uses
  uFrmQuadroTarefas;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

{ TfrmCadQuadroTarefas }

procedure TfrmCadQuadroTarefas.btnCancelarClick(Sender: TObject);
begin
  try
    try
      inherited;
      closeWindow();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnCancelarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.btnSalvarClick(Sender: TObject);
begin
  try
    try
      inherited;

      if edtCodigo.Text <> '' then
        changeRecord()
      else
        saveRecord();
    except
       on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnSalvarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.btnVoltarClick(Sender: TObject);
begin
  try
    try
      inherited;
      closeWindow();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnVoltarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.closeWindow;
begin
  try
    try
      Self.Close;
      frmQuadroTarefas.loadRecords();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.closeWindow;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.FormShow(Sender: TObject);
begin
  try
    try
      inherited;
      loadRecord();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.FormShow;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.loadRecord;
var
  Campo, Tabela, Inner, Where, OrderBy: string;
  dsDados: TFDDataSet;
begin
  try
    try
      // Se for a alteração do registro ele carrega os dados
      // Se não, então pega a posição do último registro
      if edtCodigo.Text <> '' then
      begin
        Campo   := 'CODIGO, NOME, POSICAO, COR';
        Tabela  := 'QUADRO_TAREFA';
        Inner   := '';
        Where   := 'CODIGO = ' + edtCodigo.Text;
        OrderBy := '';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          edtNome.Text            := dsDados.FieldByName('NOME').AsString;
          nmbrbxPosicao.Value     := dsDados.FieldByName('POSICAO').AsInteger;
          cmbclrbxColorBox.Color  := StringToAlphaColor(dsDados.FieldByName('COR').AsString);
        end;
      end
      else
      begin
        Campo   := 'POSICAO';
        Tabela  := 'QUADRO_TAREFA';
        Inner   := '';
        Where   := '';
        OrderBy := 'ORDER BY CODIGO DESC LIMIT 1';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          nmbrbxPosicao.Value := dsDados.FieldByName('POSICAO').AsInteger + 1;
        end
        else
        begin
          nmbrbxPosicao.Value := 1;
        end;
      end;

    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecord;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.saveRecord;
var
  Tabela, Campos, Valores: string;
  Inserido: Boolean;
begin
  try
    try
      Tabela   := 'QUADRO_TAREFA';
      Campos   := 'NOME, POSICAO, COR';
      Valores  := QuotedStr(edtNome.Text) + ', ' + FloatToStr(nmbrbxPosicao.Value) + ', ' + QuotedStr(ColorToString(cmbclrbxColorBox.Color));

      Inserido := insertRecord(Tabela, Campos, Valores);

      if Inserido then
      begin
        //ShowMessage('Registro inserido com sucesso!');
        closeWindow();
      end
      else
        ShowMessage('Erro ao inserir o registro!');

    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.saveRecord;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadQuadroTarefas.changeRecord;
var
  Tabela, CampoValores, Where: string;
  Atualizado: Boolean;
begin
  try
    try
      Tabela       := 'QUADRO_TAREFA';
      CampoValores := 'NOME = ' + QuotedStr(edtNome.Text) + ', POSICAO = ' + FloatToStr(nmbrbxPosicao.Value) + ', COR = ' + QuotedStr(ColorToString(cmbclrbxColorBox.Color));
      Where        := 'AND CODIGO = ' + edtCodigo.Text;

      Atualizado := updateRecord(Tabela, CampoValores, Where);

      if Atualizado then
      begin
        //ShowMessage('Registro atualizado com sucesso!');
        closeWindow();
      end
      else
        ShowMessage('Erro ao atualizar o registro!');

    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.updateRecord;';
      end;
    end;
  finally
  end;
end;

function TfrmCadQuadroTarefas.checkCampos: Boolean;
begin
  try
    try

    except
      on E: Exception do
      begin
        Result := False;
        E.Message := E.Message + ' - ' + Self.ClassName+'.checkCampos;';
      end;
    end;
  finally
  end;
end;

end.
