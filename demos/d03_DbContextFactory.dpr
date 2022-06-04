program d03_DbContextFactory;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Rtti,
  System.SysUtils,
  Spring.Container;

type
  IDbContext = interface
    ['{F4653C0C-2C05-4348-A744-3288E520F586}']
    procedure Connect;
  end;

  IDbContextFactory = interface(IInvokable)
    ['{F632D1FB-9C34-48FD-BD72-6BBC436D1B47}']
    function Create(const aConnectionString: string): IDbContext; overload;
  end;

  TDbContext = class(TInterfacedObject, IDbContext)
  private
    fConnectionString: string;
  public
    constructor Create(const aConnectionString: string);

    procedure Connect;
  end;

constructor TDbContext.Create(const aConnectionString: string);
begin
  inherited Create;
  fConnectionString := aConnectionString
end;

procedure TDbContext.Connect;
begin
  Writeln('Connection Definition Name: ', fConnectionString);
end;

procedure RunDemo;
var
  dbContextFactory: IDbContextFactory;
  context: IDbContext;
  aDefeniotion: string;
begin
  randomize;

  GlobalContainer.RegisterType<IDbContext, TDbContext>;
  GlobalContainer.RegisterType<IDbContextFactory>.AsFactory;
  GlobalContainer.Build;

  // dependency tree:
  dbContextFactory := GlobalContainer.Resolve<IDbContextFactory>();

  // bussines logic:
  case random(3) of
    0: aDefeniotion := 'SQLite_Employees_local';
    1: aDefeniotion := 'PostgreSql_Employees_Dev';
    2: aDefeniotion := 'PostgreSql_AWS';
  end;
  context := dbContextFactory.Create(aDefeniotion);
  context.Connect;
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.

