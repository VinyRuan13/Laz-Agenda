program Agenda;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces,
  Forms, Controls, datetimectrls, lazreportpdfexport, agenda.main,
  agenda.datamodule, agenda.login, agenda.funcao, agenda.message,
  agenda.loading;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmMain, frmMain);
  frmLogin := TfrmLogin.Create(nil);

  if frmLogin.ShowModal = mrOK then
  begin
    frmMain.idUsuarioLogado := frmLogin.idUsuario;
    frmMain.nomeUsuarioLogado := frmLogin.nomeUsuario;
    frmLogin.Release;
    Application.Run;
  end
  else
  begin
    Application.Terminate;
  end;
end.
