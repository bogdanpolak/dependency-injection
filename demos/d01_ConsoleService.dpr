program d01_ConsoleService;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.StrUtils,
  Spring.Container,
  Spring.Container.Common,
  Spring.Services,
  Winapi.Windows;

type
  ILogger = interface(IInterface)
    ['{115927AB-1245-4FD2-98A0-BB0326D999C3}']
    procedure Error(const msg: string);
    procedure Info(const msg: string);
  end;

  IConsole = interface(IInterface)
    ['{A41DBC10-DF86-4414-867B-A5AC905C8BC8}']
    procedure Write(const aMsg: String);
  end;

  ISomeService = interface(IInterface)
    ['{A41DBC10-DF86-4414-867B-A5AC905C8BC8}']
    procedure Execute();
  end;

type
  TLogger = class(TInterfacedObject, ILogger)
  public
    procedure Error(const msg: string);
    procedure Info(const msg: string);
  end;

  TStandardConsole = class(TInterfacedObject, IConsole)
    procedure Write(const aMsg: String);
  end;

  TSomeService = class(TInterfacedObject, ISomeService)
  private
    fConsole: IConsole;
    fConfiguration: TStringList;
    [Inject]
    fLogger: ILogger;
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

  { TLogger }

procedure TLogger.Error(const msg: string);
var
  consoleOut: THandle;
  screenBufferInfo: TConsoleScreenBufferInfo;
begin
  consoleOut := TTextRec(Output).Handle;
  GetConsoleScreenBufferInfo(consoleOut, screenBufferInfo);
  SetConsoleTextAttribute(consoleOut, FOREGROUND_INTENSITY or FOREGROUND_RED);
  writeln(Format('[%s] ERROR: %s', [DateToISO8601(Now), msg]));
  SetConsoleTextAttribute(consoleOut, screenBufferInfo.wAttributes);
end;

procedure TLogger.Info(const msg: string);
var
  consoleOut: THandle;
  screenBufferInfo: TConsoleScreenBufferInfo;
begin
  consoleOut := TTextRec(Output).Handle;
  GetConsoleScreenBufferInfo(consoleOut, screenBufferInfo);
  SetConsoleTextAttribute(consoleOut, FOREGROUND_INTENSITY or FOREGROUND_BLUE);
  writeln(Format('[%s] Info: %s', [DateToISO8601(Now), msg]));
  SetConsoleTextAttribute(consoleOut, screenBufferInfo.wAttributes);
end;

{ TStandardConsole }

procedure TStandardConsole.Write(const aMsg: String);
begin
  writeln(aMsg);
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
  fConsole.Write('Theme:' + fConfiguration.Values['Theme']);
  if Assigned(fLogger) then
    fLogger.Error('Some error');
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
  writeln(IfThen(fConsole is TStandardConsole,
    'Console service implementation: TStandardConsole'));
  fConsole.Write('Hello Dependency Injection!');
  fSomeService.Execute;
end;

{ Console Application }

procedure RunDemo(const aConfiguration: TStringList);
var
  app: TApplication;
  locator: IServiceLocator;
begin
  GlobalContainer.RegisterType<ILogger, TLogger>();
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
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
