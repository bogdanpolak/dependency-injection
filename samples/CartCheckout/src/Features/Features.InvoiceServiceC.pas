unit Features.InvoiceServiceC;

interface

uses
  System.SysUtils,
  Spring.Container.Common,
  {}
  Utils.InterfacedTrackingObject,
  Model.Cart,
  DataLayer,
  Features.InvoiceService,
  Features.MembershipService;

type
  TInvoiceService = class(TInterfacedTrackingObject, IInvoiceService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    procedure BundleProducts(aCart: TCart);
    procedure ApplyDiscount(
      aCart: TCart;
      aMembershipLevel: TMembershipLevel);
    function CreateInvoice(const aCart: TCart): string;

    function GetDependencyTree(): string;
  end;

implementation

procedure TInvoiceService.ApplyDiscount(
  aCart: TCart;
  aMembershipLevel: TMembershipLevel);
begin

end;

procedure TInvoiceService.BundleProducts(aCart: TCart);
begin

end;

constructor TInvoiceService.Create(aDatabaseContext: IDatabaseContext);
begin
  inherited Create();
  self.fDatabaseContext := aDatabaseContext;
end;

function TInvoiceService.CreateInvoice(const aCart: TCart): string;
begin
  Result := '#1111';
end;

function TInvoiceService.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId() + '{' +
    fDatabaseContext.GetDependencyTree() + '}';
end;

end.
