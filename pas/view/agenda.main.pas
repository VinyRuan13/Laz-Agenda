unit agenda.main;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, ActnList,
	Buttons, ComCtrls, DBGrids, DBCtrls, StdCtrls, DBDateTimePicker,
	agenda.funcao, agenda.datamodule, agenda.message, LCLType, rxdbcomb,
        agenda.loading;

type

 { TfrmMain }

 TfrmMain = class(TForm)
  actContatos: TAction;
  actHistoricoLogin: TAction;
  actConfiguracoes: TAction;
  actIndexar: TAction;
  actCancelarConfig: TAction;
  actSalvarConfig: TAction;
  actSairMenu: TAction;
  actUsuarios: TAction;
  actSair: TAction;
  actList: TActionList;
  dbeRemetente1: TDBEdit;
  dbeRemetente2: TDBEdit;
  dbeRemetente3: TDBEdit;
  dbeRemetente4: TDBEdit;
  dbmMsg: TDBMemo;
  dbrgTema: TDBRadioGroup;
  dtsCGeral: TDataSource;
  dtsEnvio: TDataSource;
  dbeRemetente: TDBEdit;
  dbeSmtp: TDBEdit;
  dbeSenhaEmail: TDBEdit;
  dbePorta: TDBEdit;
  dbtData: TDBText;
  dbtHora: TDBText;
  gbPadroes: TGroupBox;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  pnlRodapeConfig: TPanel;
  dbrgTLS: TDBRadioGroup;
  dbrgSSL: TDBRadioGroup;
  gbEmail: TGroupBox;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  dbrgModo: TDBRadioGroup;
  dtsSequencia: TDataSource;
  dtsUsuarios: TDataSource;
  dbeNomeUsuarios: TDBEdit;
  dbgUsuarios: TDBGrid;
  dbnavUsuarios: TDBNavigator;
  dbtDaUsuarios: TDBText;
  dbtDcUsuarios: TDBText;
  dbtHaUsusarios: TDBText;
  dbtHcUsuarios: TDBText;
  dtsHistorico: TDataSource;
  dbgHistorico: TDBGrid;
  dbnavContatos: TDBNavigator;
  dbtDcContatos: TDBText;
  dbtDaContatos: TDBText;
  dbtHcContatos: TDBText;
  dbtHaContatos: TDBText;
  dtsContatos: TDataSource;
  dtpData: TDBDateTimePicker;
  dbeNome: TDBEdit;
  dbeEmail: TDBEdit;
  dbeTelefone: TDBEdit;
  dbgContatos: TDBGrid;
  edtBuscaUsuarios: TEdit;
  edtBuscaContatos: TEdit;
  edtSenhaUsuario: TEdit;
  edtSenhaAntigaUsuario: TEdit;
  imgUserLogado: TImage;
  imgPrincipal: TImage;
  imgList: TImageList;
  lblas2Usuarios: TLabel;
  lblasContatos: TLabel;
  lblas2Contatos: TLabel;
  lblasUsuarios: TLabel;
  lblCadastroContatos: TLabel;
  lblCadastroContatos1: TLabel;
  lblCadastroUsuarios: TLabel;
  lblCadastroUsuarios2: TLabel;
  lblSenhaUsuarios: TLabel;
  lblNome: TLabel;
  lblEmail: TLabel;
  lblNome1: TLabel;
  lblTelefone: TLabel;
  lblData: TLabel;
  lblSenhaAntigaUsuarios: TLabel;
  pageControl: TPageControl;
  pnlBuscaUsuarios: TPanel;
  pnlBuscaContatos: TPanel;
  pnlTituloConfig: TPanel;
  pnlUsuarioLogado: TPanel;
  pnlAttContatos: TPanel;
  pnlAttUsuarios: TPanel;
  pnlCadastroContatos: TPanel;
  pnlCadastroUsuarios: TPanel;
  pnlTituloContatos: TPanel;
  pnlTelas: TPanel;
  pnlMenu: TPanel;
  pnlDh: TPanel;
  pnlTitulo: TPanel;
  pnlPrincipal: TPanel;
  pnlTituloHistorico: TPanel;
  pnlTituloUsuario: TPanel;
  sbtnIndexar: TSpeedButton;
  sbtnContatos: TSpeedButton;
  sbtnHistorico: TSpeedButton;
  sbtnConfig: TSpeedButton;
  sbtnSair: TSpeedButton;
  sbtnSairHistorico: TSpeedButton;
  sbtnSairUsuarios: TSpeedButton;
  sbtnSairConfig: TSpeedButton;
  sbtnUsuarios: TSpeedButton;
  sbtnSairContatos: TSpeedButton;
  sbtnSalvarConfig: TSpeedButton;
  sbtnCancelarConfig: TSpeedButton;
  tbsConfiguracao: TTabSheet;
  tbsUsuarios: TTabSheet;
  tbsMain: TTabSheet;
  tbsContatos: TTabSheet;
  tbsHistoricoLogin: TTabSheet;
  timer: TTimer;
  procedure actCancelarConfigExecute(Sender: TObject);
  procedure actConfiguracoesExecute(Sender: TObject);
  procedure actContatosExecute(Sender: TObject);
  procedure actHistoricoLoginExecute(Sender: TObject);
  procedure actIndexarExecute(Sender: TObject);
  procedure actPesquisarContatosExecute(Sender: TObject);
  procedure actPesquisarUsuariosExecute(Sender: TObject);
  procedure actSairExecute(Sender: TObject);
  procedure actSairMenuExecute(Sender: TObject);
  procedure actSalvarConfigExecute(Sender: TObject);
  procedure actUsuariosExecute(Sender: TObject);
  procedure dtsContatosDataChange(Sender: TObject; Field: TField);
  procedure dtsUsuariosStateChange(Sender: TObject);
  procedure edtBuscaUsuariosChange(Sender: TObject);
  procedure edtSenhaAntigaUsuarioChange(Sender: TObject);
  procedure edtSenhaUsuarioChange(Sender: TObject);
  procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure timerTimer(Sender: TObject);
 private
  procedure travarDataHoraAtt(dts : TDataSet; da, ha : TDBText; compl : TLabel);
 public
  idUsuarioLogado : Integer;
  nomeUsuarioLogado : String;
 end;

