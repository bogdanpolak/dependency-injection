unit Business.Interfaces;

interface

uses
  System.Classes;

type
  IApplicationRoot = interface
    ['{4305A44E-A7D7-495E-BDE0-C85B6FC92E99}']
    procedure GenerateDependencyReport();
    procedure Checkout(aMemberCard: string; const aCart: TObject);
  end;

  ICheckoutFeature = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    procedure UseLoyalityProgramCard(const aCardNumber: string);
    procedure ProcessCart(const aCart: TObject);
    function ToString(): string;
  end;

  ILoyalityProgramService = interface
    ['{488F4CAF-26D1-4DA8-919B-0F8FB45C54D7}']
    function IsCardActive(const aCardNumber: string): boolean;
    function ToString(): string;
  end;

  ICustomerManager = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  IOrderGenerator = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  IDatabaseContext = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function ToString(): string;
  end;

  IConnectionFactory = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function GetConnection(): TComponent;
    function ToString(): string;
  end;


implementation

end.
