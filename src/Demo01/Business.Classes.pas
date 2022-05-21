unit Business.Classes;

interface

uses
  System.Classes,
  System.SysUtils,
  Spring.Container.Common,
  {}
  Business.Interfaces;

type
  TApplicationRoot = class(TInterfacedObject, IApplicationRoot)
  private
    fMainModule: IMainModule;
  public
    [Inject]
    constructor Create(aMainModule: IMainModule);
    function ToString(): string; override;
  end;

  TMainModule = class(TInterfacedObject, IMainModule)
  private
    fOrderRepository: IOrderRepository;
    fOrderManager: IOrderManager;
    fCustomerManager: ICustomerManager;
  public
    [Inject]
    constructor Create(
      aOrderManager: IOrderManager;
      aCustomerManager: ICustomerManager;
      aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TOrderManager = class(TInterfacedObject, IOrderManager)
  private
    fOrderRepository: IOrderRepository;
  public
    [Inject]
    constructor Create(aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TCustomerManager = class(TInterfacedObject, ICustomerManager)
  private
    fOrderRepository: IOrderRepository;
  public
    [Inject]
    constructor Create(aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TOrderRepository = class(TInterfacedObject, IOrderRepository)
  private
    fIdent: integer;
    fDatabaseConnection: IConnectionFactory;
  public
    [Inject]
    constructor Create(aDatabaseConnection: IConnectionFactory);
    function ToString(): string; override;
  end;

  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    fConnection: TComponent;
    function MethodA(
      a: integer;
      b: string;
      c: currency): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection(): TComponent;
    function ToString(): string; override;
  end;

implementation

const
  Indentation = '    ';

function IndentString(const s: string): string;
var
  sl: TStringList;
  iLine: integer;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    for iLine := 0 to sl.Count - 1 do
      sl[iLine] := Indentation + sl[iLine];
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ TApplicationRoot }

constructor TApplicationRoot.Create(aMainModule: IMainModule);
begin
  self.fMainModule := aMainModule;
end;

function TApplicationRoot.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fMainModule.ToString)]);
end;

{ TMainModule }

constructor TMainModule.Create(
  aOrderManager: IOrderManager;
  aCustomerManager: ICustomerManager;
  aOrderRepository: IOrderRepository);
begin
  self.fOrderManager := aOrderManager;
  self.fCustomerManager := aCustomerManager;
  self.fOrderRepository := aOrderRepository;
end;

function TMainModule.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fOrderRepository.ToString) +
    IndentString(fCustomerManager.ToString) +
    IndentString(fOrderManager.ToString)]);
end;

{ TOrderManager }

constructor TOrderManager.Create(aOrderRepository: IOrderRepository);
begin
  self.fOrderRepository := aOrderRepository;
end;

function TOrderManager.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fOrderRepository.ToString())]);
end;

{ TCustomerManager }

constructor TCustomerManager.Create(aOrderRepository: IOrderRepository);
begin
  self.fOrderRepository := aOrderRepository;
end;

function TCustomerManager.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fOrderRepository.ToString())]);
end;

{ TOrderRepository }

var
  OrderRepositoryCounter: integer = 1;

constructor TOrderRepository.Create(aDatabaseConnection: IConnectionFactory);
begin
  self.fDatabaseConnection := aDatabaseConnection;
  self.fIdent := OrderRepositoryCounter;
  OrderRepositoryCounter := OrderRepositoryCounter + 1;
end;

function TOrderRepository.ToString: string;
var
  connection: TComponent;
begin
  connection := fDatabaseConnection.GetConnection();
  Result := Format('%s(%.3d) - %s [%s]', [self.ClassName, fIdent,
    connection.Name, sLineBreak +
    IndentString(fDatabaseConnection.ToString())]);
end;

{ TConnectionFactory }

var
  ConnectionId: integer = 1;

constructor TConnectionFactory.Create;
begin
  fConnection := nil;
end;

destructor TConnectionFactory.Destroy;
begin
  if fConnection = nil then
    fConnection.Free;
end;

function TConnectionFactory.GetConnection: TComponent;
begin
  if fConnection = nil then
  begin
    fConnection := TComponent.Create(nil);
    fConnection.Name := Format('Connection%.4d', [ConnectionId]);
    ConnectionId := ConnectionId + 1;
  end;
  Result := fConnection;
end;

function TConnectionFactory.MethodA(
  a: integer;
  b: string;
  c: currency): boolean;
begin

end;

function TConnectionFactory.ToString: string;
begin
  Result := Format('%s', [self.ClassName]);
end;

end.
