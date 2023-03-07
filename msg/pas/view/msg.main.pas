unit msg.main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBCtrls, DBGrids, msg.datamodule;

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
    procedure FormCreate(Sender: TObject);
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

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i : Integer;
begin

  if dm.tema = 1 then
  begin

    Color := $00FEA5A5;
    pnlTitulo.Font.Color := clGreen;
    pnlMain.Color := clWhite;
    grdAniver.AlternateColor := $00EBEEFE;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := clGreen;
      grdAniver.Columns[i].Color := clWhite;
      grdAniver.Columns[i].Title.Font.Style := [fsBold];
    end;

  end;
  if dm.tema = 2 then
  begin

    Color := clWhite;
    pnlTitulo.Font.Color := $00FFBF00;
    pnlMain.Color := clWhite;
    grdAniver.AlternateColor := $00FFFFE0;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := $00E16941;
      grdAniver.Columns[i].Font.Color := $00E16941;
      grdAniver.Columns[i].Color := clWhite;
      grdAniver.Columns[i].Title.Font.Style := [];
    end;

  end;
  if dm.tema = 3 then
  begin

    Color := $004F4F2F;
    pnlTitulo.Font.Color := clWhite;
    pnlMain.Color := $004F4F2F;
    grdAniver.AlternateColor := $004F4F2F;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := $004F4F2F;
      grdAniver.Columns[i].Font.Color := clWhite;
      grdAniver.Columns[i].Color := $004F4F2F;
      grdAniver.Columns[i].Title.Font.Style := [fsBold];
    end;

  end;
  if dm.tema = 4 then
  begin

    Color := clGreen;
    pnlTitulo.Font.Color := clGreen;
    pnlMain.Color := $0098FB98;
    grdAniver.AlternateColor := $0090EE90;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := clGreen;
      grdAniver.Columns[i].Font.Color := clGreen;
      grdAniver.Columns[i].Color := $0098FB98;
      grdAniver.Columns[i].Font.Style := [fsBold];
      grdAniver.Columns[i].Title.Font.Style := [fsBold];
    end;

  end;
  if dm.tema = 5 then
  begin
    Color := clBlue;
    pnlTitulo.Font.Color := $00FF706C;
    pnlMain.Color := $00E6D8AD;
    grdAniver.AlternateColor := $00E6D8AD;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := $00FF706C;
      grdAniver.Columns[i].Font.Color := $00FF706C;
      grdAniver.Columns[i].Color := $00E6D8AD;
      grdAniver.Columns[i].Title.Font.Style := [fsBold];
    end;
  end;
  if dm.tema = 6 then
  begin

    Color := $002B05DA;
    pnlTitulo.Font.Color := $002B05DA;
    pnlMain.Color := $00D5D7FF;
    grdAniver.AlternateColor := clWhite;

    for i := 0 to grdAniver.Columns.Count-1 do
    begin
      grdAniver.Columns[i].Title.Font.Color := $002B05DA;
      grdAniver.Columns[i].Title.Font.Style := [fsBold];
      grdAniver.Columns[i].Color := $00D5D7FF;
    end;

  end;

end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #27 : Close;
  end;
end;

end.
