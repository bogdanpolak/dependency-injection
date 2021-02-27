unit Utils.ConsoleLogger;

interface

uses
  Utils.Logger;

type
  TBasicLogger = class(TInterfacedObject, ILogger)
  public
    procedure Log(aLogLevel: TLogLevel; const aMsg: string);
    procedure LogInfo(const aMsg: string);
  end;

implementation

{ TBasicLogger }

procedure TBasicLogger.Log(aLogLevel: TLogLevel; const aMsg: string);
var
  prefix: string;
begin
  case aLogLevel of
    llError:
      prefix := '[Error] ';
    llWarning:
      prefix := '[Warning] ';
    llInfo:
      prefix := '';
  else
    prefix := '[---] ';
  end;
  Writeln(prefix + aMsg);
end;

procedure TBasicLogger.LogInfo(const aMsg: string);
begin
  Log(llInfo,aMsg);
end;

end.
