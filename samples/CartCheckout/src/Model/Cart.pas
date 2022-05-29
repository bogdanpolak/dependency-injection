unit Cart;

interface

type
  TCart = class
  private
    fProductId: Integer;
    fProductName: string;
    fItemPrice: Currency;
    fCatalogPrice: Currency;
    fQuantity: Integer;
  published
    property ProductId: Integer read fProductId write fProductId;
    property ProductName: string read fProductName write fProductName;
    property ItemPrice: Currency read fItemPrice write fItemPrice;
    property CatalogPrice: Currency read fCatalogPrice write fCatalogPrice;
    property Quantity: Integer read fQuantity write fQuantity;
  end;

implementation

end.
