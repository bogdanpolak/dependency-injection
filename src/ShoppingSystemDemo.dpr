program ShoppingSystemDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Utils.DeveloperMode in 'Utils.DeveloperMode.pas',
  ApplicationRoot in 'Demo01\ApplicationRoot.pas',
  CheckoutFeatureC in 'Demo01\Feature\CheckoutFeatureC.pas',
  CheckoutFeature in 'Demo01\Feature\CheckoutFeature.pas',
  Demo01.Run in 'Demo01\Demo01.Run.pas',
  ShoppingCartBuilderC in 'Demo01\ShoppingCartBuilderC.pas',
  ShoppingCartBuilder in 'Demo01\ShoppingCartBuilder.pas',
  Utils.InterfacedTrackingObject in 'Utils.InterfacedTrackingObject.pas',
  BuyerProviderC in 'Demo01\Feature\BuyerProviderC.pas',
  BuyerProvider in 'Demo01\Feature\BuyerProvider.pas',
  MembershipServiceC in 'Demo01\Feature\MembershipServiceC.pas',
  MembershipService in 'Demo01\Feature\MembershipService.pas',
  InvoiceServiceC in 'Demo01\Feature\InvoiceServiceC.pas',
  InvoiceService in 'Demo01\Feature\InvoiceService.pas',
  DataLayerC in 'Demo01\DataLayerC.pas',
  DataLayer in 'Demo01\DataLayer.pas';

begin
  randomize;
  try

    TDemo01.Run();

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  if IsDeveloperMode() then
  begin
    ReportMemoryLeaksOnShutdown := true;
    System.Write('... press Enter to close ...');
    System.Readln;
  end;

end.
