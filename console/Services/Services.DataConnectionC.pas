unit Services.DataConnectionC;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Math,
  Spring.Collections,
  {-}
  Services.DataConnection,
  Utils.Logger,
  Model.Cinema;

type
  TDataConnection = class(TInterfacedObject, IDataConnection)
  private
    fMovies: IList<TMovie>;
    fShows: IList<TShow>;
    fConnected: boolean;
    fConnectionStr: string;
    fLogger: ILogger;
    procedure GuardConnected;
    function Popul(aIMDB: double; aInternalRate: integer): TPopularity;
    function Launch(aWeekNumber: integer): TDateTime;
  public
    constructor Create(aLogger: ILogger);
    procedure Connect(const aConnectionStr: string);
    function GetMovies: IEnumerable<TMovie>;
    function GetShows: IEnumerable<TShow>;
    procedure AddTicket(const aShow: TShow; aSeat: TSeat); overload;
    procedure AddTicket(const aShow: TShow;
      const aSeats: TArray<TSeat>); overload;
  end;

implementation

constructor TDataConnection.Create(aLogger: ILogger);
begin
  fConnected := false;
  fLogger := aLogger;
end;

function TDataConnection.Popul(aIMDB: double; aInternalRate: integer)
  : TPopularity;
begin
  Result := Min(Max(((round(aIMDB * aInternalRate) - 8) div 3) + 1, 1), 10);
end;

function TDataConnection.Launch(aWeekNumber: integer): TDateTime;
var
  dtStart: TDateTime;
  dtFriday: TDateTime;
begin
  dtStart := Int(Now) - 80 + aWeekNumber * 7;
  dtFriday := dtStart + 5 - DayOfTheWeek(dtStart);
  fLogger.LogInfo(DateToStr(dtFriday));
  Result := Int(Now) + aWeekNumber * 7;
end;

procedure TDataConnection.Connect(const aConnectionStr: string);
var
  Begining: TDateTime;
begin
  fConnectionStr := aConnectionStr;
  fMovies := TCollections.CreateObjectList<TMovie>([
    { } TMovie.New(Launch(0), 100, Popul(7.2, 5), 'A Quiet Place Part II'),
    { } TMovie.New(Launch(0), 103, Popul(6.3, 3), 'Freaky'),
    { } TMovie.New(Launch(1), 95, Popul(7.0, 4), 'The Croods: A New Age'),
    { } TMovie.New(Launch(1), 93, Popul(6.2, 1), 'All My Life'),
    { } TMovie.New(Launch(2), 96, Popul(5.9, 1), 'Half Brothers'),
    { } TMovie.New(Launch(2), 125, Popul(6.2, 2), 'Pinocchio'),
    { } TMovie.New(Launch(3), 103, Popul(6.6, 4), 'Jumanji: Level One'),
    { } TMovie.New(Launch(4), 95, Popul(6.7, 3), 'Supernova'),
    { } TMovie.New(Launch(4), 107, Popul(6.9, 3), 'Little Fish'),
    { } TMovie.New(Launch(5), 129, Popul(7.1, 2), 'The Mauritanian'),
    { } TMovie.New(Launch(6), 101, Popul(6.6, 4), 'Tom and Jerry'),
    { } TMovie.New(Launch(6), 105, Popul(6.9, 3), 'Godzilla vs.Kong'),
    { } TMovie.New(Launch(7), 93, Popul(7.1, 3), 'Peter Rabbit 2: The Runaway'),
    { } TMovie.New(Launch(8), 133, Popul(7.2, 5), 'Black Widow'),
    { } TMovie.New(Launch(9), 94, Popul(6.1, 2), 'Ghostbusters: Afterlife'),
    { } TMovie.New(Launch(10), 89, Popul(7.2, 4), 'Top Gun: Maverick'),
    { } TMovie.New(Launch(11), 98, Popul(7.9, 5), 'Dune'),
    { } TMovie.New(Launch(11), 102, Popul(6.7, 5), 'Mission: Impossible 7'),
    { } TMovie.New(Launch(12), 117, Popul(7.8, 5), 'The Matrix 4'),
    { } TMovie.New(Launch(12), 103, Popul(6.2, 3), 'Sherlock Holmes 3')]);

  fShows := TCollections.CreateObjectList<TShow>();
end;

procedure TDataConnection.AddTicket(const aShow: TShow; aSeat: TSeat);
begin
  GuardConnected;
end;

procedure TDataConnection.AddTicket(const aShow: TShow;
  const aSeats: TArray<TSeat>);
begin
  GuardConnected;
end;

function TDataConnection.GetMovies: IEnumerable<TMovie>;
begin
  GuardConnected;
  Result := fMovies;
end;

function TDataConnection.GetShows: IEnumerable<TShow>;
begin
  GuardConnected;
  Result := fShows;
end;

procedure TDataConnection.GuardConnected;
begin

end;

end.
