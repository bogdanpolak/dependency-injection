﻿unit Helper.Container.Register;

interface

uses
  System.Classes,
  Spring.Container,
  Spring.Logging.Appenders,
  Spring.Logging.Controller,
  Spring.Logging.Loggers,
  Spring.Logging;

type
  TContainerHelper = class helper for TContainer
  private
    class procedure RegisterDataServices(aContainer: TContainer); static;
    class procedure RegisterDomainServices(aContainer: TContainer); static;
    class procedure RegisterLogger(aContainer: TContainer); static;
    class procedure RegisterApplicationRoot(aContainer: TContainer); static;
  public
    procedure RegisterAppServices();
  end;

implementation

uses
  ApplicationRoot,
  Features.CheckoutFeature,
  Features.CheckoutFeatureC,
  Features.BuyerProvider,
  Features.BuyerProviderC,
  Features.MembershipService,
  Features.MembershipServiceC,
  Features.InvoiceService,
  Features.InvoiceServiceC,
  ShoppingCartBuilder,
  ShoppingCartBuilderC,
  DataLayer,
  DataLayerC;

{ TContainerHelper }

procedure TContainerHelper.RegisterAppServices();
begin
  RegisterDataServices(self);
  RegisterDomainServices(self);
  RegisterLogger(self);
  self.RegisterType<TApplicationRoot>;
end;

class procedure TContainerHelper.RegisterApplicationRoot(aContainer: TContainer);
begin
end;

class procedure TContainerHelper.RegisterDataServices(aContainer: TContainer);
begin
  aContainer.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  aContainer.RegisterType<IDatabaseContext, TDatabaseContext>();
end;

class procedure TContainerHelper.RegisterDomainServices(aContainer: TContainer);
begin
  aContainer.RegisterType<IShoppingCartBuilder, TShoppingCartBuilder>();
  aContainer.RegisterType<ICheckoutFeature, TCheckoutFeature>();
  aContainer.RegisterType<IBuyerProvider, TBuyerProvider>();
  aContainer.RegisterType<IMembershipService, TMembershipService>();
  aContainer.RegisterType<IInvoiceService, TInvoiceService>();
end;

class procedure TContainerHelper.RegisterLogger(aContainer: TContainer);
var
  loggerControler: TLoggerController;
  textAppender: TTextLogAppender;
begin
  textAppender := TTextLogAppender.Create();
  loggerControler := TLoggerController.Create([textAppender]);
  aContainer.RegisterInstance<ILoggerController>(loggerControler);
  aContainer.RegisterType<ILogger, TLogger>;
end;

end.
