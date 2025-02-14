unit uFrmCadSubtarefas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Layouts,
  FireDAC.Comp.DataSet;

type
  TfrmCadSubtarefas = class(TfrmBase)
    rctnglPrincpal: TRectangle;
    lytFormulario: TLayout;
    edtNome: TEdit;
    nmbrbxPosicao: TNumberBox;
    lblNome: TLabel;
    lblPosicao: TLabel;
    edtCodTarefa: TEdit;
    lytButtons: TLayout;
    rndrctSalvar: TRoundRect;
    btnSalvar: TSpeedButton;
    lblBtnSalvar: TLabel;
    btnExcluir: TSpeedButton;
    btnVoltar: TSpeedButton;
    chkConcluida: TCheckBox;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
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
  frmCadSubtarefas: TfrmCadSubtarefas;

implementation

{$R *.fmx}

uses uFrmTarefas;

procedure TfrmCadSubtarefas.btnExcluirClick(Sender: TObject);
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

procedure TfrmCadSubtarefas.btnSalvarClick(Sender: TObject);
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

procedure TfrmCadSubtarefas.btnVoltarClick(Sender: TObject);
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

procedure TfrmCadSubtarefas.changeRecord;
var
  Tabela, CampoValores, Where: string;
  Atualizado, Concluida: Boolean;
begin
  try
    try
      Concluida := chkConcluida.IsChecked;
      Tabela       := 'SUBTAREFA';
      CampoValores := 'NOME = ' + QuotedStr(edtNome.Text) + ', POSICAO = ' + QuotedStr(FloatToStr(nmbrbxPosicao.Value)) + ', COD_TAREFA = ' + QuotedStr(edtCodTarefa.Text) + ', CONCLUIDA = ' + BoolToStr(Concluida);
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

function TfrmCadSubtarefas.checkCampos: Boolean;
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

procedure TfrmCadSubtarefas.closeWindow;
begin
  try
    try
      frmTarefas.loadRecords();
      edtCodigo.Text           := '';
      edtNome.Text             := '';
      nmbrbxPosicao.Value      := 0;
      chkConcluida.IsChecked   := False;
      edtCodTarefa.Text := '';
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

procedure TfrmCadSubtarefas.FormShow(Sender: TObject);
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

procedure TfrmCadSubtarefas.loadColors;
begin
  try
    try
      //Pega as cores da tela anterior e atribui nessa
      btnVoltar.IconTintColor        :=  frmTarefas.lblTopoPrincipal.FontColor;
      btnExcluir.IconTintColor       :=  frmTarefas.lblTopoPrincipal.FontColor;
      lblTopoPrincipal.FontColor     :=  frmTarefas.lblTopoPrincipal.FontColor;
      lblBtnSalvar.FontColor         :=  frmTarefas.lblTopoPrincipal.FontColor;
      rctnglTopoPrincipal.Fill.Color :=  frmTarefas.rctnglTopoPrincipal.Fill.Color;
      rndrctSalvar.Fill.Color        :=  frmTarefas.rctnglTopoPrincipal.Fill.Color;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadColors;';
      end;
    end;
  finally
  end;
end;

procedure TfrmCadSubtarefas.loadRecord;
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
        Campo   := 'CODIGO, NOME, POSICAO, COD_TAREFA, CONCLUIDA';
        Tabela  := 'SUBTAREFA';
        Inner   := '';
        Where   := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);
        OrderBy := '';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          edtNome.Text           := dsDados.FieldByName('NOME').AsString;
          nmbrbxPosicao.Value    := dsDados.FieldByName('POSICAO').AsInteger;
          edtCodTarefa.Text      := dsDados.FieldByName('COD_TAREFA').AsString;
          chkConcluida.IsChecked := dsDados.FieldByName('CONCLUIDA').AsBoolean;
        end;
      end
      else
      begin
        Campo   := 'POSICAO';
        Tabela  := 'SUBTAREFA';
        Inner   := '';
        Where   := 'AND COD_TAREFA = ' + QuotedStr(edtCodTarefa.Text);
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

procedure TfrmCadSubtarefas.rctnglPrincpalClick(Sender: TObject);
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

procedure TfrmCadSubtarefas.removeRecord;
var
  Tabela, Where: string;
  Deletado: Boolean;
begin
  try
    try
      Tabela := 'SUBTAREFA';
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

procedure TfrmCadSubtarefas.saveRecord;
var
  Tabela, Campos, Valores: string;
  Inserido, Concluida: Boolean;
begin
  try
    try
      Concluida := chkConcluida.IsChecked;

      Tabela   := 'SUBTAREFA';
      Campos   := 'NOME, POSICAO, COD_TAREFA, CONCLUIDA';
      Valores  := QuotedStr(edtNome.Text) + ', ' + QuotedStr(FloatToStr(nmbrbxPosicao.Value)) + ', ' + QuotedStr(edtCodTarefa.Text) + ', ' + QuotedStr(BoolToStr(Concluida));

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
