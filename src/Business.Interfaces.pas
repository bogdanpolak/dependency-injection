unit Business.Interfaces;

interface

type
  IApplicationRoot = interface
    ['{4305A44E-A7D7-495E-BDE0-C85B6FC92E99}']
    function ToString(): string;
  end;

  IDataModule = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  ISubModule = interface
    ['{59BF0CAF-08DA-459F-8495-16794A7B959E}']
    function ToString(): string;
  end;

  IOrderRepository = interface
    ['{12A1A68F-7D17-4DFD-B320-864D42CC314F}']
    function ToString(): string;
  end;

implementation

end.
