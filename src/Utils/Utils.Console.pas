unit Utils.Console;

interface

uses
  System.SysUtils,
  {}
  Utils.Interfaces;

type
  TCommandlineConsole = class(TInterfacedObject, IConosole)
    procedure WriteLine(const line: string); overload;
    procedure WriteLine(const line: string;
      const params: array of const); overload;
  end;

implementation

{ TCommandlineConsole }

procedure TCommandlineConsole.WriteLine(const line: string);
begin
  System.Writeln(line);
end;

procedure TCommandlineConsole.WriteLine(const line: string;
  const params: array of const);
begin
  System.Writeln(Format(line, params));
end;

end.
