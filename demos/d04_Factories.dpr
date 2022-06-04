program d04_Factories;

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

  TMainService = class(TInterfacedObject, IMainService)
  private
    fConnectionFactory: IFactory<IDbConnection>;
  public
    constructor Create(const aConnectionFactory: IFactory<IDbConnection>);
    procedure Connect(const aToken: string);
    procedure Run();
  end;

  TDbConnection = class(TInterfacedObject, IDbConnection)
  private
    fToken: string;
  public
    constructor Create();  // const aToken: string
    procedure ExecuteSql(const aSql: string);
  end;

  TGlobalToken = class
  class var
    Value: string;
  end;

  { ---------------------------------------------------------- }
  { TMainService }

procedure TMainService.Connect(const aToken: string);
begin
  TGlobalToken.Value := aToken;
end;

constructor TMainService.Create(const aConnectionFactory: IFactory<IDbConnection>);
begin
  fConnectionFactory := aConnectionFactory;
end;

procedure TMainService.Run;
var
  connection: IDbConnection;
begin
  connection := fConnectionFactory();
  connection.ExecuteSql('SELECT * FROM table');
end;

{ ---------------------------------------------------------- }
{ TDbConnection }

constructor TDbConnection.Create();
begin
  fToken := TGlobalToken.Value;
  writeln(Format('1. Connect to SQL database usnig token "%s"', [fToken]));
end;

procedure TDbConnection.ExecuteSql(const aSql: string);
begin
  writeln(Format('2. Executed SQL: "%s" using token "%s"', [aSql, fToken]));
end;

{ ---------------------------------------------------------- }

procedure RunDemo();
var
  mainService: IMainService;
begin
  GlobalContainer.RegisterType<IMainService, TMainService>();
  GlobalContainer.RegisterType<IDbConnection, TDbConnection>();
  GlobalContainer.RegisterFactory<IFactory<IDbConnection>>();
  GlobalContainer.Build;
  mainService := GlobalContainer.Resolve<IMainService>();
  mainService.Connect('F8188F61-5A7F');
  mainService.Run();
  readln;
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
