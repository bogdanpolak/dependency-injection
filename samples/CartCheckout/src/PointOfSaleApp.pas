unit PointOfSaleApp;

interface

uses
  Spring.Container,
  {}
  ApplicationRoot,
  Utils.ColoredConsole,
  Utils.DeveloperMode;

type
  TConsoleApplication = class
  public
    class procedure Run();
  end;

implementation

uses
  Helper.Container.Register;

class procedure TConsoleApplication.Run();
var
  appOptions: TAppOptions;
  app: TApplicationRoot;
  isMemoryReportMode: Boolean;
begin
  TConsole.Writeln('');
  randomize;
  appOptions := [];
  isMemoryReportMode := (ParamCount > 0) and (ParamStr(1) = '--memory-report');
  if not isMemoryReportMode then
    appOptions := [ TAppOption.ShowDependencyTree ];

  GlobalContainer.RegisterAppServices();
  GlobalContainer.Build;
  app := GlobalContainer.Resolve<TApplicationRoot>;
  try
    app.Execute(appOptions);
  finally
    app.Free;
  end;

  ReportMemoryLeaksOnShutdown := isMemoryReportMode;
  if not isMemoryReportMode and IsDeveloperMode() then
  begin
    System.Write('... press Enter to close ...');
    System.Readln;
  end;
end;

end.