var
 frmMain: TfrmMain;
 funcao : TFuncao;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.timerTimer(Sender: TObject);
begin
  pnlDh.Caption := DateToStr(Date)+'  '+TimeToStr(Time);
end;

procedure TfrmMain.travarDataHoraAtt(dts : TDataSet; da , ha : TDBText; compl : TLabel);
begin
  if (dts.FieldByName('DALTERACAO').AsString.IsEmpty) or
     (dts.FieldByName('HALTERACAO').AsString.IsEmpty) then
  begin
    da.Visible := False;
    ha.Visible := False;
    compl.Visible := False;
  end
  else
  begin
    da.Visible := True;
    ha.Visible := True;
    compl.Visible := True;
		end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
 i:Integer;
begin
  //seta a hora e data para o panel
  pnlDh.Caption := DateToStr(Date)+'  '+TimeToStr(Time);

  //oculta as tabs
  for i := 0 to pageControl.PageCount-1 do
  begin
    pageControl.Pages[i].TabVisible := False;
  end;
  pageControl.ActivePage := tbsMain;

  if not Assigned(funcao) then
  begin
    funcao := TFuncao.Create;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  pnlUsuarioLogado.Caption := nomeUsuarioLogado;
  dm.userLogado := nomeUsuarioLogado;
  dm.idUserLogado := idUsuarioLogado;

  //abrirTabelas
  dtsContatos.DataSet.Open;
  dtsHistorico.DataSet.Open;
  dtsUsuarios.DataSet.Open;
  dtsSequencia.DataSet.Open;
  dtsCGeral.DataSet.Open;
  dtsEnvio.DataSet.Open;
end;

procedure TfrmMain.actSairExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actSairMenuExecute(Sender: TObject);
begin
  pageControl.ActivePage := tbsMain;
end;

procedure TfrmMain.actSalvarConfigExecute(Sender: TObject);
begin
  dtsEnvio.DataSet.Post;
  dtsCGeral.DataSet.Post;
  pageControl.ActivePage := tbsMain;
end;

procedure TfrmMain.actUsuariosExecute(Sender: TObject);
begin
  pageControl.ActivePage := tbsUsuarios;
end;

procedure TfrmMain.dtsContatosDataChange(Sender: TObject; Field: TField);
begin
  travarDataHoraAtt(dtsContatos.DataSet, dbtDaContatos, dbtHaContatos, lblas2Contatos);
