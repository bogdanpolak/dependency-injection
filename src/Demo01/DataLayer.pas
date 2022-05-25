unit DataLayer;

interface

uses
  System.Classes;

type
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
