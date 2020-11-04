unit Business.Classes;

interface

uses
  System.Classes,
  System.SysUtils,
  Spring.Container.Common,
  {}
  Business.Interfaces;

type
  TApplicationRoot = class(TInterfacedObject, IApplicationRoot)
  private
    fDataModule: IDataModule;
  public
    [Inject]
    constructor Create(aDataModule: IDataModule);
    function ToString(): string; override;
  end;

  TDataModule = class(TInterfacedObject, IDataModule)
  private
    fOrderRepository: IOrderRepository;
    fSubModule: ISubModule;
  public
    [Inject]
    constructor Create(aSubModule: ISubModule;
      aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TSubModule = class(TInterfacedObject, ISubModule)
  private
    fOrderRepository: IOrderRepository;
  public
    [Inject]
    constructor Create(aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TOrderRepository = class(TInterfacedObject, IOrderRepository)
  private
    fId: string;
    fDatabaseConnection: IConnectionFactory;
  public
    [Inject]
    constructor Create(aDatabaseConnection: IConnectionFactory);
    function ToString(): string; override;
  end;

  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    fConnection: TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection(): TComponent;
  end;

implementation

const
  Indentation = '    ';

function IndentString(const s: string): string;
var
  sl: TStringList;
  iLine: Integer;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    for iLine := 0 to sl.Count - 1 do
      sl[iLine] := Indentation + sl[iLine];
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ TApplicationRoot }

constructor TApplicationRoot.Create(aDataModule: IDataModule);
begin
  self.fDataModule := aDataModule;
end;

function TApplicationRoot.ToString: string;
begin
  Result := Format('ApplicationRoot [%s]',
    [sLineBreak + IndentString(fDataModule.ToString)]);
end;

{ TDataModule }

constructor TDataModule.Create(aSubModule: ISubModule;
  aOrderRepository: IOrderRepository);
begin
  self.fSubModule := aSubModule;
  self.fOrderRepository := aOrderRepository;
end;

function TDataModule.ToString: string;
begin
  Result := Format('DataModule [%s]',
    [sLineBreak + IndentString(fOrderRepository.ToString) +
    IndentString(fSubModule.ToString)]);
end;

{ TSubModule }

constructor TSubModule.Create(aOrderRepository: IOrderRepository);
begin
  self.fOrderRepository := aOrderRepository;
end;

function TSubModule.ToString: string;
begin
  Result := Format('SubModule [%s]',
    [sLineBreak + IndentString(fOrderRepository.ToString())]);
end;

{ TOrderRepository }

constructor TOrderRepository.Create(aDatabaseConnection: IConnectionFactory);
begin
  self.fDatabaseConnection := aDatabaseConnection;
  self.fId := chr(ord('A') + random(24));
end;

function TOrderRepository.ToString: string;
var
  connection: TComponent;
begin
  connection := fDatabaseConnection.GetConnection();
  Result := Format('OrderRepository[%s, %s]', [fId,connection.Name]);
end;

{ TConnectionFactory }

var
  ConnectionId: integer = 1;

constructor TConnectionFactory.Create;
begin
  fConnection := nil;
end;

destructor TConnectionFactory.Destroy;
begin
  if fConnection = nil then
    fConnection.Free;
end;

function TConnectionFactory.GetConnection: TComponent;
begin
  if fConnection = nil then
  begin
    fConnection := TComponent.Create(nil);
    fConnection.Name := Format('Connection%.4d', [ConnectionId]);
    ConnectionId := ConnectionId + 1;
  end;
  Result := fConnection;
end;

end.
