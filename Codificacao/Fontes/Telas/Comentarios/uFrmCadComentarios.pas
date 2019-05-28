unit uFrmCadComentarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Layouts,
  FMX.ScrollBox, FMX.Memo, FireDAC.Comp.DataSet;

type
  TfrmCadComentarios = class(TfrmBase)
    rctnglPrincpal: TRectangle;
    lytFormulario: TLayout;
    lblComentario: TLabel;
    edtCodTarefa: TEdit;
    lytButtons: TLayout;
    rndrctSalvar: TRoundRect;
    btnSalvar: TSpeedButton;
    lblBtnSalvar: TLabel;
    btnExcluir: TSpeedButton;
    btnVoltar: TSpeedButton;
    mmoComentario: TMemo;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  frmCadComentarios: TfrmCadComentarios;

implementation

{$R *.fmx}

uses uFrmTarefas;

procedure TfrmCadComentarios.btnExcluirClick(Sender: TObject);
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

procedure TfrmCadComentarios.btnSalvarClick(Sender: TObject);
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
        ShowMessage('Valores inválidos!');
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

procedure TfrmCadComentarios.btnVoltarClick(Sender: TObject);
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

procedure TfrmCadComentarios.changeRecord;
var
  Tabela, CampoValores, Where: string;
  Atualizado: Boolean;
begin
  try
    try
      Tabela       := 'COMENTARIO';
      CampoValores := 'CONTEUDO = ' + QuotedStr(mmoComentario.Text);
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

function TfrmCadComentarios.checkCampos: Boolean;
begin
  try
    try
      Result := True;

      if mmoComentario.Text = '' then
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

procedure TfrmCadComentarios.closeWindow;
begin
  try
    try
      frmTarefas.loadRecords();
      edtCodigo.Text     := '';
      mmoComentario.Text := '';
      edtCodTarefa.Text  := '';
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

procedure TfrmCadComentarios.FormShow(Sender: TObject);
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

procedure TfrmCadComentarios.loadColors;
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

procedure TfrmCadComentarios.loadRecord;
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
        Campo   := 'CODIGO, CONTEUDO, COD_TAREFA';
        Tabela  := 'COMENTARIO';
        Inner   := '';
        Where   := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);
        OrderBy := '';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          mmoComentario.Text := dsDados.FieldByName('CONTEUDO').AsString;
          edtCodTarefa.Text  := dsDados.FieldByName('COD_TAREFA').AsString;
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

procedure TfrmCadComentarios.rctnglPrincpalClick(Sender: TObject);
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

procedure TfrmCadComentarios.removeRecord;
var
  Tabela, Where: string;
  Deletado: Boolean;
begin
  try
    try
      Tabela := 'COMENTARIO';
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

procedure TfrmCadComentarios.saveRecord;
var
  Tabela, Campos, Valores: string;
  Inserido: Boolean;
begin
  try
    try
      Tabela   := 'COMENTARIO';
      Campos   := 'CONTEUDO, COD_TAREFA';
      Valores  := QuotedStr(mmoComentario.Text) + ', ' + QuotedStr(edtCodTarefa.Text);

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
