unit DataLayerC;

interface

uses
  System.SysUtils,
  System.Classes,
  Spring.Container.Common,
  {}
  DataLayer,
  Utils.InterfacedTrackingObject;

type
  TDatabaseContext = class(TInterfacedTrackingObject, IDatabaseContext)
  private
    fIdent: integer;
    fDatabaseConnection: IConnectionFactory;
  public
    [Inject]
    constructor Create(aDatabaseConnection: IConnectionFactory);
    function GetDependencyTree(): string;
  end;

type
  TConnectionFactory = class(TInterfacedTrackingObject, IConnectionFactory)
  private
    fConnection: TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection(): TComponent;
    function GetDependencyTree(): string;
  end;

implementation

{ TDatabaseContext }

var
  DatabaseContextCounter: integer = 1;

constructor TDatabaseContext.Create(aDatabaseConnection: IConnectionFactory);
begin
  inherited Create();
  self.fDatabaseConnection := aDatabaseConnection;
  self.fIdent := DatabaseContextCounter;
  DatabaseContextCounter := DatabaseContextCounter + 1;
end;

function TDatabaseContext.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId() + '{' +
    fDatabaseConnection.GetDependencyTree() + '}';
end;

{ TConnectionFactory }

constructor TConnectionFactory.Create;
begin
  inherited Create();
  fConnection := nil;
end;

destructor TConnectionFactory.Destroy;
begin
  if fConnection <> nil then
    fConnection.Free;
end;

function TConnectionFactory.GetConnection: TComponent;
begin
  if fConnection = nil then
  begin
    fConnection := TComponent.Create(nil);
    fConnection.Name := Format('Connection%d', [InstanceId mod 100]);
  end;
  Result := fConnection;
end;

function TConnectionFactory.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId();
end;

end.

