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
var
  dow: Word;
begin
  dow := DayOfTheWeek(aDate);
  Result := Floor(aDate) + IfThen(dow <= 5, 5, 12) - dow;
end;

end.
