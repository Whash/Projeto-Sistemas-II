program OrganizZer;



uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmBase in 'Base\uFrmBase.pas' {frmBase},
  uDmCon in 'Conexao\uDmCon.pas' {dmCon: TDataModule},
  uFrmQuadroTarefas in 'Telas\Quadro_Tarefas\uFrmQuadroTarefas.pas' {frmQuadroTarefas},
  uFrmCadQuadroTarefas in 'Telas\Quadro_Tarefas\uFrmCadQuadroTarefas.pas' {frmCadQuadroTarefas},
  uFrmEtapas in 'Telas\Etapas\uFrmEtapas.pas' {frmEtapas},
  uFrmCadEtapas in 'Telas\Etapas\uFrmCadEtapas.pas' {frmCadEtapas},
  uFrmCadTarefas in 'Telas\Tarefas\uFrmCadTarefas.pas' {frmCadTarefas},
  uFrmTarefas in 'Telas\Tarefas\uFrmTarefas.pas' {frmTarefas},
  uFrmCadSubtarefas in 'Telas\SubTarefas\uFrmCadSubtarefas.pas' {frmCadSubtarefas},
  uFrmCadComentarios in 'Telas\Comentarios\uFrmCadComentarios.pas' {frmCadComentarios};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmCon, dmCon);
  Application.CreateForm(TfrmQuadroTarefas, frmQuadroTarefas);
  Application.CreateForm(TfrmEtapas, frmEtapas);
  Application.CreateForm(TfrmBase, frmBase);
  Application.CreateForm(TfrmCadQuadroTarefas, frmCadQuadroTarefas);
  Application.CreateForm(TfrmCadEtapas, frmCadEtapas);
  Application.CreateForm(TfrmCadTarefas, frmCadTarefas);
  Application.CreateForm(TfrmTarefas, frmTarefas);
  Application.CreateForm(TfrmCadSubtarefas, frmCadSubtarefas);
  Application.CreateForm(TfrmCadComentarios, frmCadComentarios);
  Application.Run;
end.
