unit uFrmCadEtapas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.Colors, FMX.EditBox, FMX.NumberBox, FMX.Layouts,
  FireDAC.Comp.DataSet;

type
  TfrmCadEtapas = class(TfrmBase)
    btnExcluir: TSpeedButton;
    btnVoltar: TSpeedButton;
    rctnglPrincpal: TRectangle;
    lytFormulario: TLayout;
    edtNome: TEdit;
    nmbrbxPosicao: TNumberBox;
    lblNome: TLabel;
    lblPosicao: TLabel;
    lytButtons: TLayout;
    rndrctSalvar: TRoundRect;
    btnSalvar: TSpeedButton;
    lblBtnSalvar: TLabel;
    edtCodQuadroTarefas: TEdit;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure rctnglPrincpalClick(Sender: TObject);
  private
    { Private declarations }
    procedure closeWindow();
    procedure loadColors();
    procedure loadRecord();
    procedure saveRecord();
    procedure changeRecord();
    procedure removeRecord();
    function checkCampos(): Boolean;
  public
    { Public declarations }
  end;

var
  frmCadEtapas: TfrmCadEtapas;

implementation

{$R *.fmx}

uses uFrmEtapas;

procedure TfrmCadEtapas.btnExcluirClick(Sender: TObject);
begin
  try
    try
      inherited;

      removeRecord();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnExcluirClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.btnSalvarClick(Sender: TObject);
var
  CamposValidos: Boolean;
begin
  try
    try
      inherited;

      Defocus();

      CamposValidos := checkCampos();

      if CamposValidos then
      begin
        if edtCodigo.Text <> '' then
          changeRecord()
        else
          saveRecord();
      end
      else
      begin
        ShowMessage('Valores inv�lidos!');
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnSalvarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.btnVoltarClick(Sender: TObject);
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

procedure TfrmCadEtapas.changeRecord;
var
  Tabela, CampoValores, Where: string;
  Atualizado: Boolean;
begin
  try
    try
      Tabela       := 'ETAPA';
      CampoValores := 'NOME = ' + QuotedStr(edtNome.Text) + ', POSICAO = ' + QuotedStr(FloatToStr(nmbrbxPosicao.Value)) + ', COD_QUADRO_TAREFA = ' + QuotedStr(edtCodQuadroTarefas.Text);
      Where        := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);

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

function TfrmCadEtapas.checkCampos: Boolean;
begin
  try
    try
      Result := True;

      if edtNome.Text = '' then
        Result := False;

      if nmbrbxPosicao.Value = 0 then
        Result := False;

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

procedure TfrmCadEtapas.closeWindow;
begin
  try
    try
      frmEtapas.loadRecords();
      edtCodigo.Text           := '';
      edtNome.Text             := '';
      nmbrbxPosicao.Value      := 0;
      edtCodQuadroTarefas.Text := '';
      Self.Close;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.closeWindow;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.FormShow(Sender: TObject);
begin
  try
    try
      inherited;
      loadColors();
      loadRecord();

      if edtCodigo.Text <> '' then
        btnExcluir.Visible := True
      else
        btnExcluir.Visible := False;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.FormShow;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.loadColors;
begin
  try
    try
      //Pega as cores da tela anterior e atribui nessa
      btnVoltar.IconTintColor        :=  frmEtapas.lblTopoPrincipal.FontColor;
      btnExcluir.IconTintColor       :=  frmEtapas.lblTopoPrincipal.FontColor;
      lblTopoPrincipal.FontColor     :=  frmEtapas.lblTopoPrincipal.FontColor;
      lblBtnSalvar.FontColor         :=  frmEtapas.lblTopoPrincipal.FontColor;
      rctnglTopoPrincipal.Fill.Color :=  frmEtapas.rctnglTopoPrincipal.Fill.Color;
      rndrctSalvar.Fill.Color        :=  frmEtapas.rctnglTopoPrincipal.Fill.Color;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadColors;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.loadRecord;
var
  Campo, Tabela, Inner, Where, OrderBy: string;
  dsDados: TFDDataSet;
begin
  try
    try
      // Se for a altera��o do registro ele carrega os dados
      // Se n�o, ent�o pega a posi��o do �ltimo registro
      if edtCodigo.Text <> '' then
      begin
        Campo   := 'CODIGO, NOME, POSICAO, COD_QUADRO_TAREFA';
        Tabela  := 'ETAPA';
        Inner   := '';
        Where   := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);
        OrderBy := '';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          edtNome.Text             := dsDados.FieldByName('NOME').AsString;
          nmbrbxPosicao.Value      := dsDados.FieldByName('POSICAO').AsInteger;
          edtCodQuadroTarefas.Text := dsDados.FieldByName('COD_QUADRO_TAREFA').AsString;
        end;
      end
      else
      begin
        Campo   := 'POSICAO';
        Tabela  := 'ETAPA';
        Inner   := '';
        Where   := 'AND COD_QUADRO_TAREFA = ' + QuotedStr(edtCodQuadroTarefas.Text);
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

procedure TfrmCadEtapas.rctnglPrincpalClick(Sender: TObject);
begin
  try
    try
      inherited;

      Defocus();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.rctnglPrincpalClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.removeRecord;
var
  Tabela, Where: string;
  Deletado: Boolean;
begin
  try
    try
      Tabela := 'ETAPA';
      Where  := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);

      Deletado := deleteRecord(Tabela, Where);

      if Deletado then
      begin
        ShowMessage('Registro excluido com sucesso!');
        closeWindow();
      end
      else
        ShowMessage('Erro ao excluir o registro!');
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.removeRecord;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadEtapas.saveRecord;
var
  Tabela, Campos, Valores: string;
  Inserido: Boolean;
begin
  try
    try
      Tabela   := 'ETAPA';
      Campos   := 'NOME, POSICAO, COD_QUADRO_TAREFA';
      Valores  := QuotedStr(edtNome.Text) + ', ' + QuotedStr(FloatToStr(nmbrbxPosicao.Value)) + ', ' + QuotedStr(edtCodQuadroTarefas.Text);

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

end.
