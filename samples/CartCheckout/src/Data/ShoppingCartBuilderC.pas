unit ShoppingCartBuilderC;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Spring.Collections,
  {}
  Model.Cart,
  ShoppingCartBuilder,
  Utils.InterfacedTrackingObject;

type
  TShoppingCartBuilder = class(TInterfacedTrackingObject, IShoppingCartBuilder)
  private
    _items: IList<TCartItem>;
  public
    constructor Create();
    function AddItem(
      const aQuantity: integer;
      const aCatalogId: integer;
      const aName: string;
      const aPrice: currency): IShoppingCartBuilder;
    function Build(const aItems: integer): TCart;
    function GetDependencyTree(): string;
  end;

implementation

{ TCartBuilder }

function TShoppingCartBuilder.AddItem(
  const aQuantity: integer;
  const aCatalogId: integer;
  const aName: string;
  const aPrice: currency): IShoppingCartBuilder;
var
  item: TCartItem;
begin
  item := TCartItem.Create();
  with item do
  begin
    ProductId := aCatalogId;
    ProductName := aName;
    ItemPrice := aPrice;
    CatalogPrice := aPrice;
    Quantity := aQuantity;
  end;
  _items.Add(item);
  Result := self;
end;

function TShoppingCartBuilder.Build(const aItems: integer): TCart;
var
  idx: integer;
  aCart: TCart;
begin
  aCart := TCart.Create();
  if aItems = 0 then
    exit(aCart);
  while (aCart.Items.Count < aItems) and (_items.Count > 0) and (aItems > 0) do
  begin
    idx := random(_items.Count);
    aCart.Items.Add(_items.ExtractAt(idx));
  end;
  Result := aCart;
end;

constructor TShoppingCartBuilder.Create;
begin
  inherited;
  _items := TCollections.CreateObjectList<TCartItem>();
end;

function TShoppingCartBuilder.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId();
end;

end.
