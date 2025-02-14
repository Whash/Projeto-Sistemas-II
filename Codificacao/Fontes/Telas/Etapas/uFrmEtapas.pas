unit uFrmEtapas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FireDAC.Comp.DataSet,
  System.UIConsts, uFrmCadEtapas, uFrmCadTarefas, uFrmTarefas;

type
  TfrmEtapas = class(TfrmBase)
    btnVoltar: TSpeedButton;
    rctnglPrincpal: TRectangle;
    crclAddEtapas: TCircle;
    btnAddEtapas: TSpeedButton;
    lytMsgEmpty: TLayout;
    lblMsgEmpty: TLabel;
    lytPrincipal: TLayout;
    lstBoxPrincipal: TListBox;
    stylbkGroupHeader: TStyleBook;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddEtapasClick(Sender: TObject);
    procedure lstBoxPrincipalItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure ListBoxGroupHeaderApplyStyleLookup(Sender: TObject);
    procedure btnEditaEtapaClick(Sender: TObject);
    procedure btnAddTarefaClick(Sender: TObject);
    procedure closeWindow();
    procedure loadInfoQuadroTarefas();
    function loadEtapas(): TFDDataSet;
    function loadTarefas(CodEtapa: string): TFDDataSet;
    procedure createEtapas(dsEtapas: TFDDataSet);
    procedure createTarefas(dsTarefas: TFDDataSet);
    function getCountSubtarefas(CodTarefa: string): Boolean;
  public
    { Public declarations }
    procedure loadRecords();

  end;

var
  frmEtapas: TfrmEtapas;

implementation

{$R *.fmx}

uses uFrmQuadroTarefas;

procedure TfrmEtapas.btnAddEtapasClick(Sender: TObject);
begin
  try
    try
      inherited;

      frmCadEtapas.edtCodQuadroTarefas.Text := edtCodigo.Text; // Passando o c�digo do Quadro de Tarefas
      frmCadEtapas.FormShow(frmCadEtapas);
      frmCadEtapas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnAddEtapasClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.btnAddTarefaClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      //Application.CreateForm(TfrmCadQuadroTarefas, frmCadQuadroTarefas);
      frmCadTarefas.edtCodEtapa.Text := IntToStr(Botao.Tag);
      frmCadTarefas.FormShow(frmCadTarefas);
      frmCadTarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnAddTarefaClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.btnEditaEtapaClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      //Application.CreateForm(TfrmCadQuadroTarefas, frmCadQuadroTarefas);
      frmCadEtapas.edtCodigo.Text := IntToStr(Botao.Tag);
      frmCadEtapas.FormShow(frmCadEtapas);
      frmCadEtapas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnEditaEtapaClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.btnVoltarClick(Sender: TObject);
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

procedure TfrmEtapas.closeWindow;
begin
  try
    try
      frmQuadroTarefas.loadRecords();
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

procedure TfrmEtapas.createEtapas(dsEtapas: TFDDataSet);
var
  LItem: TListBoxGroupHeader;
  LNulo: TListBoxItem;
  Codigo, Nome: string;
  dsTarefas: TFDDataSet;
begin
  try
    try
      {$REGION 'Header escondido'}
      // � criado um Header invisivel porque o primeiro Header est� ficando bugando
      LItem                    := TListBoxGroupHeader.Create(lstBoxPrincipal);
      LItem.Height             := 0;
      LItem.Text               := 'Nulo';
      LItem.Tag                := 0;
      LItem.Visible            := False;
      lstBoxPrincipal.AddObject(LItem);
      {$ENDREGION}

      dsEtapas.First;

      while not dsEtapas.EoF do
      begin
        Codigo := dsEtapas.FieldByName('CODIGO').AsString;
        Nome   := dsEtapas.FieldByName('NOME').AsString;

        LItem                    := TListBoxGroupHeader.Create(lstBoxPrincipal);
        LItem.Height             := 60;
        LItem.Text               := Nome;
        LItem.Tag                := StrToInt(Codigo);
        LItem.StyleLookup        := 'ListBoxGroupHeaderStyle';
        LItem.OnApplyStyleLookup := Self.ListBoxGroupHeaderApplyStyleLookup;
        //LItem.ApplyStyleLookup;
        lstBoxPrincipal.AddObject(LItem);

        dsTarefas := loadTarefas(Codigo);

        if not dsTarefas.IsEmpty then
          createTarefas(dsTarefas);

        dsEtapas.Next;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.createEtapas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.createTarefas(dsTarefas: TFDDataSet);
var
  LItem: TListBoxItem;
  Codigo, Nome, Porc: string;
  CountSubtarefas: Boolean;
begin
  try
    try
      dsTarefas.First;

      while not dsTarefas.Eof do
      begin
        Codigo := dsTarefas.FieldByName('CODIGO').AsString;
        Nome   := dsTarefas.FieldByName('NOME').AsString;
        Porc   := FormatFloat('##0', dsTarefas.FieldByName('PORC_CONCLUIDA').AsFloat);
        CountSubtarefas := getCountSubtarefas(Codigo);


        LItem                             := TListBoxItem.Create(lstBoxPrincipal);
        LItem.Height                      := 60;
        LItem.Text                        := Nome;
        LItem.Tag                         := StrToInt(Codigo);
        LItem.StyleLookup                 := 'StyleTarefa';
        LItem.StylesData['lblPorc.Text']  := Porc + '%';

        if CountSubtarefas then
          LItem.StylesData['lblPorc.Visible']  := True
        else
          LItem.StylesData['lblPorc.Visible']  := False;

        LItem.ApplyStyleLookup;
        lstBoxPrincipal.AddObject(LItem);

        dsTarefas.Next;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.createTarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmEtapas.FormShow(Sender: TObject);
