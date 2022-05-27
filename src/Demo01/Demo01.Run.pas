﻿unit Demo01.Run;

interface

uses
  Spring.Container;

type
  TDemo01 = class
    class procedure Run(const aIsQuiet: boolean);
  private
    class procedure BuildContainer(Container: TContainer);
  end;

implementation

uses
  CheckoutFeature,
  CheckoutFeatureC,
  BuyerProvider,
  BuyerProviderC,
  MembershipService,
  MembershipServiceC,
  InvoiceService,
  InvoiceServiceC,
  ShoppingCartBuilder,
  ShoppingCartBuilderC,
  DataLayer,
  DataLayerC,
  ApplicationRoot;

{ TDemo01 }

class procedure TDemo01.BuildContainer(Container: TContainer);
begin
  // Data Layer:
  Container.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  Container.RegisterType<IDatabaseContext, TDatabaseContext>();

  // Domain Layer
  Container.RegisterType<IShoppingCartBuilder, TShoppingCartBuilder>();
  Container.RegisterType<ICheckoutFeature, TCheckoutFeature>();
  Container.RegisterType<IBuyerProvider, TBuyerProvider>();
  Container.RegisterType<IMembershipService, TMembershipService>();
  Container.RegisterType<IInvoiceService, TInvoiceService>();

  // Application Layer:
  Container.RegisterType<TApplicationRoot>();

  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()

  Container.Build;
end;

class procedure TDemo01.Run(const aIsQuiet: boolean);
var
  App: TApplicationRoot;
begin
  BuildContainer(GlobalContainer);
  App := GlobalContainer.Resolve<TApplicationRoot>;
  if not aIsQuiet then
  begin
    App.GenerateDependencyReport();
  end;
  App.ExecuteCheckout();
  App.Free;
end;

end.
