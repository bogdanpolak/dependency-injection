unit Model.Cart;

interface

uses
  System.SysUtils,
  {}
  Spring.Collections;

type
  TCartItem = class
  private
    fProductId: Integer;
    fProductName: string;
    fItemPrice: Currency;
    fCatalogPrice: Currency;
    fQuantity: Integer;
  public
    property ProductId: Integer read fProductId write fProductId;
    property ProductName: string read fProductName write fProductName;
    property ItemPrice: Currency read fItemPrice write fItemPrice;
    property CatalogPrice: Currency read fCatalogPrice write fCatalogPrice;
    property Quantity: Integer read fQuantity write fQuantity;
    function ToString(): string; override;
  end;

  TCart = class
  private
    FItems: IList<TCartItem>;
  public
    constructor Create();
    property Items: IList<TCartItem> read FItems write FItems;
  end;

implementation

{ TCart }

constructor TCart.Create();
begin
  Items := TCollections.CreateObjectList<TCartItem>();
end;

{ TCartItem }

function TCartItem.ToString: string;
begin
  Result := Format('%d | %d x "%s" | %.2fzł', [ProductId, Quantity, ProductName,
    ItemPrice])
end;

end.