begin
  try
    try
      inherited;

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

function TfrmEtapas.getCountSubtarefas(CodTarefa: string): Boolean;
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

procedure TfrmEtapas.ListBoxGroupHeaderApplyStyleLookup(Sender: TObject);
var
  btnEditarEtapa, btnAddTarefa: TFMXObject;
begin
  try
    try
      if Sender is TListBoxGroupHeader then
      begin
        btnEditarEtapa := TListBoxGroupHeader(Sender).FindStyleResource('btnEditarEtapa');
        btnAddTarefa   := TListBoxGroupHeader(Sender).FindStyleResource('btnAddTarefa');

        if btnEditarEtapa is TSpeedButton then
        begin
          TSpeedButton(btnEditarEtapa).Tag     := TListBoxGroupHeader(Sender).Tag;
          TSpeedButton(btnEditarEtapa).OnClick := Self.btnEditaEtapaClick;
        end;

        if btnAddTarefa is TSpeedButton then
        begin
          TSpeedButton(btnAddTarefa).Tag     := TListBoxGroupHeader(Sender).Tag;
          TSpeedButton(btnAddTarefa).OnClick := Self.btnAddTarefaClick;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.ListBoxGroupHeaderApplyStyleLookup;';
      end;
    end;
  finally
  end;
end;

function TfrmEtapas.loadEtapas: TFDDataSet;
var
  dsDados: TFDDataset;
  Campos, Tabela, Inner, Where, OrderBy: string;
begin
  try
    try
      lstBoxPrincipal.Items.Clear;

      Campos  := 'CODIGO, NOME, POSICAO, COD_QUADRO_TAREFA';
      Tabela  := 'ETAPA';
      Inner   := '';
      Where   := 'AND COD_QUADRO_TAREFA = ' + QuotedStr(edtCodigo.Text);
      OrderBy := 'ORDER BY POSICAO';

      dsDados := selectRecord(Campos, Tabela, Inner, Where, OrderBy);

      Result := dsDados;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecords;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.loadInfoQuadroTarefas;
var
  dsDados: TFDDataset;
  Campos, Tabela, Inner, Where, OrderBy, Nome, Cor, Codigo: string;
begin
  try
    try
      // Carrega as informa��es do Quadro de Tarefas
      lstBoxPrincipal.Items.Clear;

      Campos  := 'NOME, COR';
      Tabela  := 'QUADRO_TAREFA';
      Inner   := '';
      Where   := 'AND CODIGO = ' + QuotedStr(edtCodigo.Text);
      OrderBy := '';

      dsDados := selectRecord(Campos, Tabela, Inner, Where, OrderBy);

      if not dsDados.IsEmpty then
      begin
        dsDados.First;

        while not dsDados.Eof do
        begin
          lblTopoPrincipal.Text          := dsDados.FieldByName('NOME').AsString;
          rctnglTopoPrincipal.Fill.Color := StringToAlphaColor(dsDados.FieldByName('COR').AsString);
          crclAddEtapas.Fill.Color       := StringToAlphaColor(dsDados.FieldByName('COR').AsString);

          // Muda a cor do texto de acordo com a cor do fundo
          if ColorIsLight(StringToAlphaColor(dsDados.FieldByName('COR').AsString)) then
          begin
            lblTopoPrincipal.TextSettings.FontColor := StringToAlphaColor('Darkslategray');
            btnAddEtapas.TextSettings.FontColor     := StringToAlphaColor('Darkslategray');
            btnVoltar.IconTintColor                 := StringToAlphaColor('Darkslategray');
          end
          else
          begin
            lblTopoPrincipal.TextSettings.FontColor := StringToAlphaColor('White');
            btnAddEtapas.TextSettings.FontColor     := StringToAlphaColor('White');
            btnVoltar.IconTintColor                 := StringToAlphaColor('White');
          end;

          dsDados.Next;
        end;
      end;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadInfoQuadroTarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.loadRecords;
var
  dsEtapas, dsTarefas: TFDDataSet;
begin
  try
    try
      loadInfoQuadroTarefas();

      dsEtapas := loadEtapas();

      if not dsEtapas.IsEmpty then
      begin
        createEtapas(dsEtapas);
        lytMsgEmpty.Visible := False;
      end
      else
      begin
        lytMsgEmpty.Visible := True;
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

function TfrmEtapas.loadTarefas(CodEtapa: string): TFDDataSet;
var
  dsDados: TFDDataset;
  Campos, Tabela, Inner, Where, OrderBy: string;
begin
  try
    try
      Campos  := 'CODIGO, COD_ETAPA, NOME, POSICAO, DESCRICAO, PORC_CONCLUIDA';
      Tabela  := 'TAREFA';
      Inner   := '';
      Where   := 'AND COD_ETAPA = ' + QuotedStr(CodEtapa);
      OrderBy := 'ORDER BY POSICAO';

      dsDados := selectRecord(Campos, Tabela, Inner, Where, OrderBy);

      Result := dsDados;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadTarefas;';
      end;
    end;
  finally
  end;
end;

procedure TfrmEtapas.lstBoxPrincipalItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  CodItem: string;
begin
  try
    try
      inherited;

      CodItem := lstBoxPrincipal.ItemByIndex(lstBoxPrincipal.ItemIndex).Tag.ToString();
      frmTarefas.edtCodigo.Text := CodItem;
      frmTarefas.FormShow(frmTarefas);
      frmTarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.lstBoxPrincipalItemClick;';
      end;
    end;
  finally
  end;
end;

end.
