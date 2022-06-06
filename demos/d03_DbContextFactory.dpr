program d03_DbContextFactory;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  Spring.Container,
  {}
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  {}
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  IDbContext = interface
    ['{F4653C0C-2C05-4348-A744-3288E520F586}']
    procedure Execute;
  end;

  IDbContextFactory = interface(IInvokable)
    ['{F632D1FB-9C34-48FD-BD72-6BBC436D1B47}']
    function Create(const aConnectionString: string): IDbContext; overload;
  end;

type
  TDbContext = class(TInterfacedObject, IDbContext)
  private
    fOwner: TComponent;
    fConnectionString: string;
  public
    constructor Create(const aConnectionString: string);
    destructor Destroy; override;

    procedure Execute;
  end;

  { TDbContext }

constructor TDbContext.Create(const aConnectionString: string);
begin
  fConnectionString := aConnectionString;
  fOwner := TComponent.Create(nil);
end;

destructor TDbContext.Destroy;
begin
  fOwner.Free;
  inherited;
end;

procedure TDbContext.Execute;
var
  query: TFDQuery;
  connection: TFDConnection;
begin
  writeln(Format('Connection: "%s"', [fConnectionString]));
  connection := TFDConnection.Create(fOwner);
  connection.ConnectionString := fConnectionString;
  query := TFDQuery.Create(fOwner);
  query.connection := connection;
  query.Open('SELECT prod.ProductId, prod.ProductName, prod.SupplierId, ' +
    '  sup.CompanyName as SupplierName, sup.City as SupplierCity, ' +
    '  prod.CategoryId, cat.CategoryName as CategoryName, ' +
    '  prod.QuantityPerUnit, prod.UnitPrice, prod.UnitsInStock, ' +
    '  prod.UnitsOnOrder, prod.ReorderLevel, prod.Discontinued ' +
    'FROM {id Products} prod ' +
    '  INNER JOIN {id Suppliers} sup ON prod.SupplierId = sup.SupplierId ' +
    '  INNER JOIN {id Categories} cat ON cat.CategoryId = prod.CategoryId ');
  query.FetchAll;
  writeln(Format('Loaded rows: %d', [query.RecordCount]));
end;

{ Demo }

procedure RunDemo;
var
  dbContextFactory: IDbContextFactory;
  context: IDbContext;
  ConnectionString: string;
begin
  GlobalContainer.RegisterType<IDbContext, TDbContext>;
  GlobalContainer.RegisterType<IDbContextFactory>.AsFactory;
  GlobalContainer.Build;
  dbContextFactory := GlobalContainer.Resolve<IDbContextFactory>();

  // bussines logic:
  randomize;
  case random(2) of
    0:
      ConnectionString := 'DriverID=FB;' +
        'Server=localhost;Database=c:\database\fddemo.fdb;' +
        'User_name=sysdba;Password=masterkey';
    1:
      ConnectionString := 'DriverID=SQLite;' +
        'Server=localhost;Database=c:\database\fddemo.sdb';
  end;
  context := dbContextFactory.Create(ConnectionString);
  context.Execute;
end;

begin
  try
    ReportMemoryLeaksOnShutdown := true;
    RunDemo;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
