unit msg.datamodule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbf, IniFiles;

type

  { Tdm }

  Tdm = class(TDataModule)
    qryEnvio: TDbf;
    qryContato: TDbf;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function lerIni : String;
  public

  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin

  qryContato.Active := False;
  qryEnvio.Active := False;

  qryContato.FilePath := lerIni;
  qryContato.FilePathFull := lerIni;
  qryEnvio.FilePath := lerIni;
  qryEnvio.FilePathFull := lerIni;

  qryContato.Active := True;
  qryEnvio.Active := True;

end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  qryContato.Active := False;
  qryEnvio.Active := False;
end;

function Tdm.lerIni: String;
var
  settings : TIniFile;
begin
  settings := TInifile.Create(ExtractFilePath(ParamStr(0))+'\Settings.ini');
  Result := settings.ReadString('DBF', 'PATH', '');
end;

end.
