unit Utils.Logger;

interface

type
  TLogLevel = (llError,llWarning,llInfo);

type
  ILogger = interface(IInvokable)
    ['{02CD4A72-D894-45AE-ACB1-BB327964B987}']
    procedure  Log (aLogLevel: TLogLevel; const aMsg: string);
    procedure  LogInfo (const aMsg: string);
  end;

implementation

end.
