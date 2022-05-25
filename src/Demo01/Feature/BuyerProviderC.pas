unit BuyerProviderC;

interface

uses
  System.SysUtils,
  Spring.Container.Common,
  {}
  BuyerProvider,
  MembershipService,
  Utils.InterfacedTrackingObject;

type
  TBuyerProvider = class(TInterfacedTrackingObject, IBuyerProvider)
  private
    fMembershipService: IMembershipService;
  public
    [Inject]
    constructor Create(aMembershipService: IMembershipService);
    function GetBayer(): string;
    function GetDependencyTree(): string;
  end;

implementation

{ TBuyerProvider }

constructor TBuyerProvider.Create(aMembershipService: IMembershipService);
begin
  inherited Create();
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
  Result := self.ClassNameWithInstanceId() + '{' +
    fMembershipService.GetDependencyTree() + '}';
end;

end.
