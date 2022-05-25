unit CheckoutFeatureC;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  {}
  CheckoutFeature;

type
  TCheckoutFeature = class(TInterfacedObject, ICheckoutFeature)
  private
    fDatabaseContext: IDatabaseContext;
    fBuyerProvider: IBuyerProvider;
    fInvoiceService: IInvoiceService;
  public
    [Inject]
    constructor Create(
      aBuyerProvider: IBuyerProvider;
      aInvoiceService: IInvoiceService;
      aDatabaseContext: IDatabaseContext);
    procedure CheckoutCart(const aCart: string);
    function GetDependencyTree(): string;
  end;

  TBuyerProvider = class(TInterfacedObject, IBuyerProvider)
  private
    fMembershipService: IMembershipService;
  public
    [Inject]
    constructor Create(aMembershipService: IMembershipService);
    function GetBayer(): string;
    function GetDependencyTree(): string;
  end;

  TMembershipService = class(TInterfacedObject, IMembershipService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function GetDependencyTree(): string;
    function IsCardActive(const aCardNumber: string): boolean;
  end;

  TInvoiceService = class(TInterfacedObject, IInvoiceService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function GetDependencyTree(): string;
  end;

  TDatabaseContext = class(TInterfacedObject, IDatabaseContext)
  private
    fIdent: integer;
    fDatabaseConnection: IConnectionFactory;
  public
    [Inject]
    constructor Create(aDatabaseConnection: IConnectionFactory);
    function GetDependencyTree(): string;
  end;

  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    fConnection: TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection(): TComponent;
    function GetDependencyTree(): string;
  end;

implementation

{ TCheckoutFeature }

constructor TCheckoutFeature.Create(
  aBuyerProvider: IBuyerProvider;
  aInvoiceService: IInvoiceService;
  aDatabaseContext: IDatabaseContext);
begin
  self.fBuyerProvider := aBuyerProvider;
  self.fInvoiceService := aInvoiceService;
  self.fDatabaseContext := aDatabaseContext;
end;

procedure TCheckoutFeature.CheckoutCart(const aCart: string);
// var
// isActive: boolean;
begin
  System.Writeln(fBuyerProvider.GetBayer());

  // isActive := fMembershipService.IsCardActive(aCardNumber);
  // aDiscount := IfThen(isActive, 10, 0);
end;

function TCheckoutFeature.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fBuyerProvider.GetDependencyTree() + ',' +
    fDatabaseContext.GetDependencyTree + ',' +
    fInvoiceService.GetDependencyTree + '}';
end;

{ TBuyerProvider }

constructor TBuyerProvider.Create(aMembershipService: IMembershipService);
begin
  fMembershipService := aMembershipService;
end;

function TBuyerProvider.GetBayer: string;
const
  NumberOfCustomers = 5;
  customers: array [0 .. NumberOfCustomers - 1] of string = ('Amazon', 'Google',
    'Apple', 'Microsoft', 'Embarcadero');
begin
  Result := customers[random(NumberOfCustomers)];
end;

function TBuyerProvider.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fMembershipService.GetDependencyTree() + '}';
end;

{ TMembershipService }

constructor TMembershipService.Create(aDatabaseContext: IDatabaseContext);
begin
  fDatabaseContext := aDatabaseContext;
end;

function TMembershipService.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fDatabaseContext.GetDependencyTree() + '}';
end;

function TMembershipService.IsCardActive(const aCardNumber: string): boolean;
var
  aNumber: integer;
begin
  Result := aCardNumber.StartsWith('A') and TryStrToInt(aCardNumber, aNumber)
    and (aNumber > 100);
end;

{ TInvoiceService }

constructor TInvoiceService.Create(aDatabaseContext: IDatabaseContext);
begin
  self.fDatabaseContext := aDatabaseContext;
end;

function TInvoiceService.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fDatabaseContext.GetDependencyTree() + '}';
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

function TDatabaseContext.GetDependencyTree: string;
var
  connection: TComponent;
begin
  connection := fDatabaseConnection.GetConnection();
  Result := Format('%s(%.3d)', [self.ClassName, fIdent]) + '{' +
    fDatabaseConnection.GetDependencyTree() + '}';
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
  if fConnection <> nil then
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

function TConnectionFactory.GetDependencyTree: string;
begin
  Result := self.ClassName;
end;

end.
