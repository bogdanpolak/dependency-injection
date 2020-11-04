unit App.Main;

interface

uses
  Spring.Container,
  {}
  Business.Interfaces,
  Utils.Interfaces;

procedure RunAll(Console: IConosole);

implementation

procedure RunAll(Console: IConosole);
var
  App: IApplicationRoot;
begin
  App := GlobalContainer.Resolve<IApplicationRoot>;
  Console.WriteLine(App.ToString());
end;

end.
