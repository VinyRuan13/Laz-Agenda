program Service;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, service.datamodule, indylaz, IdSMTP, IdMessage,
  IdSSLOpenSSL, IdSocksServer, IdSMTPServer, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Interfaces
  { you can add units after this };

type

  { TServiceAgenda }

  TServiceAgenda = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    function verificarAniversarios() : Boolean;
    function enviaEmail() : Boolean;
  end;

{ TServiceAgenda }

procedure TServiceAgenda.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }

  //parada
  verificarAniversarios();
  ReadLn;
  enviaEmail();

  // stop program loop
  Terminate;
end;

constructor TServiceAgenda.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TServiceAgenda.Destroy;
begin
  inherited Destroy;
end;

procedure TServiceAgenda.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

function TServiceAgenda.verificarAniversarios: Boolean;
begin
  WriteLn('Dia: '+ FormatDateTime('dd', Now));
  Result := True;
end;

function TServiceAgenda.enviaEmail: Boolean;
var
  Mail : TIdSMTP;
  mailMessage: TIdMessage;
  mailSSL: TIdSSLIOHandlerSocketOpenSSL;
begin

 mail:=TidSMTP.Create(nil);
 mailMessage:=TIdMessage.Create(nil);
 mailSSL:=TIdSSLIOHandlerSocketOpenSSL.Create(nil);

 // Prepara a ligação ao servidor
 mail.Host := 'smpt.gmail.com';
 mail.Port := 465;

 if 'aaaa' = '' then
    mail.AuthType:=satNone
 else
 begin
      mail.AuthType := satDefault;
      mail.Username := 'teste00.adr5@gmail.com';
      mail.Password := 'test_2019_test';
 end;

 //se tem ssl
 if True then
 begin
      mailSSL.Destination := mail.Host+':'+IntToStr(mail.Port);
      mailSSL.Host := mail.Host;
      mailSSL.Port := mail.Port;
      mail.IOHandler := mailSSL;
 end
 else
     mail.IoHandler := nil;

 try
 // E-mail do remetente
    mailMessage.MessageParts.Clear;
    mailMessage.From.Name := 'Teste00 Android';
    mailMessage.From.Address:='teste00.adr5@gmail.com';

    // Destinatários
    if pos(';','teste01.adr5@gmail.com') = 0 then
       mailMessage.Recipients.EMailAddresses := '';
    //else
    //begin
         //mailMessage.Recipients.EMailAddresses:=Copy(Targets,1,pos(';',Targets)-1);
	 //Delete(Targets,1,pos(';',Targets));
	 //mailMessage.ccList.EMailAddresses:=Targets;
    //end;

    // Assunto
    mailMessage.Subject := 'teste00000';

    // Body
    with mailMessage.Body do
    begin
         Clear;
	 Add('Mensagem automatica do sistema...');
    end;

    // Anexos
    //if Attachment<>''
    //   then TIdAttachmentFile.Create(MailMessage.MessageParts, Attachment);

    try
    // Liga ao servidor
       if mail.Port = 465 then
          mail.UseEhlo := False
       else
           mail.UseEhlo := True;
           //mail.UseTLS := utUseExplicitTLS;

       mail.Connect();

       // Envia a mensagem
       if mail.Connected then
          mail.Send(mailMessage);
    except on E:Exception do
           Result:=False;
    end;
 finally
        if mail.Connected then
           mail.Disconnect;
 end;

 mailSSL.Free;
 mailMessage.Free;
 mail.Free;

 Result := True;

end;

var
  Application: TServiceAgenda;

{$R *.res}

begin
  Application:=TServiceAgenda.Create(nil);
  Application.Title:='ServiceAgenda';
  Application.Run;
  Application.Free;
end.

