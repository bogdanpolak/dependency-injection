unit Utils.CmdParametersC;

interface

uses
  System.SysUtils,
  Spring.Collections,
  Utils.CmdParameters;

type
  TCmdParameters = class(TInterfacedObject, ICmdParameters)
  public
    function HasNoParameters: boolean;
    function HasParameter(const aName:string): boolean;
    function GetKeyValues: IDictionary<string,string>;
  end;

implementation

function TCmdParameters.GetKeyValues: IDictionary<string, string>;
var
  paramsWithKeys: IDictionary<string,string>;
  idx: Integer;
  item: string;
  i: Integer;
  key: string;
  value: string;
begin
  paramsWithKeys := TCollections.CreateDictionary<string,string>();
  for idx := 1 to ParamCount do
  begin
    item := ParamStr(idx);
    i := item.IndexOf('=');
    if i>1 then
    begin
      key := item.Substring(0,i-2);
      value := item.Substring(i,999);
      paramsWithKeys.Add(key.ToLower(),value);
    end;
  end;
  Result := paramsWithKeys;
end;

function TCmdParameters.HasNoParameters: boolean;
begin
  Result := ParamCount=0;
end;

function TCmdParameters.HasParameter(const aName: string): boolean;
var
  idx: Integer;
begin
  for idx := 1 to ParamCount do
    if ParamStr(idx).ToUpper = aName.ToUpper then
      Exit(true);
  Result := false;
end;

end.
