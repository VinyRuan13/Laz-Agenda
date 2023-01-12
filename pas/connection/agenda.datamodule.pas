unit agenda.datamodule;

{$mode ObjFPC}{$H+}

interface

uses
 Classes, SysUtils, dbf, IniFiles, DB, memds, agenda.funcao, agenda.message,
 agenda.loading;

type

 { Tdm }

 Tdm = class(TDataModule)
  ContatosDBF: TDbf;
		tableUsuarioTemp: TMemDataset;
  UsuariosDBF: TDbf;
  HistoricoDBF: TDbf;
  SequenciaDBF: TDbf;
  procedure ContatosDBFAfterOpen(DataSet: TDataSet);
		procedure ContatosDBFBeforeDelete(DataSet: TDataSet);
  procedure ContatosDBFBeforePost(DataSet: TDataSet);
  procedure DataModuleCreate(Sender: TObject);
  procedure HistoricoDBFAfterOpen(DataSet: TDataSet);
		procedure HistoricoDBFBeforePost(DataSet: TDataSet);
  procedure SequenciaDBFAfterOpen(DataSet: TDataSet);
  procedure UsuariosDBFAfterOpen(DataSet: TDataSet);
		procedure UsuariosDBFAfterPost(DataSet: TDataSet);
		procedure UsuariosDBFBeforeDelete(DataSet: TDataSet);
		procedure UsuariosDBFBeforePost(DataSet: TDataSet);
 private
  SettingsIni : TIniFile;
  procedure definirLocalDBFs();
  procedure criarArquivoIni();
  procedure definirIndices();
  procedure abrirFecharTabelas(Operacao : String);
  function atualizarSequencia(Tabela : String) : Integer;
  procedure inserirUserTemp(Temp : TMemDataset ; Real : TDbf);

 public
  txtSenhaAntiga : String;
  txtSenha : String;
  userLogado : String;
  idUserLogado : Integer;
  procedure indexarTodos();
  procedure fecharIndices();
 end;

var
 dm: Tdm;
 funcao : TFuncao;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
 criarArquivoIni();
 definirLocalDBFs();
 definirIndices();

 if not Assigned(funcao) then
 begin
   funcao := TFuncao.Create;
 end;
end;

procedure Tdm.HistoricoDBFAfterOpen(DataSet: TDataSet);
begin
 //carregar índice
 HistoricoDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'HISTORICO.NTX');
end;

procedure Tdm.HistoricoDBFBeforePost(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('ID').AsInteger := atualizarSequencia('HISTORICO');
  end;
end;

procedure Tdm.SequenciaDBFAfterOpen(DataSet: TDataSet);
begin
 //carregar índice
 SequenciaDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'SEQUENCIA.NTX');
end;

procedure Tdm.UsuariosDBFAfterOpen(DataSet: TDataSet);
begin
 //carregar índice
 UsuariosDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'USUARIOS.NTX');
 inserirUserTemp(tableUsuarioTemp, UsuariosDBF);
end;

procedure Tdm.UsuariosDBFAfterPost(DataSet: TDataSet);
begin
  inserirUserTemp(tableUsuarioTemp, UsuariosDBF);
end;

procedure Tdm.UsuariosDBFBeforeDelete(DataSet: TDataSet);
var
  excluir : Boolean;
begin
  excluir := TfrmMessage.Mensagem('Deseja realmente excluir o usuário '+
  DataSet.FieldByName('NOME').AsString+' ?', 'Alerta', 'D', [mbNao, mbSim]);

  if not excluir then
  begin
    Abort;
  end;
end;

