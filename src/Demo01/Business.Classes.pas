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
    fCheckoutFeature: ICheckoutFeature;
  public
    [Inject]
    constructor Create(aCheckoutFeature: ICheckoutFeature);
    procedure GenerateDependencyReport();
  end;

  TCheckoutFeature = class(TInterfacedObject, ICheckoutFeature)
  private
    fDatabaseContext: IDatabaseContext;
    fOrderManager: IOrderManager;
    fCustomerManager: ICustomerManager;
  public
    [Inject]
    constructor Create(
      aOrderManager: IOrderManager;
      aCustomerManager: ICustomerManager;
      aDatabaseContext: IDatabaseContext);
    function ToString(): string; override;
  end;

  TOrderManager = class(TInterfacedObject, IOrderManager)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function ToString(): string; override;
  end;

  TCustomerManager = class(TInterfacedObject, ICustomerManager)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function ToString(): string; override;
  end;

  TDatabaseContext = class(TInterfacedObject, IDatabaseContext)
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

constructor TApplicationRoot.Create(aCheckoutFeature: ICheckoutFeature);
begin
  self.fCheckoutFeature := aCheckoutFeature;
end;

procedure TApplicationRoot.GenerateDependencyReport;
begin
  System.Writeln('Application Root Dependency Tree:');
  System.Writeln('----------------------------------------------');
  System.Writeln(fCheckoutFeature.ToString);
  System.Writeln('----------------------------------------------');
end;

{ TMainModule }

constructor TCheckoutFeature.Create(
  aOrderManager: IOrderManager;
  aCustomerManager: ICustomerManager;
  aDatabaseContext: IDatabaseContext);
begin
  self.fOrderManager := aOrderManager;
  self.fCustomerManager := aCustomerManager;
  self.fDatabaseContext := aDatabaseContext;
end;

function TCheckoutFeature.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fDatabaseContext.ToString) +
    IndentString(fCustomerManager.ToString) +
    IndentString(fOrderManager.ToString)]);
end;

{ TOrderManager }

constructor TOrderManager.Create(aDatabaseContext: IDatabaseContext);
begin
  self.fDatabaseContext := aDatabaseContext;
end;

function TOrderManager.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fDatabaseContext.ToString())]);
end;

{ TCustomerManager }

constructor TCustomerManager.Create(aDatabaseContext: IDatabaseContext);
begin
  self.fDatabaseContext := aDatabaseContext;
end;

function TCustomerManager.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fDatabaseContext.ToString())]);
end;

{ TDatabaseContext }

var
  DatabaseContextCounter: integer = 1;

constructor TDatabaseContext.Create(aDatabaseConnection: IConnectionFactory);
begin
  self.fDatabaseConnection := aDatabaseConnection;
  self.fIdent := DatabaseContextCounter;
  DatabaseContextCounter := DatabaseContextCounter + 1;
end;

function TDatabaseContext.ToString: string;
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

function TConnectionFactory.ToString: string;
begin
  Result := Format('%s', [self.ClassName]);
end;

end.
