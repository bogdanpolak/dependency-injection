unit Utils.DeveloperMode;

interface

function IsDeveloperMode(): boolean;

implementation

function IsDeveloperMode(): boolean;
begin
  // TODO: Check is dpr file exists
  // 1. Get ParamStr(0)
  // 2. change extenton to dpr and check if exist in current folder or in ..\..\
  Result := True;
end;

end.
