unit Demo01.Run;

interface

uses
  Spring.Container;

type
  TDemo01 = class
    class procedure Run();
  private
    class procedure BuildContainer(Container: TContainer);
  end;

implementation

uses
  CheckoutFeature,
  CheckoutFeatureImpl,
  ApplicationRoot;

{ TDemo01 }

class procedure TDemo01.BuildContainer(Container: TContainer);
begin
  // Data Layer:
  Container.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  Container.RegisterType<IDatabaseContext, TDatabaseContext>();

  // Domain Layer
  Container.RegisterType<IOrderGenerator, TOrderGenerator>();
  Container.RegisterType<IMembershipService, TMembershipService>();
  Container.RegisterType<ICheckoutFeature, TCheckoutFeature>();

  // Application Layer:
  Container.RegisterType<TApplicationRoot>();

  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()

  Container.Build;
end;

class procedure TDemo01.Run();
var
  App: TApplicationRoot;
begin
  BuildContainer(GlobalContainer);
  App := GlobalContainer.Resolve<TApplicationRoot>;
  App.GenerateDependencyReport();
end;

end.
