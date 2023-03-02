unit service.datamodule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbf, IniFiles;

type

  { Tdm }

  Tdm = class(TDataModule)
    qryEmail: TDbf;
    qryContato: TDbf;
    procedure DataModuleCreate(Sender: TObject);
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
  qryEmail.Active := False;

  qryContato.FilePath := lerIni;
  qryContato.FilePathFull := lerIni;
  qryEmail.FilePath := lerIni;
  qryEmail.FilePathFull := lerIni;



end;

function Tdm.lerIni: String;
var
  settings : TIniFile;
begin
  settings := TInifile.Create(ExtractFilePath(ParamStr(0))+'\Settings.ini');
  Result := settings.ReadString('DBF', 'PATH', '');
end;

end.
