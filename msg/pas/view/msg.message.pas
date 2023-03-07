unit msg.message;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
		Buttons;

type
  TMyButtons = (mbSim, mbNao, mbOk);

type

		{ TfrmMessage }

  TfrmMessage = class(TForm)
				btnSim: TBitBtn;
				btnNao: TBitBtn;
				btnOk: TBitBtn;
				ImgList: TImageList;
				imgDeletar: TImage;
				imgQuestao: TImage;
				imgCuidado: TImage;
				imgInformacao: TImage;
				imgErro: TImage;
				lblMensagem: TLabel;
				pnlIcones: TPanel;
				pnlMensagem: TPanel;
				pnlBotoes: TPanel;
  private

  public
    class function Mensagem(Texto, Titulo: String; Tipo: Char; Botoes: array of TMyButtons; Estilo: Integer): Boolean;
  end;

var
  frmMessage: TfrmMessage;

const
   LEFTBUTTONS : array[0..2] of integer = (258, 178, 97);

implementation

{$R *.lfm}

{ TfrmMessage }

class function TfrmMessage.Mensagem(Texto, Titulo: String; Tipo: Char;
		Botoes: array of TMyButtons; Estilo: Integer): Boolean;
var
  i : Integer;
  frm : TfrmMessage;
begin

  frm := TfrmMessage.Create(nil);

  if (Estilo = 1) and (Estilo = 2) then
  begin
    frm.Color := clWhite;
  end;
  if Estilo = 3 then
  begin
    frm.Color := $004F4F2F;
    frm.lblMensagem.Color := $004F4F2F;
    frm.lblMensagem.Font.Color := clWhite;
    frm.pnlBotoes.BevelOuter := bvNone;
  end;
  if Estilo = 4 then
  begin
    frm.Color := $0098FB98;
    frm.lblMensagem.Color := $0098FB98;
    frm.lblMensagem.Font.Color := clBlack;
    frm.pnlBotoes.BevelOuter := bvNone;
  end;
  if Estilo = 5 then
  begin
    frm.Color := $00E6D8AD;
    frm.lblMensagem.Color := $00E6D8AD;
    frm.lblMensagem.Font.Color := clBlue;
    frm.pnlBotoes.BevelOuter := bvNone;
  end;
  if Estilo = 6 then
  begin
    frm.Color := $00D5D7FF;
    frm.lblMensagem.Color := $00D5D7FF;
    frm.lblMensagem.Font.Color := clRed;
    frm.pnlBotoes.BevelOuter := bvNone;
  end;

  try
    frm.lblMensagem.Caption := Texto;
    frm.Caption := Titulo;

    for i:=0 to Length(Botoes)-1 do
    begin
      case (Botoes[i]) of
        mbOk: begin
                frm.BtnOK.Visible := True;
                frm.BtnOK.Left := LEFTBUTTONS[i];
              end;

        mbSim: begin
                 frm.btnSim.Visible := True;
                 frm.btnSim.Left := LEFTBUTTONS[i];
               end;

        mbNao: begin
                 frm.BtnNao.Visible := True;
                 frm.BtnNao.Left := LEFTBUTTONS[i];
               end;

        else
        begin
          frm.BtnOK.Visible := True;
          frm.BtnOK.Left := LEFTBUTTONS[i];
        end;
      end;
    end;

     case (Tipo) of
      'I': frm.imgInformacao.Visible := True;
      'D': frm.imgDeletar.Visible := True;
      'Q': frm.imgQuestao.Visible := True;
      'C': frm.imgCuidado.Visible := True;
      'E': frm.imgErro.Visible := True;
      else
        frm.imgInformacao.Visible := True;
    end;

    frm.ShowModal;

    case (frm.ModalResult) of
      mrOk, mrYes : result := True;
    else
      result := False;
    end;

  finally
    if (frm <> nil) then
      FreeAndNil(frm);
    end;
  end;
end.

end.
