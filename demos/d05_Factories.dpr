program d05_Factories;

// https://delphisorcery.blogspot.com/search?q=Dependency+Injection

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DemoWithIFactory in 'DemoWithIFactory.pas';

begin
  try
    RunDemo();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end.
