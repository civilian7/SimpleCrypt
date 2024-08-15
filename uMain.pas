unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TSimpleCrypt = class
  strict private
    const
      CODE64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
  public
    class function Decrypt(const AValue: string): string; static;
    class function Encrypt(const AValue: string): string; static;
  end;

type
  TForm6 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

{ TSimpleCrypt }

class function TSimpleCrypt.Decrypt(const AValue: string): string;
var
  i, a, X, b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(AValue) do
  begin
    X := Pos(AValue[i], CODE64) - 1;
    if X >= 0 then
    begin
      b := b * 64 + X;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        X := b shr a;
        b := b mod (1 shl a);
        X := X mod 256;
        Result := Result + chr(X);
      end;
    end
    else
      Exit;
  end;
end;

class function TSimpleCrypt.Encrypt(const AValue: string): string;
var
  i, a, X, b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(AValue) do
  begin
    X := Ord(AValue[i]);
    b := b * 256 + X;
    a := a + 8;
    while a >= 6 do
    begin
      a := a - 6;
      X := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + CODE64[X + 1];
    end;
  end;

  if a > 0 then
  begin
    X := b shl (6 - a);
    Result := Result + CODE64[X + 1];
  end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  var L1 := TSimpleCrypt.Encrypt('192.168.0.100@user:password');
  Memo1.Text := TSimpleCrypt.Decrypt(L1)

end;

end.
