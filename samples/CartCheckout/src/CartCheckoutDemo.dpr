program CartCheckoutDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  ConsoleApplication in 'ConsoleApplication.pas',
  ApplicationRoot in 'ApplicationRoot.pas',
  Features.CheckoutFeature in 'Features\Features.CheckoutFeature.pas',
  Features.CheckoutFeatureC in 'Features\Features.CheckoutFeatureC.pas',
  Features.BuyerProvider in 'Features\Features.BuyerProvider.pas',
  Features.BuyerProviderC in 'Features\Features.BuyerProviderC.pas',
  Features.MembershipService in 'Features\Features.MembershipService.pas',
  Features.MembershipServiceC in 'Features\Features.MembershipServiceC.pas',
  Features.InvoiceService in 'Features\Features.InvoiceService.pas',
  Features.InvoiceServiceC in 'Features\Features.InvoiceServiceC.pas',
  Model.Cart in 'Model\Model.Cart.pas',
  DataLayer in 'Data\DataLayer.pas',
  DataLayerC in 'Data\DataLayerC.pas',
  ShoppingCartBuilder in 'Data\ShoppingCartBuilder.pas',
  ShoppingCartBuilderC in 'Data\ShoppingCartBuilderC.pas',
  Utils.DeveloperMode in 'Utils\Utils.DeveloperMode.pas',
  Utils.InterfacedTrackingObject in 'Utils\Utils.InterfacedTrackingObject.pas',
  Utils.ColoredConsole in 'Utils\Utils.ColoredConsole.pas',
  Utils.DependencyTreeFormatterC in 'Utils\Utils.DependencyTreeFormatterC.pas',
  Helper.Container.Register in 'Helper.Container.Register.pas';

begin
  try
    TConsoleApplication.Run();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
