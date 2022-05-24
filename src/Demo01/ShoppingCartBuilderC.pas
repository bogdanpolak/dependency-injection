unit ShoppingCartBuilderC;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Spring.Collections,
  {}
  ShoppingCartBuilder;

type
  TShoppingCartBuilder = class(TInterfacedObject, IShoppingCartBuilder)
  private
    _items: TList<string>;
  public
    constructor Create();
    function AddItem(
      const aQuantity: integer;
      const aCatalogId: integer;
      const aName: string;
      const aPrice: currency): IShoppingCartBuilder;
    function Build(const aItems: integer): string;
  end;

implementation

{ TCartBuilder }

function TShoppingCartBuilder.AddItem(
  const aQuantity: integer;
  const aCatalogId: integer;
  const aName: string;
  const aPrice: currency): IShoppingCartBuilder;
begin
  _items.Add(Format('%d;%d;%s;%f', [aQuantity, aCatalogId, aName, aPrice]));
  Result := self;
end;

function TShoppingCartBuilder.Build(const aItems: integer): string;
var
  list: IList<string>;
  idx: integer;
begin
  list := TCollections.CreateList<string>(_items.ToArray());
  while (list.Count > aItems) and (aItems>0) do
  begin
    list.Delete(random(list.Count));
  end;
  Result := String.Join('|', list.ToArray());
end;

constructor TShoppingCartBuilder.Create;
begin
  _items := TList<string>.Create();
end;

end.
