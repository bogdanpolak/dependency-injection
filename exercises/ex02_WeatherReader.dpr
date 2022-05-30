program ex02_WeatherReader;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Spring.Container,
  Spring.Collections,
  WeatherFromTimeAndDate in 'WeatherFromTimeAndDate.pas',
  Utils.Diagnostics in 'Utils.Diagnostics.pas';

type
  IWeatherService = interface(IInterface)
    ['{09FE4A43-F9CD-4134-873C-593D64441E8E}']
    function GetWeather(const aLocation: string): TJsonObject;
  end;

  TWeatherService = class(TInterfacedObject, IWeatherService)
  private
    cache: IDictionary<string,TJSONObject>;
  public
    constructor Create;
    function GetWeather(const aLocation: string): TJsonObject;
  end;

constructor TWeatherService.Create;
begin
  inherited;
  cache := TCollections.CreateDictionary<string,TJsonObject>([doOwnsValues]);
end;

function TWeatherService.GetWeather(const aLocation: string): TJsonObject;
var
  response: string;
  jsonWeather: TJSONObject;
begin
  if cache.TryGetValue(aLocation, jsonWeather) then
    Exit(jsonWeather);
  response := TWeatherFromTimeAndDate.Get('usa/new-york');
  jsonWeather := TJsonObject.ParseJSONValue(response) as TJsonObject;
  cache.Add(aLocation, jsonWeather);
  Result := jsonWeather;
end;

procedure ExerciseRun();
var
  weatherService: IWeatherService;
  jsonWeather: TJsonObject;
  s: string;
begin
  // https://www.timeanddate.com/weather/usa/new-york
  // https://www.timeanddate.com/weather/uk/london
  // https://www.timeanddate.com/weather/poland/warsaw
  GlobalContainer.RegisterType<IWeatherService, TWeatherService>.AsSingleton();
  GlobalContainer.Build;
  TDiagnostics.MeasureTimeSpan('Get weather',
    procedure
    begin
      writeln('  -> ', GlobalContainer.Resolve<IWeatherService> { }
        .GetWeather('usa/new-york').ToString);
    end);
  TDiagnostics.MeasureTimeSpan('Get weather',
    procedure
    begin
      writeln('  -> ', GlobalContainer.Resolve<IWeatherService> { }
        .GetWeather('usa/new-york').ToString);
    end);
  ReportMemoryLeaksOnShutdown := true;
end;

begin
  try
    ExerciseRun;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
