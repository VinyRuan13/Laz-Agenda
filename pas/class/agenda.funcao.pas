unit agenda.funcao;

interface

uses
  Windows, SysUtils, WinSock, System.NetEncoding, Classes, md5;

type

		{ TFuncao }

  TFuncao = class
  private
    dev : string;
  public
    dataVersao : String;
    versao : string;

    procedure setarInfoVersao();
    function retornarInfoRodape() : String;
    function encryptSTR(const InString: string; StartKey, MultKey,
                        AddKey: Integer): string;
    function decryptSTR(const InString: string; StartKey, MultKey,
                        AddKey: Integer): string;
    function retornaIP() : String;
    function retornarPc() : String;
    function ConvertFileToBase64(AInFileName : String) : String;
    procedure ConvertBase64ToFile(Base64, FileName: string);
    function encryptMD5(const texto:string):string;
    function apagarIndices(caminho : String) : Boolean;

  end;

implementation

procedure TFuncao.setarInfoVersao();
begin
  //''versão compilada!''.
  dataVersao := '06/03/2023 ';
  versao := '23.05.01 '; //ano.qtdversaoTotal.versaoDia
  dev := 'Vinícius Ruan Brandalize';
end;

function TFuncao.retornarInfoRodape() : String;
var
  textoCompleto, textoVersao : String;
begin

  setarInfoVersao();

  textoVersao := '  Versão:  '+versao+'  Data Da Versão:  '+dataVersao+
            '  Desenvolvido por '+dev+'  ';

  textoCompleto := '';
  result := textoCompleto;
end;

function TFuncao.encryptSTR(const InString: string; StartKey, MultKey,
  AddKey: Integer): string;
var I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;

function TFuncao.decryptSTR(const InString: string; StartKey, MultKey,
  AddKey: Integer): string;
var I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;

function TFuncao.retornaIP: String;
var
  wsaData : TWSAData;
begin
  WSAStartup(257, wsaData);
  Result := Trim(inet_ntoa(PInAddr(GetHostByName(nil)^.h_addr_list^)^));
end;

function TFuncao.retornarPc: String;
var
  lpBuffer : PChar;
  nSize : DWord;
const Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
  begin
  try
    nSize := Buff_Size;
    lpBuffer := StrAlloc(Buff_Size);
    GetComputerName(lpBuffer,nSize);
    Result := String(lpBuffer);
    StrDispose(lpBuffer);
  except
    Result := '';
  end;
end;

procedure TFuncao.ConvertBase64ToFile(Base64, FileName: string);
var
  inStream    : TStream;
  outStream   : TStream;
  vFile       : String;
  vStringList : TStringList;
begin
  vStringList := TStringList.Create;
  try
    vFile    := FormatDateTime('hhmmss',Now);
    vStringList.Add(Base64);
    vStringList.SaveToFile(vFile);
    inStream := TFileStream.Create(vFile, fmOpenRead);
    try
      outStream := TFileStream.Create(FileName, fmCreate);
      try
        TNetEncoding.Base64.Decode(inStream, outStream);
      finally
        outStream.Free;
      end;
    finally
      inStream.Free;
    end;
  finally
    DeleteFile(PChar(vFile));
    FreeAndNil(vStringList);
  end;
end;

function TFuncao.ConvertFileToBase64(AInFileName: String): String;
var
  inStream    : TStream;
  outStream   : TStream;
  vFile       : String;
  vStringList : TStringList;
begin
  inStream    := TFileStream.Create(AInFileName, fmOpenRead);
  vStringList := TStringList.Create;
  try
    vFile := FormatDateTime('hhmmss',Now);
    outStream := TFileStream.Create(vFile, fmCreate);
    try
      TNetEncoding.Base64.Encode(inStream, outStream);
    finally
      outStream.Free;
    end;

    vStringList.LoadFromFile(vFile);

    Result := vStringList.Text;
  finally
    DeleteFile(Pchar(vFile));
    inStream.Free;
  end;
end;

function TFuncao.encryptMD5(const texto:string):string;
begin
  result := MD5Print(MD5String(texto));
end;

function TFuncao.apagarIndices(caminho : String): Boolean;
var
  SearchRec : TSearchRec;
  semErros : Boolean;
  apagado: Boolean;
begin

  semErros := False;
  apagado := False;

  try

    FindFirst(caminho+'*.NTX', faAnyFile, SearchRec);

    repeat

    if DeleteFile(caminho+SearchRec.Name) then
    begin
      apagado := True;
    end
    else
    begin
      apagado := False;
      Break;
    end;
    until FindNext(SearchRec) <> 0;

    semErros := True;

  finally
    FindClose(SearchRec);
  end;
  Result := semErros and apagado;
end;

end.
