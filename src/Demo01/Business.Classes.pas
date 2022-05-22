unit Business.Classes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  {}
  Business.Interfaces;

type
  TApplicationRoot = class
  private
    fCheckoutFeature: ICheckoutFeature;
  public
    [Inject]
    constructor Create(aCheckoutFeature: ICheckoutFeature);
    procedure GenerateDependencyReport();
    procedure ExecuteCheckout;
  end;

  TCheckoutFeature = class(TInterfacedObject, ICheckoutFeature)
  private
    fDatabaseContext: IDatabaseContext;
    fMembershipService: IMembershipService;
    fCustomerManager: ICustomerManager;
    fOredrGenerator: IOrderGenerator;
  public
    [Inject]
    constructor Create(
      aMembershipService: IMembershipService;
      aOrderGenerator: IOrderGenerator;
      aCustomerManager: ICustomerManager;
      aDatabaseContext: IDatabaseContext);
    procedure CheckoutCart(const aCart: TComponent);
    function ToString(): string; override;
  end;

  TMembershipService = class(TInterfacedObject, IMembershipService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function ToString(): string; override;
    function IsCardActive(const aCardNumber: string): boolean;
  end;

  TCustomerManager = class(TInterfacedObject, ICustomerManager)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function ToString(): string; override;
  end;

  TOrderGenerator = class(TInterfacedObject, IOrderGenerator)
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

const
  PrivateBuyer: NativeInt = 1000000;
  BussinesBuyer: NativeInt = 2000000;

procedure TApplicationRoot.ExecuteCheckout();
var
  aCart: TComponent;
begin
  aCart := TComponent.Create(nil);
  with aCart do
  begin
    Name := 'Cart0001';
    Tag := BussinesBuyer+12345;
  end;
  fCheckoutFeature.CheckoutCart(aCart);
end;

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

{ TCheckoutFeature }

constructor TCheckoutFeature.Create(
  aMembershipService: IMembershipService;
  aOrderGenerator: IOrderGenerator;
  aCustomerManager: ICustomerManager;
  aDatabaseContext: IDatabaseContext);
begin
  self.fMembershipService := aMembershipService;
  self.fOredrGenerator := aOrderGenerator;
  self.fCustomerManager := aCustomerManager;
  self.fDatabaseContext := aDatabaseContext;
end;

procedure TCheckoutFeature.CheckoutCart(const aCart: TComponent);
// var
//   isActive: boolean;
begin
//   isActive := fMembershipService.IsCardActive(aCardNumber);
//   aDiscount := IfThen(isActive, 10, 0);
end;

function TCheckoutFeature.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fMembershipService.ToString()) +
    IndentString(fDatabaseContext.ToString) +
    IndentString(fCustomerManager.ToString) +
    IndentString(fOredrGenerator.ToString)]);
end;

{ TMembershipService }

constructor TMembershipService.Create(aDatabaseContext: IDatabaseContext);
begin
  fDatabaseContext := aDatabaseContext;
end;

function TMembershipService.ToString: string;
begin
  Result := Format('%s [%s]', [self.ClassName,
    sLineBreak + IndentString(fDatabaseContext.ToString())]);
end;

function TMembershipService.IsCardActive(const aCardNumber
  : string): boolean;
var
  aNumber: integer;
begin
  Result := aCardNumber.StartsWith('A') and TryStrToInt(aCardNumber, aNumber)
    and (aNumber > 100);
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

{ TOrderGenerator }

constructor TOrderGenerator.Create(aDatabaseContext: IDatabaseContext);
begin
  self.fDatabaseContext := aDatabaseContext;
end;

function TOrderGenerator.ToString: string;
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
