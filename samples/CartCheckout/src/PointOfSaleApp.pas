unit PointOfSaleApp;

interface

uses
  Spring.Container,
  Spring.Logging.Appenders,
  Spring.Logging.Controller,
  Spring.Logging.Loggers,
  Spring.Logging,
  {}
  ApplicationRoot;

type
  TPointOfSaleApp = class
  public
    class procedure Run();
    class var DisplayDependencyTree: boolean;
  private
    class function BuildApplicationRoot(): TApplicationRoot;
    class procedure RegisterDataServices(aContainer: TContainer);
    class procedure RegisterDomainServices(aContainer: TContainer); static;
    class procedure RegisterLogger(aContainer: TContainer); static;
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
  DataLayerC;

{ TDemo01 }

class function TPointOfSaleApp.BuildApplicationRoot(): TApplicationRoot;
var
  Container: TContainer;
begin
  Container := GlobalContainer;

  RegisterDataServices(Container);
  RegisterDomainServices(Container);
  RegisterLogger(Container);
  Container.RegisterType<TApplicationRoot>();

  Container.Build;

  Result := Container.Resolve<TApplicationRoot>;
end;

class procedure TPointOfSaleApp.RegisterDataServices(aContainer: TContainer);
begin
  aContainer.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  aContainer.RegisterType<IDatabaseContext, TDatabaseContext>();
end;

class procedure TPointOfSaleApp.RegisterDomainServices(aContainer: TContainer);
begin
  aContainer.RegisterType<IShoppingCartBuilder, TShoppingCartBuilder>();
  aContainer.RegisterType<ICheckoutFeature, TCheckoutFeature>();
  aContainer.RegisterType<IBuyerProvider, TBuyerProvider>();
  aContainer.RegisterType<IMembershipService, TMembershipService>();
  aContainer.RegisterType<IInvoiceService, TInvoiceService>();
  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()
end;

class procedure TPointOfSaleApp.RegisterLogger(aContainer: TContainer);
var
  loggerControler: TLoggerController;
  textAppender: TTextLogAppender;
begin
  textAppender := TTextLogAppender.Create();
  loggerControler := TLoggerController.Create([textAppender]);
  aContainer.RegisterInstance<ILoggerController>(loggerControler);
  aContainer.RegisterType<ILogger, TLogger>;
end;

// -------------------------------------------

class procedure TPointOfSaleApp.Run();
var
  App: TApplicationRoot;
begin
  App := BuildApplicationRoot();
  try
    App.Execute(DisplayDependencyTree);
  finally
    App.Free;
  end;
end;

end.
