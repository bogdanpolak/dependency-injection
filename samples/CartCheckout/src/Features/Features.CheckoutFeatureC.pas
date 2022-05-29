unit Features.CheckoutFeatureC;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  {}
  Utils.InterfacedTrackingObject,
  Model.Cart,
  Features.CheckoutFeature,
  Features.BuyerProvider,
  Features.InvoiceService,
  Features.MembershipService,
  DataLayer;

type
  TCheckoutFeature = class(TInterfacedTrackingObject, ICheckoutFeature)
  private
    fDatabaseContext: IDatabaseContext;
    fBuyerProvider: IBuyerProvider;
    fInvoiceService: IInvoiceService;
    function GetMembershipLevel(const aBuyer: string): TMembershipLevel;
  public
    [Inject]
    constructor Create(
      aBuyerProvider: IBuyerProvider;
      aInvoiceService: IInvoiceService;
      aDatabaseContext: IDatabaseContext);
    procedure CheckoutCart(const aCart: TCart);
    function GetDependencyTree(): string;
  end;

implementation

constructor TCheckoutFeature.Create(
  aBuyerProvider: IBuyerProvider;
  aInvoiceService: IInvoiceService;
  aDatabaseContext: IDatabaseContext);
begin
  inherited Create();
  self.fBuyerProvider := aBuyerProvider;
  self.fInvoiceService := aInvoiceService;
  self.fDatabaseContext := aDatabaseContext;
end;

procedure TCheckoutFeature.CheckoutCart(const aCart: TCart);
var
  aBuyer: string;
  aMembershipLevel: TMembershipLevel;
  aInvoice: string;
begin
  aBuyer := fBuyerProvider.GetBayer();
  aMembershipLevel := self.GetMembershipLevel(aBuyer);
  fDatabaseContext.CheckoutStatus(TCheckoutStatus.InProgress, aCart);
  fInvoiceService.BundleProducts(aCart);
  fInvoiceService.ApplyDiscount(aCart, aMembershipLevel);
  // fCheckoutDisplay.ShowCart(aCart);
  // fCheckoutDisplay.OnApproveal();
  aInvoice := fInvoiceService.CreateInvoice(aCart);
  // if aInvoice = nil then
  // begin
  // fDatabaseContext.CheckoutStatus(TCheckoutStatus.Failed, aCart);
  // fEventBus.Post('ShipInvoice', '#{id}')
  // end
  // else
  // begin
  // fDatabaseContext.CheckoutStatus(TCheckoutStatus.Succed, aCart);
  // end;
end;

function TCheckoutFeature.GetMembershipLevel(const aBuyer: string)
  : TMembershipLevel;
begin
  Result := TMembershipLevel.Basic;
end;

function TCheckoutFeature.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId() + '{' +
    fBuyerProvider.GetDependencyTree() + ',' +
    fDatabaseContext.GetDependencyTree() + ',' +
    fInvoiceService.GetDependencyTree() + '}';
end;

end.
