unit msg.main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBCtrls, DBGrids;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    dtsAniver: TDataSource;
    grdAniver: TDBGrid;
    img: TImage;
    pnlTitulo: TPanel;
    pnlMain: TPanel;
    btnSair: TSpeedButton;
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #27 : Close;
  end;
end;

end.