procedure Tdm.UsuariosDBFBeforePost(DataSet: TDataSet);
begin
  if tableUsuarioTemp.Locate('nomeUser', DataSet.FieldByName('NOME').AsString, [loCaseInsensitive]) then
  begin
    TfrmMessage.Mensagem('Não foi possível concluir o cadastro!'+#13+'O Usuário '+
    DataSet.FieldByName('NOME').AsString+' já existe!', 'Acesso Negado!', 'E', [mbOk]);
    Abort;
  end
  else
  begin
    if DataSet.State in [dsInsert] then
    begin
      DataSet.FieldByName('SENHA').AsString := funcao.encryptMD5(txtSenha);
      DataSet.FieldByName('DCADASTRO').AsDateTime := Now;
      DataSet.FieldByName('HCADASTRO').AsString := TimeToStr(Time);
      DataSet.FieldByName('ID').AsInteger := atualizarSequencia('USUARIOS');
    end;
    if DataSet.State in [dsEdit] then
    begin
      if  funcao.encryptMD5(txtSenhaAntiga) = DataSet.FieldByName('SENHA').AsString then
      begin
        DataSet.FieldByName('SENHA').AsString := funcao.encryptMD5(txtSenha);
        DataSet.FieldByName('DALTERACAO').AsDateTime := Now;
        DataSet.FieldByName('HALTERACAO').AsString := TimeToStr(Time);
      end
      else
      begin
        TfrmMessage.Mensagem('Senha atual inválida!', 'Acesso Negado!', 'E', [mbOk]);
        Abort;
      end;
    end;
  end;
end;

procedure Tdm.ContatosDBFAfterOpen(DataSet: TDataSet);
begin
 //carregar índice
 ContatosDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'CONTATOS.NTX');
end;

procedure Tdm.ContatosDBFBeforeDelete(DataSet: TDataSet);
var
  excluir : Boolean;
begin
  excluir := TfrmMessage.Mensagem('Deseja realmente excluir o contato '+
  DataSet.FieldByName('NOME').AsString+' ?', 'Alerta', 'D', [mbNao, mbSim]);

  if not excluir then
  begin
    Abort;
  end;
end;

