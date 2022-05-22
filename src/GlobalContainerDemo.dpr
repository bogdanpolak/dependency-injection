program GlobalContainerDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Utils.DeveloperMode in 'Utils\Utils.DeveloperMode.pas',
  ApplicationRoot in 'Demo01\ApplicationRoot.pas',
  Business.Classes in 'Demo01\Business.Classes.pas',
  Business.Interfaces in 'Demo01\Business.Interfaces.pas',
  Demo01.Run in 'Demo01\Demo01.Run.pas';

begin
  randomize;
  try

    TDemo01.Run();

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  if IsDeveloperMode() then
  begin
    System.Write('... press Enter to close ...');
    System.Readln;
  end;

end.
