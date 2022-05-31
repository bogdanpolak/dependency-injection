program ex01_ConsoleService;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container;

type
  IConsole = interface(IInterface)
    ['{A41DBC10-DF86-4414-867B-A5AC905C8BC8}']
    procedure Log(const aMsg: String);
  end;

  TStandardConsole = class(TInterfacedObject, IConsole)
    procedure Log(const aMsg: String);
  end;

  TApplication = class
  private
    fConsole: IConsole;
  public
    constructor Create(const aConsole: IConsole);
    procedure Run();
  end;

procedure TStandardConsole.Log(const aMsg: String);
begin
  Writeln(aMsg);
end;

constructor TApplication.Create(const aConsole: IConsole);
begin
  fConsole := aConsole;
end;

procedure TApplication.Run;
begin
  fConsole.Log('Hello Dependency Injection!');
end;

var
  app: TApplication;
begin
  try
    GlobalContainer.RegisterType<IConsole,TStandardConsole>();
    GlobalContainer.RegisterType<TApplication>();
    GlobalContainer.Build;
    app := GlobalContainer.Resolve<TApplication>;
    app.Run;
    app.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

