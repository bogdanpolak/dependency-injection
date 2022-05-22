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
  TCheckoutFeature = class(TInterfacedObject, ICheckoutFeature)
  private
    fDatabaseContext: IDatabaseContext;
    fMembershipService: IMembershipService;
    fOredrGenerator: IOrderGenerator;
  public
    [Inject]
    constructor Create(
      aMembershipService: IMembershipService;
      aOrderGenerator: IOrderGenerator;
      aDatabaseContext: IDatabaseContext);
    procedure CheckoutCart(const aCart: TComponent);
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

  TOrderGenerator = class(TInterfacedObject, IOrderGenerator)
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
  aMembershipService: IMembershipService;
  aOrderGenerator: IOrderGenerator;
  aDatabaseContext: IDatabaseContext);
begin
  self.fMembershipService := aMembershipService;
  self.fOredrGenerator := aOrderGenerator;
  self.fDatabaseContext := aDatabaseContext;
end;

procedure TCheckoutFeature.CheckoutCart(const aCart: TComponent);
// var
//   isActive: boolean;
begin
//   isActive := fMembershipService.IsCardActive(aCardNumber);
//   aDiscount := IfThen(isActive, 10, 0);
end;

function TCheckoutFeature.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' +
    fMembershipService.GetDependencyTree() + ',' +
    fDatabaseContext.GetDependencyTree + ',' +
    fOredrGenerator.GetDependencyTree + '}';
end;

{ TMembershipService }

constructor TMembershipService.Create(aDatabaseContext: IDatabaseContext);
begin
  fDatabaseContext := aDatabaseContext;
end;

function TMembershipService.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fDatabaseContext.GetDependencyTree() +'}';
end;

function TMembershipService.IsCardActive(const aCardNumber
  : string): boolean;
var
  aNumber: integer;
begin
  Result := aCardNumber.StartsWith('A') and TryStrToInt(aCardNumber, aNumber)
    and (aNumber > 100);
end;

{ TOrderGenerator }

constructor TOrderGenerator.Create(aDatabaseContext: IDatabaseContext);
begin
  self.fDatabaseContext := aDatabaseContext;
end;

function TOrderGenerator.GetDependencyTree: string;
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

function TConnectionFactory.GetDependencyTree: string;
begin
  Result := self.ClassName;
end;

end.
