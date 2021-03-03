unit Services.DataConnectionC;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Math,
  Spring,
  Spring.Collections,
  {-}
  Services.DataConnection,
  Utils.Logger,
  Model.Cinema;

type
  TDataConnection = class(TInterfacedObject, IDataConnection)
  private const
    DaysBeforeToGenerateForMovies = 80;
    DaysBeforeToGenerateForShows = 60;
  private
    fMovies: IList<TMovie>;
    fShows: IList<TShow>;
    fRooms: IList<TRoom>;
    fConnected: boolean;
    fConnectionStr: string;
    fLogger: ILogger;
    procedure GuardConnected;
    procedure LogGeneratedData;
    // ----
    function Popul(aIMDB: double; aInternalRate: integer): TPopularity;
    function Launch(aWeekNumber: integer): TDateTime;
    function GenerateMovies: IList<TMovie>;
    // ----
    function GenerateRooms: IList<TRoom>;
    // ----
    function GenerateShows(const aMovies: IEnumerable<TMovie>;
      const aRooms: IEnumerable<TRoom>): IList<TShow>;
    function ThatWeekFriday(dtStart: TDateTime): integer;
    function MoviesForTheWeek(const aMovies: IEnumerable<TMovie>;
      const aStartDay: integer; const aMoviesNo: integer): IEnumerable<TMovie>;
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

uses
  Utils.DateTime;

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
begin
  dtStart := Int(Now) - DaysBeforeToGenerateForMovies + 7 * aWeekNumber;
  Result := ThatWeekFriday(dtStart);
end;

procedure TDataConnection.Connect(const aConnectionStr: string);
begin
  fConnectionStr := aConnectionStr;
  fMovies := GenerateMovies;
  fRooms := GenerateRooms;
  fShows := GenerateShows(fMovies, fRooms);
  fConnected := True;
  LogGeneratedData();
end;

procedure TDataConnection.LogGeneratedData();
var
  lastDay: TDateTime;
begin
  fLogger.LogInfo('Counters');
  fLogger.LogInfo(Format('  * Movies: %d', [fMovies.count]));
  fLogger.LogInfo(Format('  * Shows: %d', [fShows.count]));
  lastDay := 0;
  fShows.ForEach(
    procedure(const show: TShow)
    begin
      if lastDay <> Floor(show.Start) then
        fLogger.LogInfo(FormatDateTime('dd.mm.yyyy', show.Start));
      lastDay := Floor(show.Start);
      fLogger.LogInfo(Format('    %s - %s', [FormatDateTime('hh:nn',
        show.Start), show.movie.Name]));
    end);
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

