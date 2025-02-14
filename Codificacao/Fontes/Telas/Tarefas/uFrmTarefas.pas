unit uFrmTarefas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ListBox, uFrmCadTarefas,
  FireDAC.Comp.DataSet, uFrmCadSubtarefas;

type
  TfrmTarefas = class(TfrmBase)
    btnVoltar: TSpeedButton;
    btnEditar: TSpeedButton;
    rctnglPrincipal: TRectangle;
    lytDescricao: TLayout;
    lytPorcentagem: TLayout;
    lytListBox: TLayout;
    mmoDescricao: TMemo;
    rctnglDescricao: TRectangle;
    rctnglPorcentagem: TRectangle;
    rctnglListBox: TRectangle;
    lstBoxPrincipal: TListBox;
    pbPorcentagem: TProgressBar;
    lblConclusao: TLabel;
    lblPorcentagem: TLabel;
    stylbkGroupHeader: TStyleBook;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure closeWindow();
    procedure loadColors();
    procedure loadSubTarefas();
    procedure loadComentarios();
    procedure createSubTarefas(dsSubTarefas: TFDDataSet);
    procedure createComentarios(dsComentarios: TFDDataSet);
    procedure ApplyStyleSubtarefas(Sender: TObject);
    procedure ApplyStyleComentarios(Sender: TObject);
    procedure ApplyStyleSubtarefasItem(Sender: TObject);
    procedure ApplyStyleComentariosItem(Sender: TObject);
    procedure btnAddSubtarefasClick(Sender: TObject);
    procedure btnAddComentariosClick(Sender: TObject);
    procedure btnEditSubTarefaClick(Sender: TObject);
    procedure btnEditComentarioClick(Sender: TObject);
    procedure OnChangeCheckBox(Sender: TObject);
    function calcProgressBar(Total, Marcados: Integer): Double;
    procedure AttSubTarefaConcluida(CodSubTarefa, Concluida: string);
    procedure AttPorcConcluida(Porcentagem: Double);
    function getCountSubtarefas(CodTarefa: string): Boolean;
  public
    { Public declarations }
    procedure loadRecords();


  end;

var
  frmTarefas: TfrmTarefas;

implementation

{$R *.fmx}

uses uFrmEtapas, uFrmCadComentarios;