procedure Tdm.ContatosDBFBeforePost(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('DCADASTRO').AsDateTime := Now;
    DataSet.FieldByName('HCADASTRO').AsString := TimeToStr(Time);
    DataSet.FieldByName('ID_USUARIO').AsInteger := idUserLogado;
    DataSet.FieldByName('USUARIO').AsString := userLogado;
    DataSet.FieldByName('ID').AsInteger := atualizarSequencia('CONTATOS');
  end;
  if DataSet.State in [dsEdit] then
  begin
    DataSet.FieldByName('DALTERACAO').AsDateTime := Now;
    DataSet.FieldByName('HALTERACAO').AsString := TimeToStr(Time);
  end;
end;

procedure Tdm.definirLocalDBFs;
begin
 ContatosDBF.FilePathFull := SettingsIni.ReadString('DBF', 'PATH', '');
 HistoricoDBF.FilePathFull := SettingsIni.ReadString('DBF', 'PATH', '');
 SequenciaDBF.FilePathFull := SettingsIni.ReadString('DBF', 'PATH', '');
 UsuariosDBF.FilePathFull := SettingsIni.ReadString('DBF', 'PATH', '');
end;

procedure Tdm.criarArquivoIni;
var
 caminhoIni : String;
begin
 caminhoIni := GetCurrentDir+'\Settings.ini';

 if not Assigned(SettingsIni) then
 begin
   SettingsIni := TIniFile.Create(caminhoIni);
 end;

 if not FileExists(caminhoIni) then
 begin
   SettingsIni.WriteString('DBF', 'PATH', GetCurrentDir+'\BANCO\');
   SettingsIni.WriteString('NTX', 'PATH', GetCurrentDir+'\BANCO\');
 end;

end;

procedure Tdm.definirIndices;
begin

  ContatosDBF.Indexes[0].IndexFile := SettingsIni.ReadString('NTX', 'PATH', '')+'CONTATOS.NTX';
  ContatosDBF.IndexName := SettingsIni.ReadString('NTX', 'PATH', '')+'CONTATOS.NTX';
  ContatosDBF.Indexes[0].SortField := 'NOME';

  HistoricoDBF.Indexes[0].IndexFile := SettingsIni.ReadString('NTX', 'PATH', '')+'HISTORICO.NTX';
  HistoricoDBF.IndexName := SettingsIni.ReadString('NTX', 'PATH', '')+'HISTORICO.NTX';
  HistoricoDBF.Indexes[0].SortField := 'ID';

  SequenciaDBF.Indexes[0].IndexFile := SettingsIni.ReadString('NTX', 'PATH', '')+'SEQUENCIA.NTX';
  SequenciaDBF.IndexName := SettingsIni.ReadString('NTX', 'PATH', '')+'SEQUENCIA.NTX';
  SequenciaDBF.Indexes[0].SortField := 'ID';

  UsuariosDBF.Indexes[0].IndexFile := SettingsIni.ReadString('NTX', 'PATH', '')+'USUARIOS.NTX';
  UsuariosDBF.IndexName := SettingsIni.ReadString('NTX', 'PATH', '')+'USUARIOS.NTX';
  UsuariosDBF.Indexes[0].SortField := 'ID';

end;

procedure Tdm.abrirFecharTabelas(Operacao: String);
begin
  if Operacao = 'ABRIR' then
  begin
    ContatosDBF.Open;
    HistoricoDBF.Open;
    UsuariosDBF.Open;
    SequenciaDBF.Open;
  end;
  if Operacao = 'FECHAR' then
  begin
    ContatosDBF.Close;
    HistoricoDBF.Close;
    UsuariosDBF.Close;
    SequenciaDBF.Close;
  end;
end;

function Tdm.atualizarSequencia(Tabela : String) : Integer;
var
  campo : String;
begin
  SequenciaDBF.Open;

  if SequenciaDBF.RecordCount = 0 then
  begin
    SequenciaDBF.Insert;
    SequenciaDBF.FieldByName('ID').AsInteger := 1;
    SequenciaDBF.FieldByName('SUSUARIO').AsInteger := 0;
    SequenciaDBF.FieldByName('SCONTATOS').AsInteger := 0;
    SequenciaDBF.FieldByName('SHISTORICO').AsInteger := 0;
    SequenciaDBF.Post;
  end;

  SequenciaDBF.Locate('ID', 1, []);

  SequenciaDBF.Edit;

  if Tabela = 'CONTATOS' then
  begin
    campo := 'SCONTATOS';
  end;
  if Tabela = 'USUARIOS' then
  begin
    campo := 'SUSUARIO';
  end;
  if Tabela = 'HISTORICO' then
  begin
    campo := 'SHISTORICO';
  end;

  SequenciaDBF.FieldByName(campo).AsInteger :=
                            SequenciaDBF.FieldByName(campo).AsInteger + 1;
  SequenciaDBF.Post;

  Result := SequenciaDBF.FieldByName(campo).AsInteger;
end;

procedure Tdm.inserirUserTemp(Temp : TMemDataset ; Real : TDbf);
begin

  Temp.Close;
  Temp.Fields.Clear;
  Temp.FieldDefs.Clear;
  Temp.Clear;

  Temp.FieldDefs.Add('nomeUser', ftString, 100);

  Temp.Open;

  Real.First;

  while not Real.EOF do
  begin
    Temp.Insert;
    Temp.FieldByName('nomeUser').AsString := Real.FieldByName('NOME').AsString;
    Temp.Post;

    Real.Next;
  end;

  Real.First;
end;

procedure Tdm.indexarTodos;
begin

  abrirFecharTabelas('FECHAR');

  if funcao.apagarIndices(dm.SettingsIni.ReadString('NTX', 'PATH', '')) then
  Begin
    try

      abrirFecharTabelas('ABRIR');

      UsuariosDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'USUARIOS.NTX');
      SequenciaDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'SEQUENCIA.NTX');
      ContatosDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'CONTATOS.NTX');
      HistoricoDBF.OpenIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'HISTORICO.NTX');

      TfrmMessage.Mensagem('A indexação foi realizada com sucesso!',
                        'Sucesso!', 'I', [mbOk]);

    except on ex:Exception do
    begin

      TfrmMessage.Mensagem('Erro ao criar os arquivos .NTX ','Erro!', 'E', [mbOk]);

    end;
    end;
		end
  else
  begin

    TfrmMessage.Mensagem('Erro ao deletar os arquivos .NTX ','Erro!', 'E', [mbOk]);

  end;

end;

procedure Tdm.fecharIndices;
begin
  UsuariosDBF.CloseIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'USUARIOS.NTX');
  SequenciaDBF.CloseIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'SEQUENCIA.NTX');
  ContatosDBF.CloseIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'CONTATOS.NTX');
  HistoricoDBF.CloseIndexFile(SettingsIni.ReadString('NTX', 'PATH', '')+'HISTORICO.NTX');
end;

end.
