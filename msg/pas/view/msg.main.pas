unit msg.main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, memds, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBCtrls, DBGrids;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    dtsContatos: TDataSource;
    dtsAniver: TDataSource;
    DBGrid1: TDBGrid;
    img: TImage;
    memDtsAniver: TMemDataset;
    pnlTitulo: TPanel;
    pnlMain: TPanel;
    btnSair: TSpeedButton;
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    procedure inserirTemporario();
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnSairClick(Sender: TObject);
begin
  memDtsAniver.Active := False;
  Close;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #27 : Close;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  inserirTemporario();

  if dtsAniver.Dataset.RecordCount = 1 then
    ShowMessage('Aeeeeeeeeeee... '+#13+'Hoje temos um Aniversáriante!')
  else
  if dtsAniver.DataSet.RecordCount > 1 then
     ShowMessage('Aeeeeeeeeeee... '+#13+'Hoje temos Aniversáriantes!')
  else
    ShowMessage('Sem novidades por aqui... '+#13+'Confira novamente amanhã!');

end;

procedure TfrmMain.inserirTemporario;
begin

  //memDtsAniver.FileName := ExtractFilePath(ParamStr(0))+'TblTempMsg0';
  memDtsAniver.Active := True;
  dtsContatos.Dataset.First;

  while not dtsContatos.DataSet.EOF do
  begin

    if FormatDateTime('dd\mm', Now) =
       FormatDateTime('dd\mm', dtsContatos.DataSet.FieldByName('NASCIMENTO').AsDateTime) then
    begin

      memDtsAniver.Insert;
      memDtsAniver.FieldByName('DATA').AsString :=
        FormatDateTime('dd\mm', dtsContatos.Dataset.FieldByName('NASCIMENTO').AsDateTime);
      memDtsAniver.FieldByName('PESSOA').AsString :=
        dtsContatos.Dataset.FieldByName('NOME').AsString;
      memDtsAniver.FieldByName('IDADE').AsInteger :=
         StrToInt(FormatDateTime('yyyy', Now)) -
         StrToInt(FormatDateTime('yyyy', dtsContatos.DataSet.FieldByName('NASCIMENTO').AsDateTime));
      memDtsAniver.Post;

    end;

    dtsContatos.Dataset.Next;

  end;
end;

end.

