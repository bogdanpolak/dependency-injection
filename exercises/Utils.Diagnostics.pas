unit Utils.Diagnostics;

interface

uses
  System.SysUtils,
  System.Diagnostics,
  System.TimeSpan;

type
  TDiagnostics = class
    class procedure MeasureTimeSpan(
      const aActionName: string;
      const aAction: TProc); static;
  end;

implementation

class procedure TDiagnostics.MeasureTimeSpan(
  const aActionName: string;
  const aAction: TProc);
var
  stopwatch: TStopwatch;
  TimeSpan: TTimeSpan;
begin
  stopwatch := TStopwatch.StartNew;
  try
    aAction();
  finally
    TimeSpan := stopwatch.Elapsed;
    Writeln(Format('[ Diagnostic ] Action "%s" completed in %d ms',
      [aActionName, TimeSpan.Milliseconds]));
  end;
end;

end.

