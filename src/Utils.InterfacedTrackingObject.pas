unit Utils.InterfacedTrackingObject;

interface

uses
  System.SysUtils;

type
  TInterfacedTrackingObject = class(TInterfacedObject)
  private
    fInstanceId: Cardinal;
  public
    constructor Create();
    function ClassNameWithInstanceId: string;
    property InstanceId: Cardinal read fInstanceId;
  end;

implementation

{ TInterfacedTrackingObject }

function TInterfacedTrackingObject.ClassNameWithInstanceId: string;
var
  s: string;
begin
  s := IntToHex(fInstanceId);
  s := s.Substring(1, 3) + '-' + s.Substring(4, 2);
  Result := Format('%s (%s)', [self.ClassName, s]);
end;

constructor TInterfacedTrackingObject.Create;
begin
  fInstanceId := TGuid.NewGuid().D1;
end;

end.
