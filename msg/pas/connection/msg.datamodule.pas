unit msg.datamodule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbf, memds, IniFiles, msg.message, DB;

type

  { Tdm }

  Tdm = class(TDataModule)
    memDtsAniver: TMemDataset;
    CGeralDBF: TDbf;
    HistoricoDBF: TDbf;
    EnvioDBF: TDbf;
    ContatosDBF: TDbf;
    SequenciaDBF: TDbf;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure HistoricoDBFBeforePost(DataSet: TDataSet);
  private
    function lerIni : String;
    function inserirTemporario() : Boolean;
    procedure carregarGeral();
    function atualizarSequencia(Tabela : String) : Integer;
  public
    aniversario : Boolean;
    modo : Integer;
    tema : Integer;
  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin

  ContatosDBF.Active := False;
  EnvioDBF.Active := False;
  CGeralDBF.Active := False;
  HistoricoDBF.Active := False;

  ContatosDBF.FilePath := lerIni;
  ContatosDBF.FilePathFull := lerIni;
  EnvioDBF.FilePath := lerIni;
  EnvioDBF.FilePathFull := lerIni;
  CGeralDBF.FilePath := lerIni;
  CGeralDBF.FilePathFull := lerIni;
  HistoricoDBF.FilePath := lerIni;
  HistoricoDBF.FilePathFull := lerIni;
  SequenciaDBF.FilePath := lerIni;
  SequenciaDBF.FilePathFull := lerIni;

  ContatosDBF.Active := True;
  EnvioDBF.Active := True;
  CGeralDBF.Active := True;
  HistoricoDBF.Active := True;

  inserirTemporario();
  carregarGeral();

end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  ContatosDBF.Active := False;
  EnvioDBF.Active := False;
end;

procedure Tdm.HistoricoDBFBeforePost(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('ID').AsInteger := atualizarSequencia('HISTORICO');
  end;
end;

function Tdm.lerIni: String;
var
  settings : TIniFile;
begin
  settings := TInifile.Create(ExtractFilePath(ParamStr(0))+'\Settings.ini');
  Result := settings.ReadString('DBF', 'PATH', '');
end;

function Tdm.inserirTemporario: Boolean;
var
  salvo : Boolean;
begin

  salvo := False;
  aniversario := False;

  //memDtsAniver.FileName := ExtractFilePath(ParamStr(0))+'TblTempMsg0';
  memDtsAniver.Active := True;
  ContatosDBF.First;

  try

    while not ContatosDBF.EOF do
    begin

      if FormatDateTime('dd\mm', Now) =
         FormatDateTime('dd\mm', ContatosDBF.FieldByName('NASCIMENTO').AsDateTime) then
      begin

        memDtsAniver.Insert;
        memDtsAniver.FieldByName('DATA').AsString :=
          FormatDateTime('dd\mm', ContatosDBF.FieldByName('NASCIMENTO').AsDateTime);
        memDtsAniver.FieldByName('PESSOA').AsString :=
          ContatosDBF.FieldByName('NOME').AsString;
        memDtsAniver.FieldByName('IDADE').AsInteger :=
           StrToInt(FormatDateTime('yyyy', Now)) -
           StrToInt(FormatDateTime('yyyy', ContatosDBF.FieldByName('NASCIMENTO').AsDateTime));
        memDtsAniver.Post;

      end;

      ContatosDBF.Next;

    end;

    if memDtsAniver.RecordCount > 0 then
    begin
      aniversario := True;
    end;

    salvo := True;

  except on ex:Exception do
    TfrmMessage.Mensagem('Ocorreu o seguinte erro : '+ex.Message, 'Erro', 'E', [mbOk], tema);
  end;

  Result := salvo;

end;

procedure Tdm.carregarGeral;
begin
  try

    CGeralDBF.First;
    modo := CGeralDBF.FieldByName('MODOMSG').AsInteger;
    tema := CGeralDBF.FieldByName('TEMAMSG').AsInteger;

  except on ex:Exception do
    TfrmMessage.Mensagem('Ocorreu o seguinte erro : '+ex.Message, 'Erro', 'E', [mbOk], tema);
  end;
end;

function Tdm.atualizarSequencia(Tabela : String) : Integer;
var
  campo : String;
begin
  SequenciaDBF.Open;

  if SequenciaDBF.RecordCount = 0 then
  begin
    SequenciaDBF.Insert;
    SequenciaDBF.FieldByName('ID').AsInteger := 1;
    SequenciaDBF.FieldByName('SUSUARIO').AsInteger := 0;
    SequenciaDBF.FieldByName('SCONTATOS').AsInteger := 0;
    SequenciaDBF.FieldByName('SHISTORICO').AsInteger := 0;
    SequenciaDBF.Post;
  end;

  SequenciaDBF.Locate('ID', 1, []);

  SequenciaDBF.Edit;

  if Tabela = 'CONTATOS' then
  begin
    campo := 'SCONTATOS';
  end;
  if Tabela = 'USUARIOS' then
  begin
    campo := 'SUSUARIO';
  end;
  if Tabela = 'HISTORICO' then
  begin
    campo := 'SHISTORICO';
  end;

  SequenciaDBF.FieldByName(campo).AsInteger :=
                            SequenciaDBF.FieldByName(campo).AsInteger + 1;
  SequenciaDBF.Post;

  Result := SequenciaDBF.FieldByName(campo).AsInteger;
end;

end.
