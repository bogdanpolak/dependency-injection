unit ApplicationRoot;

interface

uses
  System.Classes,
  System.SysUtils,
  Spring.Container.Common,
  Spring.Logging,
  {}
  Utils.DependencyTreeFormatterC,
  Model.Cart,
  ShoppingCartBuilder,
  CheckoutFeature;

{$SCOPEDENUMS ON}

type
  TAppOption = (ShowDependencyTree);
  TAppOptions = set of TAppOption;

  TApplicationRoot = class
  private
    fCheckoutFeature: ICheckoutFeature;
    fShoppingCartBuilder: IShoppingCartBuilder;
    fLogger: ILogger;
    function BuildCart(): TCart;
    function GetDependencyTree(): string;
    procedure LogCart(aCart: TCart);
  public
    [Inject]
    constructor Create(
      aCheckoutFeature: ICheckoutFeature;
      aShoppingCartBuilder: IShoppingCartBuilder;
      aLogger: ILogger);
    procedure Execute(const aAppOptions: TAppOptions);
  end;

implementation

{ TApplicationRoot }

function TApplicationRoot.BuildCart(): TCart;
var
  itemsInCart: Integer;
begin
  fShoppingCartBuilder { }
    .AddItem(3, 94001, 'Laptop ASUS ROG Zephyrus M16', 7199)
    .AddItem(2, 88001, 'Laptop ASUS Vivobook Pro 14X', 5999)
    .AddItem(6, 91001, 'Laptop ASUS ZenBook 14 UM', 3599)
    .AddItem(4, 86001, 'Laptop HP OMEN 16-b0252nw 16,1"', 8299)
    .AddItem(6, 87001, 'Laptop HP Pavilion Gaming 15-dk2186nw', 5499)
    .AddItem(7, 96001, 'Laptop Microsoft Surface Pro 8 13" Intel', 5299)
    .AddItem(3, 95001, 'Laptop Lenovo Legion S7', 6999)
    .AddItem(8, 85887, 'Laptop Lenovo IdeaPad Gaming 3 15IHU6', 4199)
    .AddItem(13, 93001, 'Laptop Acer Swift 3 14" AMD Ryzen 7 4700U', 3399)
    .AddItem(9, 89001, 'Laptop Acer Chromebook', 1349)
    .AddItem(1, 92001, 'Laptop MSI Vector GP66 12UGS-409', 9199)
    .AddItem(6, 93001, 'Laptop MSI Katana GF66 11UE-805PL', 6199)
    .AddItem(9, 84001, 'Laptop Dell G15 5511-9151 15,6"', 6899)
    .AddItem(12, 82001, 'Laptop Dell Inspiron 5415-7585 14"', 3799)
    .AddItem(1, 90001, 'Laptop LG Gram 14" 14T90P', 5799);
  itemsInCart := 2 + random(3);
  Result := fShoppingCartBuilder.Build(itemsInCart);
end;

constructor TApplicationRoot.Create(
  aCheckoutFeature: ICheckoutFeature;
  aShoppingCartBuilder: IShoppingCartBuilder;
  aLogger: ILogger);
begin
  self.fShoppingCartBuilder := aShoppingCartBuilder;
  self.fCheckoutFeature := aCheckoutFeature;
  self.fLogger := aLogger;
end;

procedure TApplicationRoot.Execute(const aAppOptions: TAppOptions);
var
  dependencyTree: string;
  formatted: string;
  Cart: TCart;
begin
  fLogger.Log('Application Started');
  dependencyTree := GetDependencyTree();
  formatted := TDependencyTreeFormatter.Format(dependencyTree);
  if TAppOption.ShowDependencyTree in aAppOptions then
  begin
    fLogger.Log(formatted);
  end;
  // --------------------------------------------
  Cart := BuildCart();
  try
    LogCart(Cart);
    fCheckoutFeature.CheckoutCart(Cart);
  finally
    Cart.Free;
  end;
end;

function TApplicationRoot.GetDependencyTree: string;
begin
  Result := self.ClassName + '{' + fShoppingCartBuilder.GetDependencyTree() +
    ',' + fCheckoutFeature.GetDependencyTree() + ',ILogger' + '}';
end;

procedure TApplicationRoot.LogCart(aCart: TCart);
var
  idx: Integer;
  msg: string;
begin
  msg := 'Shopping cart items to checkout:';
  for idx := 0 to aCart.Items.Count - 1 do
  begin
    msg := msg + sLineBreak + '  -> ' + aCart.Items[idx].ToString();
  end;
  fLogger.Log(msg);
end;

end.
