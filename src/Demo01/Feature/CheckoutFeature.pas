unit CheckoutFeature;

interface

uses
  System.Classes;

type
  ICheckoutFeature = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    procedure CheckoutCart(const aCart: string);
    function GetDependencyTree(): string;
  end;

implementation

end.
