unit App.Composer;

interface

uses
  System.Classes,
  Spring.Container,
  {-}
  App.Root;

type
  TApplicationComposer = class(TComponent)
  public
    class function BuildRoot: IApplicationRoot; static;
  end;

implementation

uses
  App.RootC,
  App.Parameters,
  App.ParametersC,
  Services.DataConnection,
  Services.DataConnectionC,
  Utils.Logger,
  Utils.ConsoleLogger,
  Utils.CmdParameters,
  Utils.CmdParametersC,
  Commands.Main,
  Commands.MainC;

class function TApplicationComposer.BuildRoot: IApplicationRoot;
var
  Container: Spring.Container.TContainer;
begin
  Container := TContainer.Create;
  try
    Container.RegisterType<IApplicationRoot, TApplicationRoot>;
    Container.RegisterType<ILogger, TBasicLogger>;
    Container.RegisterType<ICmdParameters, TCmdParameters>;
    Container.RegisterType<IAppParameters, TAppParameters>;
    Container.RegisterType<IMainCommand, TMainCommand>;
    Container.RegisterType<IDataConnection, TDataConnection>;
    Container.Build;
    Result := Container.Resolve<IApplicationRoot>;
  finally
    Container.Free;
  end;
end;

end.
