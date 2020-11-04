unit Business.Interfaces;

interface

uses
  System.Classes;

type
  IApplicationRoot = interface
    ['{4305A44E-A7D7-495E-BDE0-C85B6FC92E99}']
    function ToString(): string;
  end;

  IMainModule = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  IOrderManager = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  IOrderRepository = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function ToString(): string;
  end;

  IConnectionFactory = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function GetConnection(): TComponent;
  end;


implementation

end.
