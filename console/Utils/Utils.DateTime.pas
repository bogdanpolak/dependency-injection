unit Utils.DateTime;

interface

uses
  System.Math,
  System.DateUtils;

type
  TDateUtils = class
    class function NextFriday(const aDate: TDateTime): integer; static;
  end;

implementation

class function TDateUtils.NextFriday(const aDate: TDateTime): integer;
begin
  Result := Floor(aDate) + 5 - DayOfTheWeek(aDate);
end;

end.
