unit App.ParametersC;

interface

uses
  System.SysUtils,
  Spring.Container.Common,
  Spring.Collections,
  {-}
  App.Parameters,
  Utils.CmdParameters;

type
  TAppParameters = class(TInterfacedObject, IAppParameters)
  private
    fCmdParameters: ICmdParameters;
    __ParamDict: IDictionary<string, string>;
    function GetKeyParams(const key: string; out value: string): boolean;
  public
    [Inject]
    constructor Create(aCmdParameters: ICmdParameters);
    procedure ValidateParameters;
    function AppCommand: TAppCommand;
    function ShowDate: TDateTime;
    function ShowID: integer;
    function TicketRow: integer;
    function TicketSeats: IList<integer>;
  end;

implementation

constructor TAppParameters.Create(aCmdParameters: ICmdParameters);
begin
  fCmdParameters := aCmdParameters;
end;

function TAppParameters.GetKeyParams(const key: string;
  out value: string): boolean;
begin
  if __ParamDict = nil then
    __ParamDict := fCmdParameters.GetKeyValues;
  Result := __ParamDict.TryGetValue(key.ToLower, value);
end;

function TAppParameters.AppCommand: TAppCommand;
begin
  if fCmdParameters.HasNoParameters then
    Result := acDefault
  else if fCmdParameters.HasParameter('show') then
    Result := acShows
  else
    Result := acUnknown;
end;

function TAppParameters.ShowDate: TDateTime;
begin
  Result := 0;
end;

function TAppParameters.ShowID: integer;
begin
  Result := 0;
end;

function TAppParameters.TicketRow: integer;
begin
  Result := 0;
end;

function TAppParameters.TicketSeats: IList<integer>;
begin
  Result := TCollections.CreateList<integer>();
end;

procedure TAppParameters.ValidateParameters;
begin

end;

end.
