unit CheckoutFeatureC;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  {}
  CheckoutFeature,
  DataLayer,
  BuyerProvider,
  InvoiceService,
  Utils.InterfacedTrackingObject;

type
  TCheckoutFeature = class(TInterfacedTrackingObject, ICheckoutFeature)
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
  Result := self.ClassNameWithInstanceId() + '{' +
    fBuyerProvider.GetDependencyTree() + ',' +
    fDatabaseContext.GetDependencyTree() + ',' +
    fInvoiceService.GetDependencyTree() + '}';
end;

end.
