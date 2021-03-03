unit Test.Utils.DateTime;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework;

{$M+}
type
  [TestFixture]
  TestUtilsDateTime = class
  private
    actualDay: Integer;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
  published
    procedure Test1;
  end;

implementation

uses
  Utils.DateTime;

procedure TestUtilsDateTime.Setup;
begin
end;

procedure TestUtilsDateTime.TearDown;
begin
end;

function DayToStr(const aDay: integer): string;
begin
  Result := FormatDateTime('yyyy-mm-dd',aDay);
end;

procedure TestUtilsDateTime.Test1;
begin
  actualDay := TDateUtils.NextFriday(EncodeDate(2021,03,03));
  Assert.AreEqual('2021-03-05',DayToStr(actualDay));
end;

initialization
  TDUnitX.RegisterTestFixture(TestUtilsDateTime);

end.