end;

procedure TfrmMain.dtsUsuariosStateChange(Sender: TObject);
begin
  if dtsUsuarios.DataSet.State = dsInsert then
  begin
    lblSenhaUsuarios.Caption := 'Senha: ';
    lblSenhaAntigaUsuarios.Visible := False;
    edtSenhaAntigaUsuario.Visible := False;
  end;
  if dtsUsuarios.DataSet.State = dsEdit then
  begin
    lblSenhaUsuarios.Caption := 'Nova Senha: ';
    lblSenhaAntigaUsuarios.Visible := True;
    edtSenhaAntigaUsuario.Visible := True;
  end;
  if dtsUsuarios.DataSet.State = dsBrowse then
  begin
    lblSenhaAntigaUsuarios.Visible := False;
    edtSenhaAntigaUsuario.Visible := False;
  end;
end;

procedure TfrmMain.edtBuscaUsuariosChange(Sender: TObject);
var
 i : Integer;
begin
  if TryStrToInt(edtBuscaUsuarios.Text, i) then
  begin
    dtsUsuarios.DataSet.Locate('ID', i, []);
  end
  else
  begin
    dtsUsuarios.DataSet.Locate('NOME', edtBuscaUsuarios.Text, [loCaseInsensitive, loPartialKey]);
		end;
end;

procedure TfrmMain.edtSenhaAntigaUsuarioChange(Sender: TObject);
begin
  dm.txtSenhaAntiga := edtSenhaAntigaUsuario.Text;
end;

procedure TfrmMain.edtSenhaUsuarioChange(Sender: TObject);
begin
  dm.txtSenha := edtSenhaUsuario.Text;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
 Sair : Boolean;
begin

  Sair := TfrmMessage.Mensagem('Deseja realmente sair do sistema ?',
                               'Mensagem', 'Q', [mbNao, mbSim]);

  if not Sair then
  begin
    Abort;
  end;
end;

procedure TfrmMain.actContatosExecute(Sender: TObject);
begin
  pageControl.ActivePage := tbsContatos;
end;

procedure TfrmMain.actConfiguracoesExecute(Sender: TObject);
begin
  pageControl.ActivePage := tbsConfiguracao;
  dtsEnvio.DataSet.Edit;
  dtsCGeral.DataSet.Edit;
  dbeRemetente.SetFocus;
end;

procedure TfrmMain.actCancelarConfigExecute(Sender: TObject);
begin
  dtsEnvio.DataSet.Cancel;
  dtsCGeral.DataSet.Cancel;
  pageControl.ActivePage := tbsMain;
end;

procedure TfrmMain.actHistoricoLoginExecute(Sender: TObject);
begin
  pageControl.ActivePage := tbsHistoricoLogin;
end;

procedure TfrmMain.actIndexarExecute(Sender: TObject);
var
 indexar : Boolean;
begin
  TfrmMessage.Mensagem('Antes de prosseguir com a operação, certifique que o ' +
                        'sistema esteja fechado em todos os usuários/processos!',
                        'Alerta!', 'C', [mbOk]);
  indexar := TfrmMessage.Mensagem('Deseja realmente indexar os arquivos ?',
                        'Alerta!', 'Q', [mbNao, mbSim]);

  if indexar then
  begin
    dm.indexarTodos();
  end;
end;

procedure TfrmMain.actPesquisarContatosExecute(Sender: TObject);
var
 i:Integer;
begin
  if TryStrToInt(edtBuscaContatos.Text, i) then
  begin
    dtsContatos.DataSet.Locate('ID', i, []);
  end
  else
  begin
    dtsContatos.DataSet.Locate('NOME', edtBuscaContatos.Text, [loCaseInsensitive, loPartialKey]);
		end;
end;

procedure TfrmMain.actPesquisarUsuariosExecute(Sender: TObject);
var
 i:Integer;
begin
  if TryStrToInt(edtBuscaUsuarios.Text, i) then
  begin
    dtsUsuarios.DataSet.Locate('ID', i, []);
  end
  else
  begin
    dtsUsuarios.DataSet.Locate('NOME', edtBuscaUsuarios.Text, [loCaseInsensitive, loPartialKey]);
		end;
end;

end.

