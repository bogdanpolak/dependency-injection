program ShoppingSystemDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  PointOfSaleApp in 'PointOfSaleApp.pas',
  ApplicationRoot in 'ApplicationRoot.pas',
  CheckoutFeatureC in 'Features\CheckoutFeatureC.pas',
  CheckoutFeature in 'Features\CheckoutFeature.pas',
  BuyerProviderC in 'Features\BuyerProviderC.pas',
  BuyerProvider in 'Features\BuyerProvider.pas',
  MembershipServiceC in 'Features\MembershipServiceC.pas',
  MembershipService in 'Features\MembershipService.pas',
  InvoiceServiceC in 'Features\InvoiceServiceC.pas',
  InvoiceService in 'Features\InvoiceService.pas',
  Model.Cart in 'Model\Model.Cart.pas',
  DataLayerC in 'Data\DataLayerC.pas',
  DataLayer in 'Data\DataLayer.pas',
  ShoppingCartBuilderC in 'Data\ShoppingCartBuilderC.pas',
  ShoppingCartBuilder in 'Data\ShoppingCartBuilder.pas',
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