function TDataConnection.GenerateMovies: IList<TMovie>;
begin
  Result := TCollections.CreateObjectList<TMovie>([
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
end;

function TDataConnection.GenerateRooms: IList<TRoom>;
begin
  Result := TCollections.CreateObjectList<TRoom>([
  { } TRoom.New(40, 45, 'Room 1')]);
end;

function TDataConnection.ThatWeekFriday(dtStart: TDateTime): integer;
begin
  Result := Floor(dtStart + 5 - DayOfTheWeek(dtStart));
end;

const
  WorkingHoursConst: array [1 .. 7] of string = ( // Monday .. Sunday
  '18:30-22:00', // (1) Monday
  '18:30-22:00', // (2) Tuesday
  '18:30-23:00', // (3) Wednesday
  '18:30-23:00', // (4) Thursday
  '17:30-00:30', // (5) Friday
  '12:30-00:00', // (6) Saturday
  '11:30-23:00' // (7) Sunday
    );

type
  TTimeRange = record
    From: TDateTime;
    Till: TDateTime;
  end;

function ParseTimeRange(day: TDateTime): TTimeRange;
var
  strRange: string;
  range: TArray<string>;
begin
  strRange := WorkingHoursConst[DayOfTheWeek(day)];
  range := strRange.Split(['-']);
  Result.From := StrToTime(range[0]);
  Result.Till := StrToTime(range[1]);
  if Result.From > Result.Till then
    Result.Till := Result.Till + 1;
end;

function LenghtToTime(length: integer): TDateTime;
var
  mm: word;
begin
  mm := Ceil(length / 10) * 10;
  Result := mm / 24 / 60;
end;

function TDataConnection.MoviesForTheWeek(const aMovies: IEnumerable<TMovie>;
const aStartDay: integer; const aMoviesNo: integer): IEnumerable<TMovie>;
var
  list: IList<Tuple<TMovie, integer>>;
  availableMovies: IEnumerable<TMovie>;
  idx: integer;
  i: integer;
  movie: TMovie;
  enumerator: IEnumerator<TMovie>;
  rank: integer;
  moviesForWeek: IList<TMovie>;
  j: integer;
begin
  availableMovies := aMovies.Where(
    function(const m: TMovie): boolean
    begin
      Result := Floor(m.Launch) <= aStartDay;
    end);
  list := TCollections.CreateList < Tuple < TMovie, integer >> ();
  enumerator := availableMovies.GetEnumerator;
  for i := 0 to aMoviesNo - 1 do
  begin
    if not enumerator.MoveNext then
    begin
      enumerator := availableMovies.GetEnumerator;
      enumerator.MoveNext;
    end;
    movie := enumerator.Current;
    rank := random(10 + movie.Popularity -
      (aStartDay - Floor(movie.Launch)) div 3);
    list.Add(Tuple.Create<TMovie, integer>(movie, rank));
  end;
  list.Sort(
    function(const aLeft: Tuple<TMovie, integer>;
      const aRight: Tuple<TMovie, integer>): integer
    begin
      Result := 0 - CompareValue(aLeft.Value2, aRight.Value2);
    end);
  moviesForWeek := TCollections.CreateList<TMovie>();
  list.ForEach(
    procedure(const item: Tuple<TMovie, integer>)
    begin
      moviesForWeek.Add(item.Value1);
    end);
  idx := 1;
  while idx < moviesForWeek.count - 1 do
  begin
    if moviesForWeek[idx - 1] = moviesForWeek[idx] then
    begin
      j := idx + 1;
      while (j < moviesForWeek.count) and
        (moviesForWeek[j] = moviesForWeek[idx]) do
        inc(j);
      if (j < moviesForWeek.count) then
      begin
        movie := moviesForWeek[idx];
        moviesForWeek[idx] := moviesForWeek[j];
        moviesForWeek[j] := movie;
      end;
      idx := 0;
    end;
    inc(idx);
  end;
  Result := moviesForWeek;
end;

function TDataConnection.GenerateShows(const aMovies: IEnumerable<TMovie>;
const aRooms: IEnumerable<TRoom>): IList<TShow>;
var
  dayStart: integer;
  dayEnd: integer;
  day: integer;
  show: TShow;
  movieEnum: IEnumerator<TMovie>;
  timeRange: TTimeRange;
  startTime: TDateTime;
  movie1: TMovie;
  nextShowTime: TDateTime;
  movies: IEnumerable<TMovie>;
begin
  Result := TCollections.CreateObjectList<TShow>();
  dayStart := ThatWeekFriday(Now() - DaysBeforeToGenerateForShows);
  dayEnd := TDateUtils.NextFriday(Now) + 13;
  for day := dayStart to dayEnd do
  begin
    if DayOfTheWeek(day) = 5 then
    begin
      movies := MoviesForTheWeek(aMovies, day, aRooms.count * 40);
      movieEnum := movies.GetEnumerator;
      movieEnum.MoveNext;
    end;
    timeRange := ParseTimeRange(day);
    startTime := timeRange.From;
    while (startTime < timeRange.Till) do
    begin
      movie1 := movieEnum.Current;
      nextShowTime := startTime + LenghtToTime(movie1.length + 25);
      if (nextShowTime < timeRange.Till) then
      begin
        show := TShow.New(aRooms.First, movie1, day + startTime);
        Result.Add(show);
        movieEnum.MoveNext;
      end;
      startTime := nextShowTime;
    end;
  end;
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
  Assert(fConnected);
end;

end.
