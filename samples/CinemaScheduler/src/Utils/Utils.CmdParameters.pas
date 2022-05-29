unit Utils.CmdParameters;

interface

uses
  Spring.Collections;

type
  ICmdParameters = interface(IInvokable)
    ['{98B839BF-B07F-41CC-84DF-BFB0648E0887}']
    function HasNoParameters: boolean;
    function HasParameter(const aName:string): boolean;
    function GetKeyValues: IDictionary<string,string>;
  end;

implementation

end.
