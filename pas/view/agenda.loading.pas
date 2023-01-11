unit agenda.loading;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

		{ TfrmLoading }

  TfrmLoading = class(TForm)
				imgCarregando: TImage;
				lblCarregando: TLabel;
				pnlPrincipal: TPanel;
				procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmLoading: TfrmLoading;

implementation

{$R *.lfm}

{ TfrmLoading }

procedure TfrmLoading.FormShow(Sender: TObject);
begin
  Brush.Style := BsClear;
end;

end.
