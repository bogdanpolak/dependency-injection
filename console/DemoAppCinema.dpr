program DemoAppCinema;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring,
  Spring.Container,
  App.Root in 'Application\App.Root.pas',
  App.RootC in 'Application\App.RootC.pas',
  Commands.Main in 'Commands\Commands.Main.pas',
  Commands.MainC in 'Commands\Commands.MainC.pas',
  App.Composer in 'Application\App.Composer.pas',
  Utils.Logger in 'Utils\Utils.Logger.pas',
  Utils.ConsoleLogger in 'Utils\Utils.ConsoleLogger.pas',
  Services.DataConnection in 'Services\Services.DataConnection.pas',
  Model.Cinema in 'Model\Model.Cinema.pas',
  Services.DataConnectionC in 'Services\Services.DataConnectionC.pas',
  Utils.CmdParameters in 'Utils\Utils.CmdParameters.pas',
  Utils.CmdParametersC in 'Utils\Utils.CmdParametersC.pas',
  App.Parameters in 'Application\App.Parameters.pas',
  App.ParametersC in 'Application\App.ParametersC.pas',
  Utils.DateTime in 'Utils\Utils.DateTime.pas';

begin
  try
    TApplicationComposer.BuildRoot().Execute;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
