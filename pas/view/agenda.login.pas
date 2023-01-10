unit agenda.login;

{$mode ObjFPC}{$H+}

interface

uses
 Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
 Buttons, ActnList, agenda.funcao, LCLType;

type

 { TfrmLogin }

 TfrmLogin = class(TForm)
			dtsHistorico: TDataSource;
			dtsLogin: TDataSource;
   imgAgenda: TImage;
   lblEdtUsuario: TLabeledEdit;
   lblEdtSenha: TLabeledEdit;
   pnlCabecalho: TPanel;
   plnRodape: TPanel;
   pnlPrincipal: TPanel;
   pnlLogin: TPanel;
   sbtnSair: TSpeedButton;
   sbtnEntrar: TSpeedButton;
			procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
   procedure FormCreate(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure sbtnEntrarClick(Sender: TObject);
   procedure sbtnSairClick(Sender: TObject);
 private
   procedure gravarLog(id : Integer; user : String);
 public
   idUsuario : Integer;
   nomeUsuario : String;
 end;

var
 frmLogin: TfrmLogin;
 funcao : TFuncao;

implementation

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.sbtnSairClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmLogin.gravarLog(id : Integer; user : String);
begin
  dtsHistorico.DataSet.Insert;
  dtsHistorico.DataSet.FieldByName('DATA').AsDateTime := Now;
  dtsHistorico.DataSet.FieldByName('HORA').AsString := TimeToStr(Time);
  dtsHistorico.DataSet.FieldByName('MAQUINA').AsString := funcao.retornarPc();
  dtsHistorico.DataSet.FieldByName('IP').AsString := funcao.retornaIP();
  dtsHistorico.DataSet.FieldByName('ID_USUARIO').AsInteger := id;
  dtsHistorico.DataSet.FieldByName('USUARIO').AsString := user;
  dtsHistorico.DataSet.Post;
end;

procedure TfrmLogin.sbtnEntrarClick(Sender: TObject);
var
 senha : String;
 usuarioOk, senhaOk : Boolean;
begin

 nomeUsuario := lblEdtUsuario.Text;
 senha := funcao.encryptMD5(lblEdtSenha.Text);

 usuarioOk := dtsLogin.DataSet.Locate('NOME', nomeUsuario, [loCaseInsensitive]);
 senhaOk := dtsLogin.DataSet.FieldByName('SENHA').AsString = senha;
 idUsuario := dtsLogin.DataSet.FieldByName('ID').AsInteger;

 if (usuarioOk) and (senhaOk) then
 begin
   gravarLog(idUsuario, nomeUsuario);
   ModalResult := mrOK;
 end
 else
 Begin
   Application.MessageBox('O usuário/senha informado(a) não existe!',
                 'Acesso Negado!', MB_ICONERROR + MB_OK);
 end;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  dtsLogin.DataSet.Open;
  dtsHistorico.DataSet.Open;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  if not Assigned(funcao) then
  begin
    funcao := TFuncao.Create;
  end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dtsHistorico.DataSet.Close;
  dtsLogin.DataSet.Close;
  FreeAndNil(funcao);
end;

end.
