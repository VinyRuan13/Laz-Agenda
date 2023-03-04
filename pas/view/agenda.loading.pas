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
  private

  public

  end;

var
  frmLoading: TfrmLoading;

implementation

{$R *.lfm}

end.
