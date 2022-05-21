unit Demo01.Run;

interface

uses
  Spring.Container;

type
  TDemo01 = class
    class procedure Run;
  private
    class procedure BuildContainer(Container: TContainer);
  end;

implementation

uses
  Business.Classes,
  Business.Interfaces;

{ TDemo01 }

class procedure TDemo01.BuildContainer(Container: TContainer);
begin
  Container.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  Container.RegisterType<IOrderRepository, TOrderRepository>();
  Container.RegisterType<ICustomerManager, TCustomerManager>();
  Container.RegisterType<IOrderManager, TOrderManager>();
  Container.RegisterType<IMainModule, TMainModule>();
  Container.RegisterType<IApplicationRoot, TApplicationRoot>();
  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()
  Container.Build;
end;

class procedure TDemo01.Run;
var
  App: IApplicationRoot;
begin
  BuildContainer(GlobalContainer);
  App := GlobalContainer.Resolve<IApplicationRoot>;
  System.Writeln(App.ToString());
end;

end.
