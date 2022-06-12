program d07_Strategy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Spring.Collections,
  Spring.Container;

type
  TServiceInfo = (siServiceA, siServiceB);

  IService = interface
    ['{09D2AC06-85AE-4E27-B614-49B9195AD0F5}']
    function GetType: TServiceInfo;
    procedure Execute();
  end;

  TServiceA = class(TInterfacedObject, IService)
    function GetType: TServiceInfo;
    procedure Execute();
  end;

  TServiceB = class(TInterfacedObject, IService)
    function GetType: TServiceInfo;
    procedure Execute();
  end;



{ TServiceA }

procedure TServiceA.Execute;
begin
  Writeln('[ Service A ]');
end;

function TServiceA.GetType: TServiceInfo;
begin
  Result := siServiceA;
end;

{ TServiceB }

procedure TServiceB.Execute;
begin
  Writeln('[ Service B ]');
end;

function TServiceB.GetType: TServiceInfo;
begin
  Result := siServiceB;
end;

{ App }

procedure RunDemo();
var
  svrs: TArray<IService>;
  services: IList<IService>;
begin
  GlobalContainer.RegisterType<IService,TServiceA>('A');
  GlobalContainer.RegisterType<IService,TServiceB>('B');
  GlobalContainer.Build;
  svrs := GlobalContainer.Resolve<TArray<IService>>();
  services := TCollections.CreateList<IService>(svrs);
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
