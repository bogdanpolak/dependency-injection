unit Generator.Utils.RoomStartTimes;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Spring.Collections,
  Model.Cinema;

type
  TWeek = 1..7;

  TTimeRange = record
    From: TDateTime;
    Till: TDateTime;
  end;

  TRoomStartTimes = class
  private
    fShowStarts: IList<TDateTime>;
    fRooms: IEnumerable<TRoom>;
    fTimeRange: TTimeRange;
    fDay: integer;
    fWorkingHours: IList<string>;
    function ParseTimeRange(day: TDateTime): TTimeRange;
  public
    constructor Create(const aRooms: IEnumerable<TRoom>;
      const aWorkingHours: array of string);
    function Init(const aDay: integer): TTimeRange;
    function TryGetSlot(const aLength: integer; out aStartDate: TDateTime;
      out aRoom: TRoom): boolean;
  end;


implementation


constructor TRoomStartTimes.Create(const aRooms: IEnumerable<TRoom>;
  const aWorkingHours: array of string);
begin
  fRooms := aRooms;
  fWorkingHours := TCollections.CreateList<string>(aWorkingHours);
  fShowStarts := TCollections.CreateList<TDateTime>();
end;


function TRoomStartTimes.Init(const aDay: integer): TTimeRange;
var
  idx: Integer;
begin
  fDay := aDay;
  fTimeRange := ParseTimeRange(aDay);
  fShowStarts.Count := fRooms.Count;
  for idx := 0 to fRooms.Count-1 do
    fShowStarts[idx] := fTimeRange.From;
end;


function LenghtToTime(const aLength: integer): TDateTime;
begin
  Result := aLength/24/60;
end;


function TRoomStartTimes.TryGetSlot(const aLength: integer;
  out aStartDate: TDateTime; out aRoom: TRoom): boolean;
var
  idx: Integer;
  endTime: TDateTime;
begin
  idx := fShowStarts.IndexOf(fShowStarts.Min());
  endTime := fShowStarts[idx] + LenghtToTime(aLength);
  if (endTime  <= fTimeRange.Till) then
  begin
    aStartDate := fDay+fShowStarts[idx];
    aRoom := fRooms.ElementAt(idx);
    fShowStarts[idx] := endTime;
    Exit( true);
  end;
  aStartDate := 0;
  aRoom := nil;
  Result := False;
end;


function TRoomStartTimes.ParseTimeRange(day: TDateTime): TTimeRange;
var
  strRange: string;
  range: TArray<string>;
begin
  strRange := fWorkingHours[DayOfTheWeek(day)-1];
  range := strRange.Split(['-']);
  Result.From := StrToTime(range[0]);
  Result.Till := StrToTime(range[1]);
  if Result.From > Result.Till then
    Result.Till := Result.Till + 1;
end;

end.
