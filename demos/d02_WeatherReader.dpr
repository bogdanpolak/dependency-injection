program d02_WeatherReader;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  System.Threading,
  Spring.Container,
  Spring.Container.Common,
  Spring.Collections,
  {}
  WeatherFromTimeAndDate in 'WeatherFromTimeAndDate.pas',
  Utils.Diagnostics in 'Utils.Diagnostics.pas';

type
  IWeatherService = interface(IInvokable)
    ['{09FE4A43-F9CD-4134-873C-593D64441E8E}']
    function GetWeather(const aLocation: string): TJsonObject;
  end;

  IJsonCache = interface(IInvokable)
    ['{1175AB8A-6975-4831-854F-4E952E148B1B}']
    function TryGet(
      const aKey: string;
      out aValue: TJsonValue): boolean;
    procedure Add(
      const aKey: string;
      const aValue: TJsonValue);
  end;

  TWeatherService = class(TInterfacedObject, IWeatherService)
  private
    fJsonCache: IJsonCache;
  public
    [Inject]
    constructor Create(const aJsonCache: IJsonCache);
    function GetWeather(const aLocation: string): TJsonObject;
  end;

  TJsonCache = class(TInterfacedObject, IJsonCache)
    fJsonCache: IDictionary<string, TJsonValue>;
  public
    constructor Create();
    function TryGet(
      const aKey: string;
      out aValue: TJsonValue): boolean;
    procedure Add(
      const aKey: string;
      const aValue: TJsonValue);
  end;

constructor TWeatherService.Create(const aJsonCache: IJsonCache);
begin
  fJsonCache := aJsonCache;
end;

function TWeatherService.GetWeather(const aLocation: string): TJsonObject;
var
  response: string;
  jsonValue: TJsonValue;
  jsonWeather: TJsonObject;
begin
  if fJsonCache.TryGet(aLocation, jsonValue) then
    Exit(jsonValue as TJsonObject);
  response := TWeatherFromTimeAndDate.Get(aLocation);
  jsonWeather := TJsonObject.ParseJSONValue(response) as TJsonObject;
  fJsonCache.Add(aLocation, jsonWeather);
  Result := jsonWeather;
end;

{ TJsonCache }

constructor TJsonCache.Create;
begin
  fJsonCache := TCollections.CreateDictionary<string, TJsonValue>
    ([doOwnsValues]);
end;

procedure TJsonCache.Add(
  const aKey: string;
  const aValue: TJsonValue);
begin
  TMonitor.Enter(self);
  try
    fJsonCache.Add(aKey, aValue);
  finally
    TMonitor.Exit(self);
  end;
end;

function TJsonCache.TryGet(
  const aKey: string;
  out aValue: TJsonValue): boolean;
begin
  TMonitor.Enter(self);
  try
    Result := fJsonCache.TryGetValue(aKey, aValue);
  finally
    TMonitor.Exit(self);
  end;
end;

{ Console Application }

procedure BuildGlobalContainer();
begin
  GlobalContainer.RegisterType<IWeatherService, TWeatherService>.AsSingleton();
  GlobalContainer.RegisterType<IJsonCache, TJsonCache>();
  GlobalContainer.Build;
end;

procedure DemoRun();
var
  location: string;
  actionName: string;
  getWeatherProc: TProc;
  weatherService: IWeatherService;
  jWeather: TJsonObject;
begin
  location := 'usa/new-york';
  getWeatherProc := procedure
    begin
      weatherService := GlobalContainer.Resolve<IWeatherService>();
      jWeather := weatherService.GetWeather(location);
      writeln(Format('  - temperature %s,   description: %s',
        [jWeather.GetValue<string>('temperature'),
        jWeather.GetValue<string>('description')]));
    end;

  actionName := Format('Get %s weather', [location]);
  TDiagnostics.MeasureTimeSpan(actionName, getWeatherProc);
  TDiagnostics.MeasureTimeSpan(actionName, getWeatherProc);
end;

function CreateTask(const aLocation: string): ITask;
begin
  Result := TTask.Create(
    procedure
    begin
      writeln(Format('  - %s: %s', [aLocation,
        GlobalContainer.Resolve<IWeatherService>.GetWeather(aLocation)
        .GetValue<string>('temperature')]));
    end);
end;

procedure AsyncDemoRun();
var
  locations: TArray<string>;
  tasks: IList<ITask>;
  task: ITask;
  loc: string;
begin
  locations := ['usa/new-york', 'uk/london', 'poland/warsaw', 'vietnam/hanoi',
    'russia/yakutsk', 'usa/los-angeles', 'south-africa/cape-town',
    'australia/sydney', 'chile/santiago', 'israel/jerusalem',
    'puerto-rico/san-juan'];
  tasks := TCollections.CreateList<ITask>();
  for loc in locations do
    tasks.Add(CreateTask(loc));
  for task in tasks do
    task.Start;
  TTask.WaitForAll(tasks.ToArray);
end;

// Cache will not work correctly for duplicated values. Why? Fix?
// locations := ['poland/warsaw', 'poland/warsaw', 'poland/warsaw',
// 'poland/warsaw', 'poland/warsaw', 'poland/warsaw', 'poland/warsaw'];

begin
  // https://www.timeanddate.com/weather/poland/warsaw
  try
    ReportMemoryLeaksOnShutdown := true;
    BuildGlobalContainer();
    DemoRun;
    writeln('-----------------------------------------');
    AsyncDemoRun();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
