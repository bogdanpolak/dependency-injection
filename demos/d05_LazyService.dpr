program d05_LazyService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Spring,
  Spring.Container;

type
  {$M+} Func<Res> = reference to function (): Res;  {$M-}
  {$M+} Func<P1,Res> = reference to function (Value: P1): Res; {$M-}

  IExampleService = interface
    ['{9722C609-5444-4054-B544-24D30DE8B3B3}']
  end;
  TExampleService = class(TInterfacedObject, IExampleService)
  end;

type
  THomeController = class
  private
    fService: Lazy<IExampleService>;
    function GetService: IExampleService;
  public
    constructor Create(const service: Lazy<IExampleService>);
    property Service: IExampleService read GetService;
  end;

constructor THomeController.Create(const service: Lazy<IExampleService>);
begin
  inherited Create;
  fservice := service;
end;

function THomeController.GetService: IExampleService;
begin
  Result := fService;
end;


procedure RunDemo();
var
  homeController: THomeController;
begin
  GlobalContainer.RegisterType<TExampleService>;
  GlobalContainer.RegisterType<THomeController>;
  GlobalContainer.Build;

  homeController := GlobalContainer.Resolve<THomeController>;
  if homeController.Service is TExampleService then
    writeln('Pass');
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
