unit Features.InvoiceService;

interface

uses
  Features.MembershipService,
  Model.Cart;

type
  IInvoiceService = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function GetDependencyTree(): string;
    procedure BundleProducts(aCart: TCart);
    function CreateInvoice(const aCart: TCart): string;
    procedure ApplyDiscount(
      aCart: TCart;
      aMembershipLevel: TMembershipLevel);
  end;

implementation

end.
