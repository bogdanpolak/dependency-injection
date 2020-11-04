program GlobalContainerDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container,
  Business.Classes in 'Business.Classes.pas',
  Business.Interfaces in 'Business.Interfaces.pas',
  Utils.DeveloperMode in 'Utils\Utils.DeveloperMode.pas',
  Business.Composer in 'Business.Composer.pas';

var
  App: IApplicationRoot;
begin
  randomize;
  try
    BuildContainer(GlobalContainer);
    App := GlobalContainer.Resolve<IApplicationRoot>;
    System.Writeln(App.ToString());
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
