program msg;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, sdflaz, SysUtils, msg.main, msg.message, msg.datamodule,
  msg.funcao
  { you can add units after this };

{$R *.res}
begin

  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);

  //gravar log
  dm.HistoricoDBF.Insert;
  dm.HistoricoDBF.FieldByName('DATA').AsDateTime := Now;
  dm.HistoricoDBF.FieldByName('HORA').AsString := TimeToStr(Time);
  dm.HistoricoDBF.FieldByName('MAQUINA').AsString := TFuncao.Create.retornarPc();
  dm.HistoricoDBF.FieldByName('IP').AsString := TFuncao.Create.retornaIP();
  dm.HistoricoDBF.FieldByName('ID_USUARIO').AsInteger := 0;
  dm.HistoricoDBF.FieldByName('USUARIO').AsString := 'PROCESSO AUTOMATICO';
  dm.HistoricoDBF.FieldByName('PROCESSO').AsString := 'MSG.EXE';
  dm.HistoricoDBF.FieldByName('LOG').AsString := 'L';
  dm.HistoricoDBF.Post;

  //verifica se tem aniversariantes
  if dm.aniversario then
  begin
    if (dm.modo = 3) or (dm.modo = 1) then
    begin
      TfrmMessage.Mensagem('Ebaaaaa... '+#13+'Hoje é dia de comemorar...'+#13+
        'Veja quem faz aniversário hoje!', 'Aviso Importante', 'C', [mbOk], dm.tema);
    end;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end
  else
  begin
    if (dm.modo = 3) or (dm.modo = 2) then
    begin
      TfrmMessage.Mensagem('Sem novidades por aqui...'+#13+
        'Sem aniversáriantes para a data de hoje!', 'Aviso Importante', 'C', [mbOk], dm.tema);
    end;
    Application.Terminate;
  end;
end.
