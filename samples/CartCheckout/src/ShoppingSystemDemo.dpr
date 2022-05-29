program ShoppingSystemDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Demo01.Run in 'Demo01\Demo01.Run.pas',
  ApplicationRoot in 'Demo01\ApplicationRoot.pas',
  CheckoutFeatureC in 'Feature\CheckoutFeatureC.pas',
  CheckoutFeature in 'Feature\CheckoutFeature.pas',
  ShoppingCartBuilderC in 'Data\ShoppingCartBuilderC.pas',
  ShoppingCartBuilder in 'Data\ShoppingCartBuilder.pas',
  BuyerProviderC in 'Feature\BuyerProviderC.pas',
  BuyerProvider in 'Feature\BuyerProvider.pas',
  MembershipServiceC in 'Feature\MembershipServiceC.pas',
  MembershipService in 'Feature\MembershipService.pas',
  InvoiceServiceC in 'Feature\InvoiceServiceC.pas',
  InvoiceService in 'Feature\InvoiceService.pas',
  DataLayerC in 'Data\DataLayerC.pas',
  DataLayer in 'Data\DataLayer.pas',
  Model.Cart in 'Model\Model.Cart.pas',
  Utils.DeveloperMode in 'Utils.DeveloperMode.pas',
  Utils.InterfacedTrackingObject in 'Utils.InterfacedTrackingObject.pas',
  Utils.ColoredConsole in 'Utils.ColoredConsole.pas',
  Utils.DependencyTreeFormatterC in 'Utils.DependencyTreeFormatterC.pas';

var
  isMemoryReportMode: boolean;
begin
  randomize;
  isMemoryReportMode := (ParamCount > 0) and (ParamStr(1) = '--memory-report');
  try

    TPointOfSaleApp.DisplayDependencyTree := not isMemoryReportMode;
    TPointOfSaleApp.Run();

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;


  TConsole.Writeln('');

  ReportMemoryLeaksOnShutdown := isMemoryReportMode;

  if not isMemoryReportMode and IsDeveloperMode() then
  begin
    System.Write('... press Enter to close ...');
    System.Readln;
  end;

end.
