unit ShoppingCartBuilder;

interface

type
  IShoppingCartBuilder = interface
    ['{412EFA97-0AEA-4810-9301-8BD72E877043}']
    function AddItem(
      const aQuantity: integer;
      const aCatalogId: integer;
      const aName: string;
      const aPrice: currency): IShoppingCartBuilder;
    function Build(const aItems: integer): string;
    function GetDependencyTree(): string;
  end;

implementation

end.
