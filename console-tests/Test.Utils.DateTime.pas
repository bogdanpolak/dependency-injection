unit Test.Utils.DateTime;

interface

uses
  System.Math,
  System.SysUtils,
  System.DateUtils,
  DUnitX.TestFramework;

{$M+}
type
  [TestFixture]
  TestUtilsDateTime = class
  public
    [Test]
    [TestCase('Wednesday','2021-03-03,2021-03-05')]
    [TestCase('Thurday','2021-03-04,2021-03-05')]
    [TestCase('Friday','2021-03-05,2021-03-05')]
    [TestCase('Saturday','2021-03-06,2021-03-12')]
    [TestCase('Sunday','2021-03-07,2021-03-12')]
    [TestCase('Monday','2021-03-08,2021-03-12')]
    [TestCase('Wednesday+1w','2021-03-10,2021-03-12')]
    procedure NextFriday(const aDay, aExpectedFriday: string);
  end;

implementation

uses
  Utils.DateTime;

function DayToStr(const aDay: integer): string;
begin
  Result := FormatDateTime('yyyy-mm-dd',aDay);
end;

procedure TestUtilsDateTime.NextFriday(const aDay, aExpectedFriday: string);
var
  day: integer;
  actualDay: Integer;
begin
  // ARRANGE:
  day := Floor(ISO8601ToDate(aDay));
  // ACT:
  actualDay := TDateUtils.NextFriday(day);
  // ASSERT:
  Assert.AreEqual(aExpectedFriday,DayToStr(actualDay));
end;

initialization
  TDUnitX.RegisterTestFixture(TestUtilsDateTime);

end.
