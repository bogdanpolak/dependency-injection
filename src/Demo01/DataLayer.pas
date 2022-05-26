unit DataLayer;

interface

uses
  System.Classes,
  Model.Cart;

{$SCOPEDENUMS ON}

type
  TCheckoutStatus = (Ready, InProgress, Failed, Succeed);

  IDatabaseContext = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    procedure CheckoutStatus(
      aCheckoutStatus: TCheckoutStatus;
      const aCart: TCart);
    function GetDependencyTree(): string;
  end;

  IConnectionFactory = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function GetConnection(): TComponent;
    function GetDependencyTree(): string;
  end;

implementation

end.
