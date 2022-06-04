program d01_ConsoleService;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  Spring.Container,
  Spring.Services;

type
  IConsole = interface(IInterface)
    ['{A41DBC10-DF86-4414-867B-A5AC905C8BC8}']
    procedure Log(const aMsg: String);
  end;

  ISomeService = interface(IInterface)
    ['{A41DBC10-DF86-4414-867B-A5AC905C8BC8}']
    procedure Execute();
  end;

  TStandardConsole = class(TInterfacedObject, IConsole)
    procedure Log(const aMsg: String);
  end;

  TSomeService = class(TInterfacedObject, ISomeService)
  private
    fConsole: IConsole;
    fConfiguration: TStringList;
  public
    constructor Create(
      const aConsole: IConsole;
      const aConfiguration: TStringList);
    procedure Execute();
  end;

  TApplication = class
  private
    fConsole: IConsole;
    fSomeService: ISomeService;
  public
    constructor Create(
      const aConsole: IConsole;
      const aSomeService: ISomeService);
    procedure Run();
  end;

procedure TStandardConsole.Log(const aMsg: String);
begin
  Writeln(aMsg);
end;

{ TSomeService }

constructor TSomeService.Create(
  const aConsole: IConsole;
  const aConfiguration: TStringList);
begin
  fConsole := aConsole;
  fConfiguration := aConfiguration;
end;

procedure TSomeService.Execute;
begin
  fConsole.Log('Theme:' + fConfiguration.Values['Theme']);
end;

{ TApplication }

constructor TApplication.Create(
  const aConsole: IConsole;
  const aSomeService: ISomeService);
begin
  fConsole := aConsole;
  fSomeService := aSomeService;
end;

procedure TApplication.Run;
begin
  Writeln(IfThen(fConsole is TStandardConsole,
    'Console service implementation: TStandardConsole'));
  fConsole.Log('Hello Dependency Injection!');
  fSomeService.Execute;
end;

{ Console Application }

procedure RunDemo(const aConfiguration: TStringList);
var
  app: TApplication;
  locator: IServiceLocator;
begin
  GlobalContainer.RegisterType<IConsole, TStandardConsole>();
  GlobalContainer.RegisterType<ISomeService, TSomeService>().DelegateTo(
    function(): TSomeService
    begin
      Result := TSomeService.Create(ServiceLocator.GetService<IConsole>(),
        aConfiguration);
    end);
  GlobalContainer.RegisterType<TApplication>().AsSingleton();
  GlobalContainer.Build;
  app := GlobalContainer.Resolve<TApplication>;
  // Service locator is a bad pattern
  // app := ServiceLocator.GetService<TApplication>;
  // app := (ServiceLocator as IServiceLocator).GetService(TypeInfo(TApplication)).AsType<TApplication>();
  app.Run;
  // No neeed to free the instance, because it was registred as AsSingleton
  // app.Free;
end;

var
  Configuration: TStringList;

begin
  try
    Configuration := TStringList.Create;
    try
      ReportMemoryLeaksOnShutdown := true;
      Configuration.Values['Theme'] := 'dark';
      RunDemo(Configuration);
    finally
      Configuration.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
