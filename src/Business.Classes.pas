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
    fDataModule: IMainModule;
  public
    [Inject]
    constructor Create(aDataModule: IMainModule);
    function ToString(): string; override;
  end;

  TMainModule = class(TInterfacedObject, IMainModule)
  private
    fOrderRepository: IOrderRepository;
    fSubModule: IOrderManager;
  public
    [Inject]
    constructor Create(aSubModule: IOrderManager;
      aOrderRepository: IOrderRepository);
    function ToString(): string; override;
  end;

  TOrderManager = class(TInterfacedObject, IOrderManager)
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

constructor TApplicationRoot.Create(aDataModule: IMainModule);
begin
  self.fDataModule := aDataModule;
end;

function TApplicationRoot.ToString: string;
begin
  Result := Format('ApplicationRoot [%s]',
    [sLineBreak + IndentString(fDataModule.ToString)]);
end;

{ TMainModule }

constructor TMainModule.Create(aSubModule: IOrderManager;
  aOrderRepository: IOrderRepository);
begin
  self.fSubModule := aSubModule;
  self.fOrderRepository := aOrderRepository;
end;

function TMainModule.ToString: string;
begin
  Result := Format('MainModule [%s]',
    [sLineBreak + IndentString(fOrderRepository.ToString) +
    IndentString(fSubModule.ToString)]);
end;

{ TOrderManager }

constructor TOrderManager.Create(aOrderRepository: IOrderRepository);
begin
  self.fOrderRepository := aOrderRepository;
end;

function TOrderManager.ToString: string;
begin
  Result := Format('OrderManager [%s]',
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
