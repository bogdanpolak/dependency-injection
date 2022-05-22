unit CheckoutFeature;

interface

uses
  System.Classes;

type
  ICheckoutFeature = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    procedure CheckoutCart(const aCart: TComponent);
    function GetDependencyTree(): string;
  end;

  IMembershipService = interface
    ['{488F4CAF-26D1-4DA8-919B-0F8FB45C54D7}']
    function IsCardActive(const aCardNumber: string): boolean;
    function GetDependencyTree(): string;
  end;

  IOrderGenerator = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function GetDependencyTree(): string;
  end;

  IDatabaseContext = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function GetDependencyTree(): string;
  end;

  IConnectionFactory = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function GetConnection(): TComponent;
    function GetDependencyTree(): string;
  end;


implementation

end.
