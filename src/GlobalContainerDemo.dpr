program GlobalContainerDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container,
  App.Main in 'App.Main.pas',
  Business.Classes in 'Business.Classes.pas',
  Business.Interfaces in 'Business.Interfaces.pas',
  Utils.Console in 'Utils\Utils.Console.pas',
  Utils.Interfaces in 'Utils\Utils.Interfaces.pas',
  Utils.DeveloperMode in 'Utils.DeveloperMode.pas';

procedure BuildContainer;
begin
  randomize;
  GlobalContainer.RegisterType<IOrderRepository, TOrderRepository>();
  GlobalContainer.RegisterType<ISubModule, TSubModule>();
  GlobalContainer.RegisterType<IDataModule, TDataModule>();
  GlobalContainer.RegisterType<IApplicationRoot, TApplicationRoot>();
  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()
  GlobalContainer.Build;
end;

begin
  try
    BuildContainer;
    RunAll(TCommandlineConsole.Create);
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
