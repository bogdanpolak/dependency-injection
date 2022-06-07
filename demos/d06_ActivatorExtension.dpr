program d06_ActivatorExtension;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container,
  Spring.Container.Common,
  Spring.Container.ActivatorExtension,
  Spring;

type
  IServiceA = interface
    ['{CDF3322E-90FC-4F26-943B-0F7CB3F9E42F}']
  end;

  TServiceA = class(TInterfacedObject, IServiceA)
  end;

  TRoot = class(TInterfacedObject)
  private
    fServiceA: IServiceA;
  public
    constructor Create(const aServiceA: IServiceA);
  end;

constructor TRoot.Create(const aServiceA: IServiceA);
begin
  fServiceA := aServiceA;
end;

procedure DemoRun();
var
  root: TRoot;
begin
  GlobalContainer.RegisterType<TRoot>().AsSingleton();
  GlobalContainer.AddExtension<TActivatorContainerExtension>();
  // This an intended comment:
  // GlobalContainer.RegisterType<IServiceA, TServiceA>();
  // More information:
  // https://stackoverflow.com/questions/71424345/spring4d-should-not-call-inherited-constructor-if-not-all-parameters-can-be-reso
  GlobalContainer.Build();
  root := GlobalContainer.Resolve<TRoot>();
  if root is TRoot then
    writeln('true');
end;

begin
  try
    DemoRun();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
