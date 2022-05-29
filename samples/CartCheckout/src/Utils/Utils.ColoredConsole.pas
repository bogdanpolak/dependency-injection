unit Utils.ColoredConsole;

interface

uses
  System.SysUtils,
  Winapi.Windows;

type
  TConsole = class
    class procedure Writeln(const text: string); static;
  end;

implementation

{ TConsole }

class procedure TConsole.Writeln(const text: string);
var
  ConOut: THandle;
  BufInfo: TConsoleScreenBufferInfo;
begin
  System.Write('--- Console Colors: ');
  ConOut := TTextRec(Output).Handle; // or GetStdHandle(STD_OUTPUT_HANDLE)
  GetConsoleScreenBufferInfo(ConOut, BufInfo);

  SetConsoleTextAttribute(TTextRec(Output).Handle, FOREGROUND_INTENSITY or
    FOREGROUND_RED);
  System.Write('RED Text !!!');
  SetConsoleTextAttribute(ConOut, BufInfo.wAttributes);

  System.Write(' - ');

  SetConsoleTextAttribute(TTextRec(Output).Handle, FOREGROUND_INTENSITY or
    FOREGROUND_GREEN);
  System.Write('Success.');
  SetConsoleTextAttribute(ConOut, BufInfo.wAttributes);

  System.Write(' - ');

  SetConsoleTextAttribute(TTextRec(Output).Handle, FOREGROUND_INTENSITY or
    FOREGROUND_BLUE);
  System.Write('Neutral inforamtion');
  SetConsoleTextAttribute(ConOut, BufInfo.wAttributes);

  System.Writeln(' Normal back');
end;

end.
