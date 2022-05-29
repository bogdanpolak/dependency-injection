unit Features.MembershipServiceC;

interface

uses
  System.Classes,
  System.SysUtils,
  Spring.Container.Common,
  {}
  Utils.InterfacedTrackingObject,
  DataLayer,
  Features.MembershipService;

type
  TMembershipService = class(TInterfacedTrackingObject, IMembershipService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function GetDependencyTree(): string;
    function IsCardActive(const aCardNumber: string): boolean;
  end;

implementation

{ TMembershipService }

constructor TMembershipService.Create(aDatabaseContext: IDatabaseContext);
begin
  inherited Create();
  fDatabaseContext := aDatabaseContext;
end;

function TMembershipService.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId() + '{' +
    fDatabaseContext.GetDependencyTree() + '}';
end;

function TMembershipService.IsCardActive(const aCardNumber: string): boolean;
var
  aNumber: integer;
begin
  Result := aCardNumber.StartsWith('A') and TryStrToInt(aCardNumber, aNumber)
    and (aNumber > 100);
end;

end.
