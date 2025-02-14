unit uFrmQuadroTarefas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmBase, System.Actions, FMX.ActnList, FMX.TabControl, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Colors, System.UIConsts,
  FMX.Edit, uFrmCadQuadroTarefas, FireDAC.Comp.DataSet, uFrmEtapas;

type
  TfrmQuadroTarefas = class(TfrmBase)
    crclAddQuadroTarefas: TCircle;
    lytMsgEmpty: TLayout;
    lblMsgEmpty: TLabel;
    lstBoxPrincipal: TListBox;
    stylbkListItem: TStyleBook;
    btnAddQuadroTarefas: TSpeedButton;
    lytPrincipal: TLayout;
    rctnglPrincipal: TRectangle;
    procedure btnAddQuadroTarefasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstBoxPrincipalItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lstBoxPrincipalClick(Sender: TObject);
  private
    { Private declarations }
    procedure ListBoxItemApplyStyleLookup(Sender: TObject);
    procedure createItem(Codigo, Nome, Cor: string);
    procedure btnEditarClick(Sender: TObject);
  public
    { Public declarations }
    procedure loadRecords();

  end;

var
  frmQuadroTarefas: TfrmQuadroTarefas;

implementation

{$R *.fmx}

procedure TfrmQuadroTarefas.btnAddQuadroTarefasClick(Sender: TObject);
begin
  try
    try
      //Application.CreateForm(TfrmCadQuadroTarefas, frmCadQuadroTarefas);
      frmCadQuadroTarefas.FormShow(frmCadQuadroTarefas);
      frmCadQuadroTarefas.Show;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnAddQuadroTarefasClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmQuadroTarefas.btnEditarClick(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      Botao := TSpeedButton(Sender);

      //Application.CreateForm(TfrmCadQuadroTarefas, frmCadQuadroTarefas);
      frmCadQuadroTarefas.edtCodigo.Text := IntToStr(Botao.Tag);
      frmCadQuadroTarefas.FormShow(frmCadQuadroTarefas);
      frmCadQuadroTarefas.Show;


      //ShowMessage(IntToStr(Botao.Tag));
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.btnEditarClick;';
      end;
    end;
  finally
  end;
end;

procedure TfrmQuadroTarefas.createItem(Codigo, Nome, Cor: string);
var
  LItem: TListBoxItem;
begin
  try
    try
      LItem := TListBoxItem.Create(lstBoxPrincipal);
      LItem.Height := 60;
      LItem.Text := Nome;
      LItem.Tag := StrToInt(Codigo);
      LItem.StyleLookup := 'CustomStyle';
      LItem.StylesData['Circle.Fill.Color']  := StringToAlphaColor(Cor);
      LItem.OnApplyStyleLookup := Self.ListBoxItemApplyStyleLookup;
      LItem.ApplyStyleLookup;
      lstBoxPrincipal.AddObject(LItem);
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.createItem;';
      end;
    end;
  finally
  end;
end;

procedure TfrmQuadroTarefas.FormShow(Sender: TObject);
begin
  try
    try
      inherited;
      // Chama a fun��o de carregar os dados toda vez que a tela aparece;
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

procedure TfrmQuadroTarefas.ListBoxItemApplyStyleLookup(Sender: TObject);
var
  Botao: TFMXObject;
begin
  try
    try
      if Sender is TListBoxItem then
      begin
        Botao := TListBoxItem(Sender).FindStyleResource('btnEditar');
        if Botao is TSpeedButton then
        begin
          TSpeedButton(Botao).Tag     := TListBoxItem(Sender).Tag;
          TSpeedButton(Botao).OnClick := Self.btnEditarClick;
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

procedure TfrmQuadroTarefas.loadRecords;
var
  dsDados: TFDDataset;
  Campos, Tabela, Inner, Where, OrderBy, Nome, Cor, Codigo: string;
begin
  try
    try
      lstBoxPrincipal.Items.Clear;

      Campos  := 'CODIGO, NOME, POSICAO, COR';
      Tabela  := 'QUADRO_TAREFA';
      Inner   := '';
      Where   := '';
      OrderBy := 'ORDER BY POSICAO';

      dsDados := selectRecord(Campos, Tabela, Inner, Where, OrderBy);

      if not dsDados.IsEmpty then
      begin
        lytMsgEmpty.Visible := False;
        dsDados.First;

        while not dsDados.Eof do
        begin
          Codigo := dsDados.FieldByName('CODIGO').AsString;
          Nome   := dsDados.FieldByName('NOME').AsString;
          Cor    := dsDados.FieldByName('COR').AsString;

          createItem(Codigo, Nome, Cor);

          dsDados.Next;
        end;
      end
      else
      begin
        lytMsgEmpty.Visible := True;
      end;

      lstBoxPrincipal.ItemIndex := -1;
    except
      on E: Exception do
      begin
        E.Message := E.Message + ' - ' + Self.ClassName+'.loadRecords;';
      end;
    end;
  finally
  end;
end;

procedure TfrmQuadroTarefas.lstBoxPrincipalClick(Sender: TObject);
begin
  inherited;
  Defocus();
end;

procedure TfrmQuadroTarefas.lstBoxPrincipalItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
var
  CodItem: string;
begin
  try
    try
      inherited;
      //ShowMessage( lstBoxPrincipal.ItemByIndex(lstBoxPrincipal.ItemIndex).Tag.ToString() );
      CodItem := lstBoxPrincipal.ItemByIndex(lstBoxPrincipal.ItemIndex).Tag.ToString();
      //Application.CreateForm(TfrmEtapas, frmEtapas);
      frmEtapas.edtCodigo.Text := CodItem;
      frmEtapas.FormShow(frmEtapas);
      frmEtapas.Show;
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
