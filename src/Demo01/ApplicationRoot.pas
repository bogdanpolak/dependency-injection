unit ApplicationRoot;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  Spring.Container.Common,
  {}
  CheckoutFeature;

type
  TApplicationRoot = class
  private
    fCheckoutFeature: ICheckoutFeature;
    procedure DisplayDependencyTree(const aTree: string);
  public
    [Inject]
    constructor Create(aCheckoutFeature: ICheckoutFeature);
    procedure GenerateDependencyReport();
    procedure ExecuteCheckout;
  end;

implementation

{ TApplicationRoot }

const
  PrivateBuyer: NativeInt = 1000000;
  BussinesBuyer: NativeInt = 2000000;

procedure TApplicationRoot.ExecuteCheckout();
var
  aCart: TComponent;
begin
  aCart := TComponent.Create(nil);
  with aCart do
  begin
    Name := 'Cart0001';
    Tag := BussinesBuyer + 12345;
  end;
  fCheckoutFeature.CheckoutCart(aCart);
end;

constructor TApplicationRoot.Create(aCheckoutFeature: ICheckoutFeature);
begin
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