procedure TfrmTarefas.ApplyStyleComentarios(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      if Sender is TListBoxGroupHeader then
      begin
        Botao := TListBoxItem(Sender).FindStyleResource('btnAddSubTarefaComentarios');
        if Botao is TSpeedButton then
        begin
          TSpeedButton(Botao).Tag     := TListBoxItem(Sender).Tag;
          TSpeedButton(Botao).OnClick := Self.btnAddComentariosClick;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.ListBoxItemApplyStyleLookup;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.ApplyStyleComentariosItem(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      if Sender is TListBoxItem then
      begin
        Botao := TListBoxItem(Sender).FindStyleResource('btnEditComentario');
        if Botao is TSpeedButton then
        begin
          TSpeedButton(Botao).Tag     := TListBoxItem(Sender).Tag;
          TSpeedButton(Botao).OnClick := Self.btnEditComentarioClick;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.ApplyStyleComentariosItem;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.ApplyStyleSubtarefas(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      if Sender is TListBoxGroupHeader then
      begin
        Botao := TListBoxItem(Sender).FindStyleResource('btnAddSubTarefaComentarios');
        if Botao is TSpeedButton then
        begin
          TSpeedButton(Botao).Tag     := TListBoxItem(Sender).Tag;
          TSpeedButton(Botao).OnClick := Self.btnAddSubtarefasClick;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.ListBoxItemApplyStyleLookup;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.ApplyStyleSubtarefasItem(Sender: TObject);
var
  Botao, CheckBox: TFMXObject;
begin
  try
    try
      if Sender is TListBoxItem then
      begin
        Botao := TListBoxItem(Sender).FindStyleResource('btnEditSubTarefa');
        if Botao is TSpeedButton then
        begin
          TSpeedButton(Botao).Tag     := TListBoxItem(Sender).Tag;
          TSpeedButton(Botao).OnClick := Self.btnEditSubtarefaClick;
        end;

        CheckBox := TListBoxItem(Sender).FindStyleResource('chkSubTarefa');
        if CheckBox is TCheckBox then
        begin
          TCheckBox(CheckBox).OnChange := Self.OnChangeCheckBox;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.ListBoxItemApplyStyleLookup;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.AttPorcConcluida(Porcentagem: Double);
var
  Tabela, CampoValores, Where: string;
  Atualizado: Boolean;
begin
  try
    try
      Tabela       := 'TAREFA';
      CampoValores := 'PORC_CONCLUIDA = ' + QuotedStr(FloatToStr(Porcentagem));
      Where        := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);

      Atualizado := updateRecord(Tabela, CampoValores, Where);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.AttSubTarefaConcluida;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.AttSubTarefaConcluida(CodSubTarefa, Concluida: string);
var
  Tabela, CampoValores, Where, sConcluida: string;
  Atualizado: Boolean;
begin
  try
    try
      if Concluida = 'True' then
        sConcluida := '-1'
      else
        sConcluida := '0';

      Tabela       := 'SUBTAREFA';
      CampoValores := 'CONCLUIDA = ' + QuotedStr(sConcluida);
      Where        := 'AND CODIGO = ' + QuotedStr(CodSubTarefa);

      Atualizado := updateRecord(Tabela, CampoValores, Where);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.AttSubTarefaConcluida;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnAddComentariosClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      frmCadComentarios.edtCodTarefa.Text := edtCodigo.Text;
      frmCadComentarios.FormShow(frmCadComentarios);
      frmCadComentarios.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnAddTarefaClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnAddSubtarefasClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      frmCadSubtarefas.edtCodTarefa.Text := edtCodigo.Text;
      frmCadSubtarefas.FormShow(frmCadSubtarefas);
      frmCadSubtarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnAddTarefaClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnEditarClick(Sender: TObject);
begin
  try
    try
      inherited;

      frmCadTarefas.edtCodigo.Text := edtCodigo.Text;
      frmCadTarefas.FormShow(frmCadTarefas);
      frmCadTarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnEditarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnEditComentarioClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      frmCadComentarios.edtCodigo.Text := IntToStr(Botao.Tag);
      frmCadComentarios.FormShow(frmCadComentarios);
      frmCadComentarios.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnEditarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnEditSubTarefaClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      frmCadSubTarefas.edtCodigo.Text := IntToStr(Botao.Tag);
      frmCadSubtarefas.FormShow(frmCadSubtarefas);
      frmCadSubTarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnEditarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.btnVoltarClick(Sender: TObject);
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

function TfrmTarefas.calcProgressBar(Total, Marcados: Integer): Double;
var
  Porcentagem: Double;
begin
  try
    try
      if Total = 0 then
        Porcentagem := 0
      else
        Porcentagem := (Marcados / Total) * 100;
      pbPorcentagem.Value := Porcentagem;
      lblPorcentagem.Text := FormatFloat('##0', Porcentagem) + '%';

      Result := Porcentagem;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.calcProgressBar;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.closeWindow;
begin
  try
    try
      frmEtapas.loadRecords();
      edtCodigo.Text := '';
      lstBoxPrincipal.Items.Clear;
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

procedure TfrmTarefas.createComentarios(dsComentarios: TFDDataSet);
var
  LHeader: TListBoxGroupHeader;
  LItem: TListBoxItem;
  Codigo, Conteudo: string;
begin
  try
    try
      LHeader             := TListBoxGroupHeader.Create(lstBoxPrincipal);
      LHeader.Height      := 60;
      LHeader.Text        := 'Coment�rios';
      LHeader.Tag         := 0;
      LHeader.StyleLookup := 'ListBoxGroupHeaderStyleTarefa';
      LHeader.OnApplyStyleLookup := Self.ApplyStyleComentarios;
      lstBoxPrincipal.AddObject(LHeader);

      if not dsComentarios.IsEmpty then
      begin
        dsComentarios.First;

        while not dsComentarios.EoF do
        begin
          Codigo    := dsComentarios.FieldByName('CODIGO').AsString;
          Conteudo  := dsComentarios.FieldByName('CONTEUDO').AsString;

          LItem                                  := TListBoxItem.Create(lstBoxPrincipal);
          LItem.Height                           := 60;
          LItem.Text                             := Conteudo;
          LItem.Tag                              := StrToInt(Codigo);
          LItem.StylesData['lblComentario.Text'] := Conteudo;
          LItem.StyleLookup                      := 'StyleComentario';
          LItem.OnApplyStyleLookup := Self.ApplyStyleComentariosItem;
          lstBoxPrincipal.AddObject(LItem);

          dsComentarios.Next;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.createSubTarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.createSubTarefas(dsSubTarefas: TFDDataSet);
var
  LHeader: TListBoxGroupHeader;
  LItem: TListBoxItem;
  Codigo, Nome, Concluida: string;
begin
  try
    try
      {$REGION 'Header escondido'}
      // � criado um Header invisivel porque o primeiro Header est� ficando bugando
      LHeader                    := TListBoxGroupHeader.Create(lstBoxPrincipal);
      LHeader.Height             := 0;
      LHeader.Text               := 'Nulo';
      LHeader.Tag                := 0;
      LHeader.Visible            := False;
      lstBoxPrincipal.AddObject(LHeader);
      {$ENDREGION}

      LHeader             := TListBoxGroupHeader.Create(lstBoxPrincipal);
      LHeader.Height      := 60;
      LHeader.Text        := 'Subtarefas';
      LHeader.Tag         := 0;
      LHeader.StyleLookup := 'ListBoxGroupHeaderStyleTarefa';
      LHeader.OnApplyStyleLookup := Self.ApplyStyleSubtarefas;
      lstBoxPrincipal.AddObject(LHeader);

      if not dsSubTarefas.IsEmpty then
      begin
        dsSubTarefas.First;

        while not dsSubTarefas.EoF do
        begin
          Codigo    := dsSubTarefas.FieldByName('CODIGO').AsString;
          Nome      := dsSubTarefas.FieldByName('NOME').AsString;
          Concluida := dsSubTarefas.FieldByName('CONCLUIDA').AsString;

          LItem                    := TListBoxItem.Create(lstBoxPrincipal);
          LItem.Height             := 60;
          LItem.Text               := Nome;
          LItem.Tag                := StrToInt(Codigo);
          LItem.StyleLookup        := 'lstStyleCheckBox';
          LItem.StylesData['chkSubTarefa.Text'] := Nome;
          LItem.StylesData['chkSubTarefa.IsChecked'] := StrToBool(Concluida);
          //LItem.StylesData['chkSubTarefa.OnChange'] := Self.OnChangeCheckBox;
          LItem.OnApplyStyleLookup := Self.ApplyStyleSubtarefasItem;
          lstBoxPrincipal.AddObject(LItem);

          dsSubTarefas.Next;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.createSubTarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  try
    try
      inherited;
      if Key = vkHardwareBack then
      begin
        closeWindow();
        key := 0;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.FormKeyUp;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.FormShow(Sender: TObject);
begin
  try
    try
      inherited;
      loadColors();
      loadRecords();
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.FormShow;';
      end;
    end;
  finally
  end;
end;

function TfrmTarefas.getCountSubtarefas(CodTarefa: string): Boolean;
var
  dsDados: TFDDataset;
  Campos, Tabela, Inner, Where, OrderBy: string;
begin
  try
    try
      Campos  := 'COUNT(CODIGO) AS CODIGO';
      Tabela  := 'SUBTAREFA';
      Inner   := '';
      Where   := 'AND COD_TAREFA = ' + QuotedStr(CodTarefa);
      OrderBy := '';

      dsDados := selectRecord(Campos, Tabela, Inner, Where, OrderBy);

      if dsDados.FieldByName('CODIGO').AsString = '0' then
        Result := False
      else
        Result := True;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.getCountSubtarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.loadColors;
begin
  try
    try
      //Pega as cores da tela anterior e atribui nessa
      btnVoltar.IconTintColor        :=  frmEtapas.lblTopoPrincipal.FontColor;
      btnEditar.IconTintColor        :=  frmEtapas.lblTopoPrincipal.FontColor;
      lblTopoPrincipal.FontColor     :=  frmEtapas.lblTopoPrincipal.FontColor;
      rctnglTopoPrincipal.Fill.Color :=  frmEtapas.rctnglTopoPrincipal.Fill.Color;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadColors;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.loadComentarios();
var
  Campo, Tabela, Inner, Where, OrderBy: string;
  dsDados: TFDDataSet;
begin
  try
    try
      Campo   := 'CODIGO, COD_TAREFA, CONTEUDO';
      Tabela  := 'COMENTARIO';
      Inner   := '';
      Where   := 'AND COD_TAREFA = ' + QuotedStr(edtCodigo.Text);
      OrderBy := 'ORDER BY CODIGO DESC';

      dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

      createComentarios(dsDados);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecords;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.loadRecords;
var
  Campo, Tabela, Inner, Where, OrderBy: string;
  dsDados, dsEtapas: TFDDataSet;
  CountSubtarefas: Boolean;
begin
  try
    try

      lstBoxPrincipal.Items.Clear;

      // Se for a altera��o do registro ele carrega os dados
      // Se n�o, ent�o pega a posi��o do �ltimo registro
      if edtCodigo.Text <> '' then
      begin
        Campo   := 'CODIGO, NOME, POSICAO, COD_ETAPA, DESCRICAO, PORC_CONCLUIDA';
        Tabela  := 'TAREFA';
        Inner   := '';
        Where   := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);
        OrderBy := '';

        dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

        if not dsDados.IsEmpty then
        begin
          lblTopoPrincipal.Text := dsDados.FieldByName('NOME').AsString;
          lblPorcentagem.Text   := FormatFloat('##0', dsDados.FieldByName('PORC_CONCLUIDA').AsFloat) + '%';
          pbPorcentagem.Value   := dsDados.FieldByName('PORC_CONCLUIDA').AsInteger;
          mmoDescricao.Text     := dsDados.FieldByName('DESCRICAO').AsString;
        end;

        loadSubTarefas();
        loadComentarios();
        Self.OnChangeCheckBox(lstBoxPrincipal);

        CountSubtarefas := getCountSubtarefas(edtCodigo.Text);

        if CountSubtarefas then
          lytPorcentagem.Visible := True
        else
          lytPorcentagem.Visible := False;

      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecords;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.loadSubTarefas();
var
  Campo, Tabela, Inner, Where, OrderBy: string;
  dsDados: TFDDataSet;
begin
  try
    try
      Campo   := 'CODIGO, COD_TAREFA, NOME, POSICAO, CONCLUIDA';
      Tabela  := 'SUBTAREFA';
      Inner   := '';
      Where   := 'AND COD_TAREFA = ' + QuotedStr(edtCodigo.Text);
      OrderBy := 'ORDER BY POSICAO';

      dsDados := selectRecord(Campo, Tabela, Inner, Where, OrderBy);

      createSubTarefas(dsDados);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecords;';
      end;
    end;
  finally
  end;
end;

procedure TfrmTarefas.OnChangeCheckBox(Sender: TObject);
var
  i, Total, Marcados: Integer;
  CodSubTarefa, Concluida: string;
  Porcentagem: Double;
begin
  try
    try
      Total    := 0;
      Marcados := 0;

      for i := 0 to lstBoxPrincipal.Items.Count -1 do
      begin
        if (lstBoxPrincipal.ItemByIndex(i).StyleLookup = 'lstStyleCheckBox') then
        begin
          CodSubTarefa := lstBoxPrincipal.ItemByIndex(i).Tag.ToString;
          Concluida    := lstBoxPrincipal.ItemByIndex(i).StylesData['chkSubTarefa.IsChecked'].ToString();

          AttSubTarefaConcluida(CodSubTarefa, Concluida);

          if lstBoxPrincipal.ItemByIndex(i).StylesData['chkSubTarefa.IsChecked'].ToString() = 'True' then
            Marcados := Marcados + 1;

          Total := Total + 1;
        end;
      end;

      Porcentagem := calcProgressBar(Total, Marcados);
      AttPorcConcluida(Porcentagem);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.OnChangeCheckBox;';
      end;
    end;
  finally
  end;
end;

end.
