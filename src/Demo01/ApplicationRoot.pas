unit ApplicationRoot;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  Spring.Collections,
  {}
  ShoppingCartBuilder,
  CheckoutFeature;

type
  TApplicationRoot = class
  private
    fCheckoutFeature: ICheckoutFeature;
    fShoppingCartBuilder: IShoppingCartBuilder;
    procedure DisplayDependencyTree(const aTree: string);
  public
    [Inject]
    constructor Create(
      aCheckoutFeature: ICheckoutFeature;
      aShoppingCartBuilder: IShoppingCartBuilder);
    procedure GenerateDependencyReport();
    procedure ExecuteCheckout();
  end;

implementation

{ TApplicationRoot }

const
  PrivateBuyer: NativeInt = 1000000;
  BussinesBuyer: NativeInt = 2000000;

procedure TApplicationRoot.ExecuteCheckout();
var
  aCart: string;
begin
  aCart := fShoppingCartBuilder { }
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
    .AddItem(1, 90001, 'Laptop LG Gram 14" 14T90P', 5799).Build(2 + random(3));
  TCollections.CreateList<string>(aCart.Split(['|'])).ForEach(
    procedure(const s: string)
    begin
      writeln('  - ', s);
    end);
  fCheckoutFeature.CheckoutCart(aCart);
end;

constructor TApplicationRoot.Create(
  aCheckoutFeature: ICheckoutFeature;
  aShoppingCartBuilder: IShoppingCartBuilder);
begin
  self.fShoppingCartBuilder := aShoppingCartBuilder;
  self.fCheckoutFeature := aCheckoutFeature;
end;

procedure TApplicationRoot.GenerateDependencyReport;
begin
  System.Writeln('Application Root Dependency Tree:');
  System.Writeln('----------------------------------------------');
  DisplayDependencyTree(fCheckoutFeature.GetDependencyTree());
  System.Writeln('----------------------------------------------');
end;

procedure TApplicationRoot.DisplayDependencyTree(const aTree: string);
var
  idx, start, level: Integer;
  ch: Char;
begin
  idx := 0;
  start := 0;
  level := 0;
  for idx := 0 to aTree.Length - 1 do
  begin
    ch := aTree.Chars[idx];
    if CharInSet(ch, ['{', '}', ',']) then
    begin
      if (start < idx) then
      begin
        System.Writeln(StringOfChar(' ', 4 * level) + aTree.Substring(start,
          idx - start));
      end;
      start := idx + 1;
    end;
    case ch of
      '{':
        inc(level);
      '}':
        dec(level);
    end;
  end;
end;

end.
