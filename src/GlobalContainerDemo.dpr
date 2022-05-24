program GlobalContainerDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Utils.DeveloperMode in 'Utils.DeveloperMode.pas',
  ApplicationRoot in 'Demo01\ApplicationRoot.pas',
  CheckoutFeatureImpl in 'Demo01\Feature\CheckoutFeatureImpl.pas',
  CheckoutFeature in 'Demo01\Feature\CheckoutFeature.pas',
  Demo01.Run in 'Demo01\Demo01.Run.pas',
  ShoppingCartBuilderC in 'Demo01\ShoppingCartBuilderC.pas',
  ShoppingCartBuilder in 'Demo01\ShoppingCartBuilder.pas';

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
    System.Write('... press Enter to close ...');
    System.Readln;
  end;

end.
