object dmCon: TdmCon
  OldCreateOrder = False
  Height = 106
  Width = 115
  object conLocal: TFDConnection
    Params.Strings = (
      
        'Database=D:\Faculdade\7'#176' Semestre\Projetos de Sistema II\Projeto' +
        '-Sistemas-II\Codificacao\Fontes\Banco\BDTAREFAS.s3db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = conLocalBeforeConnect
    Left = 40
    Top = 32
  end
end
