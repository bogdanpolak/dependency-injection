program d05_Factories;

// https://delphisorcery.blogspot.com/search?q=Dependency+Injection

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container,
  Spring.Container.Common,
  Spring;

type
  IMainService = interface
    ['{333CAFBE-E9C7-4F1C-9ECA-5F070523007E}']
    procedure Connect(const aToken: string);
    procedure Run();
  end;

  IDbConnection = interface
    ['{6DCC3C50-A008-437C-8821-7A637DBB9BBA}']
    procedure ExecuteSql(const aSql: string);
  end;

{$M+}
  TConnectionFactory = reference to function(const aToken: string)
    : IDbConnection;
{$M-}

type
  TMainService = class(TInterfacedObject, IMainService)
  private
    fConnectionFactory: TConnectionFactory;
    fToken: string;
  public
    constructor Create(const aConnectionFactory: TConnectionFactory);
    procedure Connect(const aToken: string);
    procedure Run();
  end;

  TDbConnection = class(TInterfacedObject, IDbConnection)
  private
    fToken: string;
  public
    constructor Create(const aToken: string);
    procedure ExecuteSql(const aSql: string);
  end;

{ --------------------------------------------------------------- }
{ TMainService }

constructor TMainService.Create(const aConnectionFactory: TConnectionFactory);
begin
  fConnectionFactory := aConnectionFactory;
end;

procedure TMainService.Connect(const aToken: string);
begin
  fToken := aToken;
end;

procedure TMainService.Run;
var
  connection: IDbConnection;
  aToken: string;
begin
  aToken := fToken;
  connection := fConnectionFactory(aToken);
  connection.ExecuteSql('SELECT * FROM table');
end;

{ --------------------------------------------------------------- }
{ TDbConnection }

constructor TDbConnection.Create(const aToken: string);
begin
  fToken := aToken;
  writeln(Format('1. Connect to SQL database usnig token "%s"', [fToken]));
end;

procedure TDbConnection.ExecuteSql(const aSql: string);
begin
  writeln(Format('2. Executed SQL: "%s" using token "%s"', [aSql, fToken]));
end;

{ --------------------------------------------------------------- }

procedure RunDemo();
var
  mainService: IMainService;
begin
  GlobalContainer.RegisterType<IMainService, TMainService>();
  GlobalContainer.RegisterType<IDbConnection, TDbConnection>();
  GlobalContainer.RegisterType<TConnectionFactory>().AsFactory();
  GlobalContainer.Build;
  mainService := GlobalContainer.Resolve<IMainService>();
  mainService.Connect('F8188F61-5A7F');
  mainService.Run();
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end.
